# module "zerotier_cluster_network" {
#   source = "./modules/zerotier-cluster-network"
#   clustername = "zelos"
#   cidr_prefix_internal = "17.12.0"
#   cidr_prefix_external = "17.12.1"
# }

module "oracle_instance_jakob" {
  source = "./modules/oracle-arm-instance-kubernetes"
  # depends_on = [
  #   module.zerotier_cluster_network
  # ]
  providers = {
    oci = oci.jakob
  }
  cluster_name = "zelos"
  cluster_compartment = "jakob"
  vcn_id = var.jakob_vcn_id
  default_dhcp_options_id = var.jakob_default_dhcp_options_id
  availability_domain = var.jakob_availability_domains[0]
  compartment_id = var.jakob_compartment_ocid
  route_table_id = var.jakob_route_table_id
  cidr_block = "192.168.65.0/24"
  ssh_authorized_keys = var.authorized_keys
  zerotier_network_id_internal = "af78bf9436f90277" # module.zerotier_cluster_network.network_id_internal
  zerotier_network_id_external = "9f77fc393e77bcbc" # module.zerotier_cluster_network.network_id_external
  zerotier_ip_assignment_internal = "10.147.50.10"
  zerotier_ip_assignment_external = "10.147.51.10"
  instance_ocpus = 3
  instance_memory = 22
}

module "oracle_instance_fabian" {
  source = "./modules/oracle-arm-instance-kubernetes"
  # depends_on = [
  #   module.zerotier_cluster_network
  # ]
  providers = {
    oci = oci.fabian
  }
  cluster_name = "zelos"
  cluster_compartment = "fabian"
  vcn_id = var.fabian_vcn_id
  default_dhcp_options_id = var.fabian_default_dhcp_options_id
  availability_domain = var.fabian_availability_domains[0]
  compartment_id = var.fabian_compartment_ocid
  route_table_id = var.fabian_route_table_id
  cidr_block = "192.168.65.0/24"
  ssh_authorized_keys = var.authorized_keys
  zerotier_network_id_internal = "af78bf9436f90277" # module.zerotier_cluster_network.network_id_internal
  zerotier_network_id_external = "9f77fc393e77bcbc" # module.zerotier_cluster_network.network_id_external
  zerotier_ip_assignment_internal = "10.147.50.20"
  zerotier_ip_assignment_external = "10.147.51.20"
}

module "oracle_instance_tanja" {
  source = "./modules/oracle-arm-instance-kubernetes"
  # depends_on = [
  #   module.zerotier_cluster_network
  # ]
  providers = {
    oci = oci.tanja
  }
  cluster_name = "zelos"
  cluster_compartment = "tanja"
  vcn_id = var.tanja_vcn_id
  default_dhcp_options_id = var.tanja_default_dhcp_options_id
  availability_domain = var.tanja_availability_domains[1]
  compartment_id = var.tanja_compartment_ocid
  route_table_id = var.tanja_route_table_id
  cidr_block = "192.168.65.0/24"
  ssh_authorized_keys = var.authorized_keys
  zerotier_network_id_internal = "af78bf9436f90277" # module.zerotier_cluster_network.network_id_internal
  zerotier_network_id_external = "9f77fc393e77bcbc" # module.zerotier_cluster_network.network_id_external
  zerotier_ip_assignment_internal = "10.147.50.30"
  zerotier_ip_assignment_external = "10.147.51.30"
}
