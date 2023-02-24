#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# https://serverfault.com/questions/545978/how-to-handle-ssh-port-changes-with-ansible

# ssh -i $GIT_ROOT/.ssh/automation $1

# ssh-copy-id -i $GIT_ROOT/.ssh/automation $1

# ssh -i $GIT_ROOT/.ssh/automation -T $1 <<'EOL'
# 	  apt-get install -y iptables-persistent
#     iptables -I INPUT -p tcp --dport 2222 -j ACCEPT
#     iptables-save > /etc/iptables/rules.v4
#     sed -i 's/\#\?Port .\+/Port 2222/' /etc/ssh/sshd_config
#     service sshd restart
# EOL
