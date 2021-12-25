resource "oci_core_subnet" "oaik" {
  availability_domain        = var.availability_domain
  cidr_block                 = var.cidr_block
  display_name               = "${var.clustername}-subnet-${random_string.deployment_id.result}"
  prohibit_public_ip_on_vnic = false
  dns_label                  = var.clustername
  compartment_id             = var.compartment_id
  vcn_id                     = var.vcn_id
  route_table_id             = var.route_table_id
  security_list_ids          = [ oci_core_security_list.oaik.id ]
  dhcp_options_id            = var.default_dhcp_options_id
}