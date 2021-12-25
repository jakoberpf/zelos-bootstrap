variable "clustername" {
  type    = string
  default = "oracle"
}

variable "instance_shape" {
  type    = string
  default = "VM.Standard.A1.Flex"
}

variable "instance_memory" {
  type    = number
  default = 24
}

variable "instance_ocpus" {
  type    = string
  default = 4
}

variable "vcn_id" {
  type    = string
}

variable "default_dhcp_options_id" {
  type    = string
}

variable "availability_domain" {
  type    = string
}

variable "compartment_id" {
  type    = string
}

variable "route_table_id" {
  type    = string
}

variable "cidr_block" {
  type    = string
}

variable "ssh_authorized_keys" {
  type    = string
}

resource "random_string" "deployment_id" {
  length  = 5
  upper   = false
  lower   = true
  number  = true
  special = false
}