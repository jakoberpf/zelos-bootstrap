locals {
  vars_yaml = yamldecode(file("terragrunt.yaml"))
  ssh = local.vars_yaml.ssh
  oci_credentials = local.vars_yaml.oci
  cloudflare_credentials = local.vars_yaml.cloudflare
  terraform = local.vars_yaml.terraform
}

terraform {
    extra_arguments "custom_vars" {
    commands = [
      "apply",
      "plan",
      "import",
      "push",
      "refresh"
    ]
    required_var_files = ["${get_parent_terragrunt_dir()}/variables.tfvars"]
  }
}

generate "backend" {
  path      = "generated.backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "s3" {
    bucket         = "${local.terraform.backend.bucket}"
    key            = "${local.terraform.backend.key}"
    region         = "${local.terraform.backend.region}"
    encrypt        = true
    kms_key_id     = "${local.terraform.backend.kms_key_id}"
    dynamodb_table = "${local.terraform.backend.dynamodb_table}"
  }
  required_providers {
    oci = {
      source = "hashicorp/oci"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}
EOF
}

generate "provider" {
  path = "generated.providers.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
%{for key, content in local.oci_credentials}
provider "oci" {
  alias            = "${content.id}"
  tenancy_ocid     = "${content.tenancy_ocid}"
  user_ocid        = "${content.user_ocid}"
  fingerprint      = "${content.fingerprint}"
  private_key_path = "${content.private_key_path}"
  region           = "${content.region}"
}
%{endfor}

provider "cloudflare" {
  email   = "${local.cloudflare_credentials.email}"
  api_key = "${local.cloudflare_credentials.api_key}"
}

EOF
}

generate "compartments" {
  path = "generated.compartments.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
%{for key, content in local.oci_credentials}
resource "oci_identity_compartment" "compartment-${content.id}" {
    provider = oci.${content.id}
    compartment_id = "${content.tenancy_ocid}"
    description = "Compartment for Zelos Cluster Resources."
    name = "Zelos"
}
%{endfor}
EOF
}

generate "vnc" {
  path = "generated.vnc.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
%{for key, content in local.oci_credentials}
module "vnc-${content.id}" {
  source = "jakoberpf/base-vpc/oracle"
  providers = {
    oci = oci.${content.id}
  }

  name                 = "zelos"
  compartment_id       = oci_identity_compartment.compartment-${content.id}.id
  availability_domains = [
    "${content.availability_domains[0]}",
    "${content.availability_domains[1]}",
    "${content.availability_domains[2]}"
  ]
  vcn_cidr_block = "10.${key + 1}0.0.0/16"
}
%{endfor}

EOF
}

generate "peering" {
  path = "generated.peering.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
%{for requestor in local.oci_credentials}%{for acceptor in requestor.peers}
module "peering-${requestor.id}-${acceptor}" {
  source = "jakoberpf/peering-local/oracle"
  providers = {
    oci.requestor = oci.${requestor.id}
    oci.acceptor = oci.${acceptor}
  }

  requestor_id = "${requestor.id}"
  requestor_compartment_ocid = oci_identity_compartment.compartment-${requestor.id}.id
  requestor_root_compartment_ocid = "${requestor.tenancy_ocid}"
  requestor_vnc_ocid = module.vnc-${requestor.id}.vcn_id
  requestor_route_table_id = module.vnc-${requestor.id}.route_table_id
  acceptor_id = "${acceptor}"
  acceptor_compartment_ocid = oci_identity_compartment.compartment-${acceptor}.id
  acceptor_root_compartment_ocid = "${local.oci_credentials[index(local.oci_credentials.*.id, "${acceptor}")].tenancy_ocid}"
  acceptor_vnc_ocid = module.vnc-${acceptor}.vcn_id
  acceptor_route_table_id = module.vnc-${acceptor}.route_table_id
}

resource "local_file" "peering-${requestor.id}-${acceptor}-requestor" {
  filename = "$${path.module}/../bin/generated/peering-${requestor.id}-${acceptor}-requestor.sh"
  content  = module.peering-${requestor.id}-${acceptor}.requestor_route_rule_script
}

resource "local_file" "peering-${requestor.id}-${acceptor}-acceptor" {
  filename = "$${path.module}/../bin/generated/peering-${requestor.id}-${acceptor}-acceptor.sh"
  content  = module.peering-${requestor.id}-${acceptor}.acceptor_route_rule_script
}
%{endfor}%{endfor}

EOF
}

generate "nodes" {
  path = "generated.nodes.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
%{for tenancy in local.oci_credentials}
module "node-${tenancy.id}" {
  source = "jakoberpf/kubernetes-node/oracle"
  providers = {
    oci = oci.${tenancy.id}
  }

  name                            = "zelos"
  compartment                     = "${tenancy.id}"
  vcn_id                          = module.vnc-${tenancy.id}.vcn_id
  compartment_id                  = oci_identity_compartment.compartment-${tenancy.id}.id
  subnet_id                       = module.vnc-${tenancy.id}.public_subnet_ids[${tenancy.availability_domains_placement - 1}]
  availability_domain             = "${tenancy.availability_domains[tenancy.availability_domains_placement - 1]}"
  ssh_authorized_keys             = var.authorized_keys # "${local.ssh.public_key}"

  depends_on = [
    module.vnc-${tenancy.id}
  ]
}
%{endfor}

EOF
}

generate "dns" {
  path = "generated.dns.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
resource "cloudflare_record" "api" {
  zone_id  = "${local.cloudflare_credentials.zone_id}"
  name     = "api.zelos.k8s.erpf.de"
  value    = module.node-jakob.public_ip
  type     = "A"
  proxied  = false
}

%{for tenancy in local.oci_credentials}
resource "cloudflare_record" "node-${tenancy.id}" {
  zone_id  = "${local.cloudflare_credentials.zone_id}"
  name     = "${tenancy.id}.nodes.zelos.k8s.erpf.de"
  value    = module.node-${tenancy.id}.public_ip
  type     = "A"
  proxied  = false
}
%{endfor}

EOF
}

// generate "inventory" {
//   path = "../kubespray/inventory.ini"
//   if_exists = "overwrite_terragrunt"
//   contents = <<EOF
// [all]
// %{for tenancy in local.oci_credentials}
// node-${tenancy.id} ansible_host=${tenancy.public_ip} ansible_user=ubuntu etcd_member_name=etcd-${tenancy.id} ip=${tenancy.private_ip}
// %{endfor}

// [kube-master]
// %{for tenancy in local.oci_credentials}
// node-${tenancy.id}
// %{endfor}

// [etcd]
// %{for tenancy in local.oci_credentials}
// node-${tenancy.id}
// %{endfor}

// [kube-node]
// %{for tenancy in local.oci_credentials}
// node-${tenancy.id}
// %{endfor}

// [calico_rr]

// [k8s-cluster:children]
// kube-master
// kube-node
// calico_rr
// EOF
// }

generate "ssh" {
  path = "generated.ssh.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
resource "local_file" "ssh" {
  depends_on = [
    %{for tenancy in local.oci_credentials}
    module.node-${tenancy.id}.public_ip,
    %{endfor}
  ]
  content = templatefile("templates/config.tpl",
  {
    node-ip = [
        %{for tenancy in local.oci_credentials}
        module.node-${tenancy.id}.public_ip,
        %{endfor}
    ]
    node-id = [
        %{for tenancy in local.oci_credentials}
        "node-${tenancy.id}",
        %{endfor}
    ],
    node-user = "ubuntu",
    node-key = "${get_terragrunt_dir()}/../.ssh/automation"
  }
 )
 filename = "../.ssh/config"
}

EOF
}

inputs = {}