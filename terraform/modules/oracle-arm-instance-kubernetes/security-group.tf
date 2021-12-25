resource "oci_core_network_security_group" "oaik_kube" {
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id
  display_name   = "${var.clustername}-etcd-security-group"
}

resource "oci_core_network_security_group_security_rule" "oaik_kube" {
  network_security_group_id = oci_core_network_security_group.oaik_kube.id

  description = "KUBE"
  direction   = "INGRESS"
  protocol    = 6
  source_type = "CIDR_BLOCK"
  source      = "0.0.0.0/0"

  tcp_options {
    destination_port_range {
      min = 6443
      max = 6443
    }
  }
}

resource "oci_core_network_security_group" "oaik_etcd" {
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id
  display_name   = "${var.clustername}-etcd-security-group"
}

resource "oci_core_network_security_group_security_rule" "oaik_etcd" {
  network_security_group_id = oci_core_network_security_group.oaik_etcd.id

  description = "ETCD"
  direction   = "INGRESS"
  protocol    = 6
  source_type = "CIDR_BLOCK"
  source      = "0.0.0.0/0"

  tcp_options {
    destination_port_range {
      min = 2379
      max = 2379
    }
  }
}
