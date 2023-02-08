[all]
%{ for index, id in node-id ~}
${id} ansible_host=${node-ip-public[index]} ansible_user=${node-user} ip=${node-ip-private[index]} haproxy_own_ip=${node-ip-private[index]}
%{ endfor ~}
