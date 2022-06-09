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

# Define what tenancies to deploy the resources into
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

# Define what compartments to deploy the resources into
generate "compartments" {
  path = "generated.compartments.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
%{for key, content in local.oci_credentials}
resource "oci_identity_compartment" "compartment-${content.id}" {
    provider = "oci.${content.id}"
    compartment_id = "${content.tenancy_ocid}"
    description = "Compartment for Zelos Cluster Resources."
    name = "Zelos"
}
%{endfor}
EOF
}

# Indicate what cloud networks to deploy the resources into
generate "vnc" {
  path = "generated.vnc.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
locals {
  local_peering_requestor_data = {%{for key, content-requestor in local.oci_credentials}
    "${content-requestor.id}" = {
      acceptor_tenancy_ocid = "${content-requestor.tenancy_ocid}"
      acceptor_peer_ocids = module.vnc-${content-requestor.id}.local_peering_acceptor_gateway_ocids
      acceptor_cidr = "10.${key + 1}0.0.0/16"
    },%{endfor}
  }
  local_peering_acceptor_data = {%{for key, content-acceptor in local.oci_credentials}
    "${content-acceptor.id}" = {
      requestor_tenancy_ocid = "${content-acceptor.tenancy_ocid}"
      requestor_group_ocid = module.vnc-${content-acceptor.id}.local_peering_requestor_group_ocid
      requestor_cidr = "10.${key + 1}0.0.0/16"
    },%{endfor}
  }
}
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
  local_peering_id = "${content.id}"
  local_peering_root_compartment_ocid = "${content.tenancy_ocid}"
  local_peering_requestors = [%{for key, content in content.local_peering_requestors}"${content}",%{endfor}]
  local_peering_requestor_data = local.local_peering_requestor_data
  local_peering_acceptors = [%{for key, content in content.local_peering_acceptors}"${content}",%{endfor}]
  local_peering_acceptor_data = local.local_peering_acceptor_data
}
%{endfor}

EOF
}

inputs = {}