Host *
  ForwardAgent yes
  StrictHostKeyChecking no

%{ for index, id in node-id ~}
Host ${id}
  Hostname ${node-ip[index]}
  Port 2222
  User ${node-user}
  IdentityFile ${node-key}

%{ endfor ~}
