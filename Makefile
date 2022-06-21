# https://makefiletutorial.com/
all: banner tooling vault # tooling before vault

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
	@echo " 															   "
	
tooling: banner
	@echo "[tooling] Setting up tooling"
	@./bin/tooling.sh

vault: banner tooling
	@echo "[vault] Getting configuration and secrets from Vault"
	@./bin/vault.sh

terraform: all
	@echo "[terraform] Creating cluster infrastructure with terraform"
	@./bin/terraform.sh

terraform.force: all
	@echo "[terraform] Creating cluster infrastructure with terraform by bruceforce"
	@./bin/terraform.sh --loop

kubespray: all
	@echo "[kubespray] Creating cluster with kubespray"
	@./bin/kubespray.sh

deploy: terraform kubespray
	@echo "[kubespray] Creating cluster with kubespray"

destroy: all
	@echo "[bootstrap] Destroying cluster infrastructure"
	@cd terraform && terraform destroy -var-file="variables.tfvars"

taint.instances: all
	@cd terraform && terraform taint module.oracle_instance_jakob.oci_core_instance.oaik_0
	@cd terraform && terraform taint module.oracle_instance_fabian.oci_core_instance.oaik_0
	@cd terraform && terraform taint module.oracle_instance_tanja.oci_core_instance.oaik_0

test.nmap: all
	@nmap 130.61.169.137 -Pn -p T:2379,6443