# —— Inspired by ———————————————————————————————————————————————————————————————
# http://fabien.potencier.org/symfony4-best-practices.html
# https://speakerdeck.com/mykiwi/outils-pour-ameliorer-la-vie-des-developpeurs-symfony?slide=47
# https://blog.theodo.fr/2018/05/why-you-need-a-makefile-on-your-project/
# https://www.strangebuzz.com/en/snippets/the-perfect-makefile-for-symfony

# Setup ————————————————————————————————————————————————————————————————————————

# Parameters
#SHELL         = 
#PROJECT       = 
#GIT_AUTHOR    = 
#HTTP_PORT     = 

# Executables
EXEC_PHP      = docker exec -it php74-container /bin/bash
PHP 		  = docker exec php74-container
COMPOSER      = composer
GIT           = git

# Alias
#SYMFONY       = $(EXEC_PHP) bin/console
SYMFONY       = $(PHP) sh -c "bin/console"

# Executables: local only
SYMFONY_BIN   		= symfony
BREW          		= brew
DOCKER        		= docker
DOCKER_COMPOSE  	= docker-compose
DOCKER_IMAGES_LIST 	:= $(docker images -qa -f dangling=true)


# Misc
.DEFAULT_GOAL = help
.PHONY       =  # Not needed here, but you can put your all your targets to be sure
                # there is no name conflict between your files and your targets.

## —— 🐝 The Strangebuzz Symfony Makefile 🐝 ———————————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## —— PHP 🐘 (macOS with brew) —————————————————————————————————————————————————
php-upgrade: ## Upgrade PHP to the last version
	$(BREW) upgrade php

php-set-7-2: ## Set php 7.2 as the current PHP version
	$(BREW) unlink php@7.3 && brew unlink php@7.4
	$(BREW) link php@7.2 --force

php-set-7-3: ## Set php 7.3 as the current PHP version
	$(BREW) unlink php@7.2 && brew unlink php@7.4
	$(BREW) link php@7.3 --force

php-set-7-4: ## Set php 7.4 as the current PHP version
	$(BREW) unlink php@7.2 && brew unlink php@7.3
	$(BREW) link php@7.4 --force

## —— Symfony 🎵 ———————————————————————————————————————————————————————————————
sf: ## List all Symfony commands
	$(SYMFONY)

cc: ## Clear the cache. DID YOU CLEAR YOUR CACHE????
	$(SYMFONY) cache:clear

warmup: ## Warmup the cache
	$(SYMFONY) cache:warmup

fix-perms: ## Fix permissions of all var files
	chmod -R 777 var/*

assets: purge ## Install the assets with symlinks in the public folder
	$(SYMFONY) assets:install public/ --symlink --relative

purge: ## Purge cache and logs
	rm -rf var/cache/* var/logs/*

## —— Docker 🐳 ————————————————————————————————————————————————————————————————

up: ## Start the docker hub (MySQL,redis,adminer,elasticsearch,head,Kibana)
	$(DOCKER_COMPOSE) up -d
.PHONY: up

docker-build: ## UP + rebuild the application image
	$(DOCKER_COMPOSE) up -d --build

down: ## Stop the docker hub
	$(DOCKER_COMPOSE) down --remove-orphans

bash: ## Connect to the application container
	$(DOCKER) container exec -it php74-container bash

## —— Project 🐝 ———————————————————————————————————————————————————————————————
build: ##@setup build docker images
	$(DOCKER_COMPOSE) build
.PHONY: build

#start: up ## Start docker
start: ##@development bring up dev environment
	$(MAKE) up
.PHONY: start

#stop: down ## Stop docker
stop: ##@development stop servers
	$(DOCKER_COMPOSE) stop -t 1
.PHONY: stop

setup: ##@setup Create dev enviroment
	$(MAKE) composer-install
.PHONY: setup

composer-install: ##setup install composer packages
	$(PHP) sh -c "composer install"
.PHONY: composer-install

#clean: stop ##@setup stop and remove containers
#	$(MAKE) clean-vendor
#	$(DOCKER_COMPOSE) down --remove-orphans
#	@if [ -n "$(DOCKER_IMAGES_LIST)" ]; then \
 #       $(DOCKER) rmi "$(DOCKER_IMAGES_LIST)"; \
#    fi
#.PHONY: clean

#clean-vendor: ##@development remove vendor
	##$(PHP) sh -c "cd ./app"
	##$(PHP) sh -c "cd app"
#	@if [ -d "vendor" ]; then rm -rf vendor; fi
#.PHONY: clean-vendor


commands: ## Display all commands in the project namespace
	$(SYMFONY) list $(PROJECT)

## —— Stats 📜 —————————————————————————————————————————————————————————————————
stats: ## Commits by the hour for the main author of this project
	$(GIT) log --author="$(GIT_AUTHOR)" --date=iso | perl -nalE 'if (/^Date:\s+[\d-]{10}\s(\d{2})/) { say $$1+0 }' | sort | uniq -c|perl -MList::Util=max -nalE '$$h{$$F[1]} = $$F[0]; }{ $$m = max values %h; foreach (0..23) { $$h{$$_} = 0 if not exists $$h{$$_} } foreach (sort {$$a <=> $$b } keys %h) { say sprintf "%02d - %4d %s", $$_, $$h{$$_}, "*"x ($$h{$$_} / $$m * 50); }'