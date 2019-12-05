.PHONY: all

all:
	@echo stub

.PHNOY: create-web deploy-web ssh-web reboot-web

create-web:
	nixops create deployment/web.internal.nyarla.net.nix -d web

deploy-web:
	nixops deploy -I nixpkgs=/etc/nixpkgs -d web 

ssh-web:
	nixops ssh server

reboot-web:
	nixops reboot -d web

