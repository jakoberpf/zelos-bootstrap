# https://makefiletutorial.com/
all: banner

banner: # Typo: Allogator2 from https://manytools.org/hacker-tools/ascii-banner/
	@echo "################################################################"
	@echo "##                                                            ##"
	@echo "##    ::::::::: :::::::::: :::        ::::::::   ::::::::     ##"
	@echo "##         :+:  :+:        :+:       :+:    :+: :+:    :+:    ##"
	@echo "##        +:+   +:+        +:+       +:+    +:+ +:+           ##"
	@echo "##       +#+    +#++:++#   +#+       +#+    +:+ +#++:++#++    ##"
	@echo "##      +#+     +#+        +#+       +#+    +#+        +#+    ##"
	@echo "##     #+#      #+#        #+#       #+#    #+# #+#    #+#    ##"
	@echo "##    ######### ########## ########## ########   ########     ##"
	@echo "##                                                            ##"
	@echo "################################################################"
	@echo "                                                                "

vault: all
	@echo "[vault] Getting configuration and secrets from Vault"
	./vault.sh

deploy.terraform: all
	cd terraform && terraform init -upgrade
	cd terraform && terraform apply -var-file="variables.tfvars"

deploy.kubespray: all
	GIT_ROOT=$(git rev-parse --show-toplevel) && docker run --rm -it \
		--mount type=bind,source="$GIT_ROOT"/kubespray/inventory/zelos,dst=/inventory \
		--mount type=bind,source="$GIT_ROOT"/.ssh/automation.openssh.pem,dst=/root/.ssh/id_rsa \
		quay.io/kubespray/kubespray:v2.17.1 bash -c "ansible-playbook -i /inventory/inventory.ini -b --private-key /root/.ssh/id_rsa cluster.yml"

destroy:
	cd terraform && terraform destroy -var-file="variables.tfvars"

taint.instances:
	cd terraform && terraform taint module.oracle_instance_jakob.oci_core_instance.oaik_0
	cd terraform && terraform taint module.oracle_instance_fabian.oci_core_instance.oaik_0
	cd terraform && terraform taint module.oracle_instance_tanja.oci_core_instance.oaik_0

test.nmap: all
	nmap 130.61.169.137 -Pn -p T:2379,6443