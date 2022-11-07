all: banner

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

terraform: all terraform.init terraform.validate terraform.apply terraform.post

terraform.init: all
	@echo "[terraform] Initializing cluster infrastructure with terraform"
	@./bin/terraform-init.sh

terraform.validate: all
	@echo "[terraform] Validate cluster infrastructure with terraform"
	@./bin/terraform-validate.sh

terraform.plan: all
	@echo "[terraform] Plan cluster infrastructure with terraform"
	@./bin/terraform-plan.sh

terraform.apply: all
	@echo "[terraform] Creating cluster infrastructure with terraform"
	@./bin/terraform-apply.sh

terraform.apply.force: all
	@echo "[terraform] Creating cluster infrastructure with terraform by bruceforce"
	@./bin/terraform-apply.sh --loop

terraform.post: all
	@echo "[terraform] Postprocessing terraform infrastructure"
	@./bin/generated/peering.sh

kubespray: all kubespray.deploy kubespray.post

kubespray.clone:
	@git clone --branch v2.18.1 https://github.com/kubernetes-sigs/kubespray.git .kubespray

kubespray.deploy: all
	@echo "[kubespray] Bootstrap cluster with kubespray"
	@./bin/kubespray-deploy.sh

kubespray.post: all
	@echo "[kubespray] Postprocessing kubespray bootstrapping"
	@./bin/kubespray-post.sh

deploy: terraform terraform.post kubespray kubespray.post
	@echo "[kubespray] Deploy OCI Kubernetes Cluster"

destroy: all
	@echo "[bootstrap] Destroying OCI Kubernetes Cluster"
	@echo -n "Are you sure? [y/N] " && read ans && if [ $${ans:-'N'} = 'y' ]; then cd terraform && terraform destroy -var-file="variables.tfvars"; fi
