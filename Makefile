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

terraform: banner terraform.init terraform.validate terraform.apply terraform.post

terraform.init: banner
	@echo "[terraform] Initializing cluster infrastructure with terraform"
	@./bin/terraform-init.sh

terraform.validate: banner
	@echo "[terraform] Validate cluster infrastructure with terraform"
	@./bin/terraform-validate.sh

terraform.plan: banner
	@echo "[terraform] Plan cluster infrastructure with terraform"
	@./bin/terraform-plan.sh

terraform.apply: banner
	@echo "[terraform] Creating cluster infrastructure with terraform"
	@./bin/terraform-apply.sh

terraform.apply.force: banner
	@echo "[terraform] Creating cluster infrastructure with terraform by bruceforce"
	@./bin/terraform-apply.sh --loop

terraform.post: banner
	@echo "[terraform] Postprocessing terraform infrastructure"
	@./bin/generated/peering.sh

ansible: banner
	@echo "[ansible] Configuring bootstraped infrastructure"
	@./bin/ansible-playbook.sh

kubespray: banner kubespray.deploy kubespray.post

kubespray.clone: banner
	@git clone --branch v2.21.0 https://github.com/kubernetes-sigs/kubespray.git .kubespray

kubespray.deploy: banner
	@echo "[kubespray] Bootstrap cluster with kubespray"
	@./bin/kubespray-deploy.sh

kubespray.post: banner
	@echo "[kubespray] Postprocessing kubespray bootstrapping"
	@./bin/kubespray-post.sh

deploy: terraform ansible kubespray
	@echo "[kubespray] Deploy OCI Kubernetes Cluster"

destroy:
	@echo "[bootstrap] Destroying OCI Kubernetes Cluster"
	@echo -n "Are you sure? [y/N] " && read ans && if [ $${ans:-'N'} = 'y' ]; then cd terraform && terraform destroy -var-file="variables.tfvars"; fi
