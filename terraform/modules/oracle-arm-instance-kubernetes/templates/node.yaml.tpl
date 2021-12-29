#cloud-config

package_update: true
package_upgrade: true
package_reboot_if_required: true

packages:
  - curl

runcmd:
  # Configure IPTables
  - iptables -I INPUT 2 -p tcp --dport 53 -j ACCEPT
  - iptables -I INPUT 2 -p tcp --dport 2379 -j ACCEPT
  - iptables -I INPUT 2 -p tcp --dport 2380 -j ACCEPT
  - iptables -I INPUT 2 -p tcp --dport 6443 -j ACCEPT
  - iptables -I INPUT 2 -p tcp --dport 9254 -j ACCEPT
  - iptables -I INPUT 2 -p tcp --dport 10250 -j ACCEPT
  - iptables -F
  - iptables-save > /etc/iptables/rules.v4
  # Setup Zerotier
  - curl -o zerotier-install.sh https://raw.githubusercontent.com/jakoberpf/zerotier-scripts/main/zerotier-installer.sh
  - chmod +x zerotier-install.sh
  - ./zerotier-install.sh && rm ./zerotier-install.sh
  - curl -o zerotier-join.sh https://raw.githubusercontent.com/jakoberpf/zerotier-scripts/main/zerotier-join.sh
  - chmod +x zerotier-join.sh
  - ZTNETWORK=${zerotier_network_id_internal} ./zerotier-join.sh
  - ZTNETWORK=${zerotier_network_id_external} ./zerotier-join.sh
  - rm ./zerotier-join.sh

write_files:
  - path: /var/lib/zerotier-one/identity.public
    content: |
      ${zerotier_public_key}

  - path: /var/lib/zerotier-one/identity.secret
    content: |
      ${zerotier_private_key}