all: banner tooling

banner:
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

terraform: all terraform.init terraform.validate terraform.apply

terraform.init: all
	@echo "[terraform] Initializing cluster infrastructure with terraform"
	@./bin/terraform-init.sh

terraform.validate: all
	@echo "[terraform] Validate cluster infrastructure with terraform"
	@./bin/terraform-validate.sh

terraform.apply: all
	@echo "[terraform] Creating cluster infrastructure with terraform"
	@./bin/terraform-apply.sh

terraform.apply.force: all
	@echo "[terraform] Creating cluster infrastructure with terraform by bruceforce"
	@./bin/terraform-apply.sh --loop

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
