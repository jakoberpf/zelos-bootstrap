module "zerotier_cluster_network" {
  source = "jakoberpf/cluster-network/zerotier"

  name = "zelos"
  cidr = "10.110.110.0/24"
  networks = [
    "internal",
    "external"
  ]
}

locals {
  compartments = ["ulrike"]
}

module "clouds" {
  source = "/Users/jakoberpf/Code/jakoberpf/terraform/modules/oracle/base-vpc" #"jakoberpf/base-vpc/oracle"
  providers = {
    oci = oci.ulrike
  }

  for_each = toset(local.compartments)

  name                 = "zelos"
  compartment_id       = var.oci_credentials[index(var.oci_credentials.*.id, each.value)].compartment_ocid
  availability_domains = var.oci_credentials[index(var.oci_credentials.*.id, each.value)].availability_domains
}

module "instances" {
  source = "/Users/jakoberpf/Code/jakoberpf/terraform/modules/oracle/kubernetes-node"
  providers = {
    oci = oci.ulrike
  }

  for_each = toset(local.compartments)

  name                            = "zelos"
  compartment                     = each.value
  vcn_id                          = module.clouds[each.value].vcn_id
  compartment_id                  = var.oci_credentials[index(var.oci_credentials.*.id, each.value)].compartment_ocid
  subnet_id                       = module.clouds[each.value].public_subnet_ids[1]
  availability_domain             = var.oci_credentials[index(var.oci_credentials.*.id, each.value)].availability_domains[1]
  ssh_authorized_keys             = var.authorized_keys
  zerotier_network_id_internal    = module.zerotier_cluster_network.network_ids[0]
  zerotier_network_id_external    = module.zerotier_cluster_network.network_ids[1]
  zerotier_ip_assignment_internal = ["10.110.110.11"]
  zerotier_ip_assignment_external = ["10.110.111.11"]
}
