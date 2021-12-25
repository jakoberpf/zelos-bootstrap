#cloud-config

package_update: true
package_upgrade: true
package_reboot_if_required: true

packages:
  - curl

runcmd:
  # Configure IPTables
  - iptables -I INPUT 2 -p tcp --dport 2379 -j ACCEPT
  - iptables -I INPUT 2 -p tcp --dport 2380 -j ACCEPT
  - iptables -I INPUT 2 -p tcp --dport 6443 -j ACCEPT
  - iptables-save > /etc/iptables/rules.v4
  # Setup Zerotier
  - curl -o zerotier-install.sh https://raw.githubusercontent.com/jakoberpf/zerotier-scripts/main/zerotier-installer.sh
  - chmod +x zerotier-install.sh
  - ./zerotier-install.sh
