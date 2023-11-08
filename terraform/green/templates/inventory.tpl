[all]
%{ for index, id in masters-id ~}
${id} ansible_host=${masters-ip-public[index]} ansible_user=${masters-user[index]} etcd_member_name=etcd-${index} ip=${masters-ip-private[index]}
%{ endfor ~}
%{ for index, id in workers-id ~}
${id} ansible_host=${workers-ip-public[index]} ansible_user=${workers-user[index]} ip=${workers-ip-private[index]}
%{ endfor ~}

[k3s_master]
%{ for index, id in masters-id ~}
${id}
%{ endfor ~}

[k3s_node]
%{ for index, id in workers-id ~}
${id}
%{ endfor ~}

[k3s_cluster:children]
k3s_master
k3s_node
