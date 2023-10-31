locals {
  vars_yaml              = yamldecode(file("terragrunt.yaml"))
  ssh                    = local.vars_yaml.ssh
  oci_credentials        = local.vars_yaml.oci
  cloudflare_credentials = local.vars_yaml.cloudflare
  terraform              = local.vars_yaml.terraform
  /* vars_dynamic_yaml      = yamldecode(file("dynamic.yaml")) */
}

generate "backend" {
  path      = "generated.backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
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
  path      = "generated.providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
%{for key, content in local.oci_credentials}
provider "oci" {
  alias            = "${content.id}"
  tenancy_ocid     = "${content.tenancy_ocid}"
  user_ocid        = "${content.user_ocid}"
  fingerprint      = "${content.fingerprint}"
  private_key      = "${content.private_key}"
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
  path      = "generated.compartments.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
%{for key, content in local.oci_credentials}
resource "oci_identity_compartment" "compartment-${content.id}" {
    provider = oci.${content.id}
    compartment_id = "${content.tenancy_ocid}"
    description = "Compartment for Zelos Cluster Resources."
    name = "zelos-${content.id}"
}
%{endfor}
EOF
}

generate "bucket" {
  path      = "generated.bucket.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
%{for key, content in local.oci_credentials}
data "oci_objectstorage_namespace" "config_${content.id}" {
    provider = oci.${content.id}
    compartment_id = "${content.tenancy_ocid}"
}

resource "oci_objectstorage_bucket" "config_${content.id}" {
  provider = oci.${content.id}

  access_type           = "NoPublicAccess"
  auto_tiering          = "InfrequentAccess"
  compartment_id        = "${content.tenancy_ocid}"
  name                  = "zelos-${content.id}"
  namespace             = data.oci_objectstorage_namespace.config_${content.id}.namespace
  object_events_enabled = "false"
  storage_tier          = "Standard"
  versioning            = "Disabled"

  freeform_tags = {
  }

  metadata = {
  }
}
%{endfor}
EOF
}

generate "vnc" {
  path      = "generated.vnc.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
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
  path      = "generated.peering.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
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
  filename = "$${path.module}/generated/peering-${requestor.id}-${acceptor}-requestor.sh"
  content  = module.peering-${requestor.id}-${acceptor}.requestor_route_rule_script
}

resource "local_file" "peering-${requestor.id}-${acceptor}-acceptor" {
  filename = "$${path.module}/generated/peering-${requestor.id}-${acceptor}-acceptor.sh"
  content  = module.peering-${requestor.id}-${acceptor}.acceptor_route_rule_script
}
%{endfor}%{endfor}

EOF
}

generate "nodes" {
  path      = "generated.nodes.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
%{for tenancy in local.oci_credentials}
module "node-${tenancy.id}" {
  source = "jakoberpf/kubernetes-node/oracle"
  version = "0.0.8"
  providers = {
    oci = oci.${tenancy.id}
  }

  name                            = "zelos"
  compartment                     = "${tenancy.id}"
  vcn_id                          = module.vnc-${tenancy.id}.vcn_id
  compartment_id                  = oci_identity_compartment.compartment-${tenancy.id}.id
  subnet_id                       = module.vnc-${tenancy.id}.public_subnet_ids[${tenancy.availability_domains_placement - 1}]
  availability_domain             = "${tenancy.availability_domains[tenancy.availability_domains_placement - 1]}"
  ssh_authorized_keys             = "${local.ssh.public_key}"

  instance_ocpus = 2
  instance_memory = 12
  boot_volume_size_in_gbs = 100

  security_group_ports_kubernetes = {
    "LOCAL_DNS_CACHE_TCP" = {
      port_max    = 53
      port_min    = 53
      protocol    = 6
      description = "LOCAL_DNS_CACHE_TCP"
    }
    "CALICO_BGP" = {
      port_max    = 179
      port_min    = 179
      protocol    = 6
      description = "CALICO_BGP"
    }
    "ETCD" = {
      port_max    = 2380
      port_min    = 2379
      protocol    = 6
      description = "ETCD"
    }
    "CILIUM_HEALTH_CHECKS" = {
      port_max    = 4240
      port_min    = 4240
      protocol    = 6
      description = "CILIUM_HEALTH_CHECKS"
    }
    "KUBE_API" = {
      port_max    = 6443
      port_min    = 6443
      protocol    = 6
      description = "KUBE_API"
    }
    "KUBELET" = {
      port_max    = 10250
      port_min    = 10250
      protocol    = 6
      description = "KUBELET"
    }
  }

  security_group_ports_applications = {
    "NETMAKER_MQTT" = {
      port_max    = 1883
      port_min    = 1883
      protocol    = 6
      description = "NETMAKER_MQTT"
    }
    "NETMAKER_MQTT2" = {
      port_max    = 8883
      port_min    = 8883
      protocol    = 6
      description = "NETMAKER_MQTT2"
    }
    "NETMAKER_WIREGUARD" = {
      port_max    = 31830
      port_min    = 31821
      protocol    = 6
      description = "NETMAKER_WIREGUARD"
    }
  }

  depends_on = [
    module.vnc-${tenancy.id}
  ]
}
%{endfor}

EOF
}

/* "CILIUM_VXLAN_OVERLAY" = {
  port_max    = 8472
  port_min    = 8472
  protocol    = 17
  description = "CILIUM_VXLAN_OVERLAY"
} */

/* "LOCAL_DNS_CACHE_UPD" = {
  port_max    = 53
  port_min    = 53
  protocol    = 17
  description = "LOCAL_DNS_CACHE_UPD"
} */

generate "dns" {
  path      = "generated.dns.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
resource "cloudflare_record" "endpoint" {
  zone_id  = "${local.cloudflare_credentials.zone_id}"
  name     = "*.blue.zelos.k8s.erpf.de"
  value    = module.node-smartset.public_ip
  type     = "A"
  proxied  = false
  ttl      = 60
}

%{for tenancy in local.oci_credentials}
resource "cloudflare_record" "node-${tenancy.id}" {
  zone_id  = "${local.cloudflare_credentials.zone_id}"
  name     = "${tenancy.id}.nodes.blue.zelos.k8s.erpf.de"
  value    = module.node-${tenancy.id}.public_ip
  type     = "A"
  proxied  = false
  ttl      = 300
}
%{endfor}

EOF
}

generate "inventory" {
  path      = "generated.inventory.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
resource "local_file" "inventory" {
  depends_on = [
    %{for tenancy in local.oci_credentials}module.node-${tenancy.id}.public_ip,%{endfor}
  ]
  content = templatefile("templates/inventory.tpl",
    {
      masters-ip-public = [
        %{for tenancy in local.oci_credentials}%{if tenancy.role == "master"}module.node-${tenancy.id}.public_ip,%{endif}%{endfor}
      ]
      masters-ip-private = [
        %{for tenancy in local.oci_credentials}%{if tenancy.role == "master"}module.node-${tenancy.id}.private_ip,%{endif}%{endfor}
      ]
      masters-id = [
        %{for tenancy in local.oci_credentials}%{if tenancy.role == "master"}"node-${tenancy.id}",%{endif}%{endfor}
      ],
      masters-user = [
        %{for tenancy in local.oci_credentials}"ubuntu",%{endfor}
      ]

      workers-ip-public = [
        %{for tenancy in local.oci_credentials}%{if tenancy.role == "worker"}module.node-${tenancy.id}.public_ip,%{endif}%{endfor}
      ]
      workers-ip-private = [
        %{for tenancy in local.oci_credentials}%{if tenancy.role == "worker"}module.node-${tenancy.id}.private_ip,%{endif}%{endfor}
      ]
      workers-id = [
        %{for tenancy in local.oci_credentials}%{if tenancy.role == "worker"}"node-${tenancy.id}",%{endif}%{endfor}
      ],
      workers-user = [
        %{for tenancy in local.oci_credentials}%{if tenancy.role == "worker"}"ubuntu",%{endif}%{endfor}
      ]
    }

  )
  filename = "$${path.module}/generated/inventory.ini"
}

EOF
}

generate "ssh" {
  path      = "generated.ssh.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
resource "local_file" "ssh" {
  depends_on = [
    %{for tenancy in local.oci_credentials}module.node-${tenancy.id}.public_ip,%{endfor}
  ]
  content = templatefile("templates/config.tpl",
  {
    node-ip = [
        %{for tenancy in local.oci_credentials}module.node-${tenancy.id}.public_ip,%{endfor}
    ]
    node-id = [
        %{for tenancy in local.oci_credentials}"node-${tenancy.id}",%{endfor}
    ],
    node-user = [
        %{for tenancy in local.oci_credentials}"ubuntu",%{endfor}
    ],
    node-key = "${get_terragrunt_dir()}/../.ssh/automation"
  }
 )
 filename = "$${path.module}/generated/config"
}

EOF
}

inputs = {}
