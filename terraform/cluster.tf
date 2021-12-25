module "oracle_instance_jakob" {
  source = "./modules/oracle-arm-instance-kubernetes"
  providers = {
    oci = oci.jakob
  }
  clustername = "zelos"
  vcn_id = var.jakob_vcn_id
  default_dhcp_options_id = var.jakob_default_dhcp_options_id
  availability_domain = var.jakob_availability_domains[0]
  compartment_id = var.jakob_compartment_ocid
  route_table_id = var.jakob_route_table_id
  cidr_block = "192.168.65.0/24"
  instance_ocpus = 3
  instance_memory = 22
}

module "oracle_instance_fabian" {
  source = "./modules/oracle-arm-instance-kubernetes"
  providers = {
    oci = oci.fabian
  }
  clustername = "zelos"
  vcn_id = var.fabian_vcn_id
  default_dhcp_options_id = var.fabian_default_dhcp_options_id
  availability_domain = var.fabian_availability_domains[0]
  compartment_id = var.fabian_compartment_ocid
  route_table_id = var.fabian_route_table_id
  cidr_block = "192.168.65.0/24"
}

module "oracle_instance_tanja" {
  source = "./modules/oracle-arm-instance-kubernetes"
  providers = {
    oci = oci.tanja
  }
  clustername = "zelos"
  vcn_id = var.tanja_vcn_id
  default_dhcp_options_id = var.tanja_default_dhcp_options_id
  availability_domain = var.tanja_availability_domains[1]
  compartment_id = var.tanja_compartment_ocid
  route_table_id = var.tanja_route_table_id
  cidr_block = "192.168.65.0/24"
}
