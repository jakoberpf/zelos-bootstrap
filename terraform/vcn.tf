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
