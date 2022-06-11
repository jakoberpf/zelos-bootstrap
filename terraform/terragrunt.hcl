locals {
  vars = jsondecode(file("terragrunt.json"))
  oci_credentials = local.vars.oci_credentials
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
  source = "/Users/jakoberpf/Code/jakoberpf/terraform/modules/oracle/base-vpc"
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
  source = "/Users/jakoberpf/Code/jakoberpf/terraform/modules/oracle/peering-local"
  providers = {
    oci.requestor = oci.${requestor.id}
    oci.acceptor = oci.${acceptor}
  }

  requestor_compartment_ocid = oci_identity_compartment.compartment-${requestor.id}.id
  requestor_root_compartment_ocid = "${requestor.tenancy_ocid}"
  requestor_vnc_ocid = module.vnc-${requestor.id}.vcn_id
  acceptor_compartment_ocid = oci_identity_compartment.compartment-${acceptor}.id
  acceptor_root_compartment_ocid = "${local.oci_credentials[index(local.oci_credentials.*.id, "${acceptor}")].tenancy_ocid}"
  acceptor_vnc_ocid = module.vnc-${acceptor}.vcn_id
}
%{endfor}%{endfor}

EOF
}

inputs = {}