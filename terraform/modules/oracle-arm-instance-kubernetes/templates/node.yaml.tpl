#cloud-config

package_update: true
package_upgrade: true
package_reboot_if_required: true

packages:
  - curl

runcmd:
  # Setup Zerotier
  - curl -o zerotier-install.sh https://raw.githubusercontent.com/jakoberpf/zerotier-scripts/main/zerotier-installer.sh
  - chmod +x zerotier-install.sh
  - ./zerotier-install.sh
