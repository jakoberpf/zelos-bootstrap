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

deploy:

destroy:

test.nmap: all
	nmap 130.61.169.137 -Pn -p T:2379,6443