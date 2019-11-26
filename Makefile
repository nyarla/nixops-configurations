.PHONY: all create deploy

HOST := 
N := 
D :=

all: deploy

create:
	@test ! -z "$(D)" || (echo "D (deployment definition) is not defined" && exit 1)
	@test ! -z "$(N)" || (echo "N (deployment name) is not defined" && exit 1)
	nixops create $(D) -d $(N)

deploy:
	@test ! -z "$(N)" || (echo "N (deployment name) is not defined" && exit 1)
	nixops deploy -d $(N)

.PHONY: create-web deploy-web

create-web:
	@$(MAKE) D=deployment/web.internal.nyarla.net.nix N=web create

deploy-web:
	@$(MAKE) N=web deploy

ssh-web:
	nixops ssh server

reboot-web:
	nixops reboot -d web
