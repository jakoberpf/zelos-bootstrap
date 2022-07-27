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

terraform.post: all terraform
	@echo "[terraform] Postprocessing terraform infrastructure"
	@./bin/generated/peering.sh

kubespray: all
	@echo "[kubespray] Creating cluster with kubespray"
	@./bin/kubespray.sh

deploy: terraform terraform.post kubespray
	@echo "[kubespray] Creating cluster with kubespray"

destroy: all
	@echo "[bootstrap] Destroying cluster infrastructure"
	@cd terraform && terraform destroy -var-file="variables.tfvars"
