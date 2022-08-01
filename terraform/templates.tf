resource "local_file" "kubespray_inventory" {
  depends_on = [
    module.node-jakob.public_ip,
    module.node-tanja.public_ip,
    module.node-fabian.public_ip,
    module.node-ulrike.public_ip,
    module.node-tobias.public_ip
  ]
  content = templatefile("${path.module}/templates/inventory.tpl",
  {
    masters-ip-public = [
        module.node-jakob.public_ip,
        module.node-tanja.public_ip,
        module.node-fabian.public_ip
    ]
    masters-ip-private = [
        module.node-jakob.private_ip,
        module.node-tanja.private_ip,
        module.node-fabian.private_ip
    ]
    masters-id = [
        "node-jakob",
        "node-tanja",
        "node-fabian"
    ],
    masters-user = "ubuntu",
    workers-ip-public = [
        module.node-ulrike.public_ip,
        module.node-tobias.public_ip
    ]
    workers-ip-private = [
        module.node-ulrike.private_ip,
        module.node-tobias.private_ip
    ]
    workers-id = [
        "node-ulrike",
        "node-tobias"
    ],
    workers-user = "ubuntu",
  }
 )
 filename = "${path.root}/../kubespray/inventory.ini"
}

resource "local_file" "ssh_config" {
  depends_on = [
    module.node-jakob.public_ip,
    module.node-tanja.public_ip,
    module.node-fabian.public_ip,
    module.node-ulrike.public_ip,
    module.node-tobias.public_ip
  ]
  content = templatefile("${path.module}/templates/config.tpl",
  {
    node-ip = [
        module.node-jakob.public_ip,
        module.node-tanja.public_ip,
        module.node-fabian.public_ip,
        module.node-ulrike.public_ip,
        module.node-tobias.public_ip,
    ]
    node-id = [
        "node-jakob",
        "node-tanja",
        "node-fabian",
        "node-ulrike",
        "node-tobias"
    ],
    node-user = "ubuntu",
    node-key = "${abspath(path.root)}/../.ssh/automation"
  }
 )
 filename = "${path.root}/../.ssh/config"
}
