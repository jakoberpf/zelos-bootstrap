resource "oci_core_security_list" "oaik" {
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id
  display_name   = "${var.clustername}-security-list-${random_string.deployment_id.result}"
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 2379
      max = 2380
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 6443
      max = 6443
    }
  }
}