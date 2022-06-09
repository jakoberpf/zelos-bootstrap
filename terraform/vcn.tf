# module "instances" {
#   source = "/Users/jakoberpf/Code/jakoberpf/terraform/modules/oracle/kubernetes-node"
#   providers = {
#     oci = oci.ulrike
#   }

#   for_each = toset([
#     "ulrike"
#   ]) # local.compartments)

#   name                            = "zelos"
#   compartment                     = each.value
#   vcn_id                          = module.clouds[each.value].vcn_id
#   compartment_id                  = var.oci_credentials[index(var.oci_credentials.*.id, each.value)].compartment_ocid
#   subnet_id                       = module.clouds[each.value].public_subnet_ids[1]
#   availability_domain             = var.oci_credentials[index(var.oci_credentials.*.id, each.value)].availability_domains[1]
#   ssh_authorized_keys             = var.authorized_keys
#   zerotier_network_id_internal    = module.zerotier_cluster_network.network_ids[0]
#   zerotier_network_id_external    = module.zerotier_cluster_network.network_ids[1]
#   zerotier_ip_assignment_internal = ["10.110.110.11"]
#   zerotier_ip_assignment_external = ["10.110.111.11"]
# }

# locals {
#   instance_names = toset([
#     for instance in module.instances : instance.compartment
#   ])
#   instance_public_ips = toset([
#     for instance in module.instances : instance.public_ip
#   ])
#   # instance_private_ips = toset([
#   #   for instance in module.instances : instance.public_ip
#   # ])
# }

# output "IPs" {
#   value = toset([
#     for instance in module.instances : instance.public_ip
#   ])
# }
