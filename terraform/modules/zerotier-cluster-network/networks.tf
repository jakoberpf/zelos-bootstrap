resource "zerotier_network" "internal" {
  name        = "${var.clustername}-internal-${random_string.deployment_id.result}"
  description = "A network for the interal cluster traffic"
  assignment_pool {
    end   = "${var.cidr_prefix_internal}.254"
    start = "${var.cidr_prefix_internal}.1"
  }
  route {
    target = "${var.cidr_prefix_internal}.0/24"
  }
  private    = true
  flow_rules = "accept;"
}

resource "zerotier_network" "external" {
  name        = "${var.clustername}-external-${random_string.deployment_id.result}"
  description = "A network for the external cluster traffic"
  assignment_pool {
    end   = "${var.cidr_prefix_external}.254"
    start = "${var.cidr_prefix_external}.1"
  }
  route {
    target = "${var.cidr_prefix_external}.0/24"
  }
  private    = true
  flow_rules = "accept;"
}


