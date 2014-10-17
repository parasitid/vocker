include .envrc
MODNAME = "$(VERTICLE_NAME)~$(VERTICLE_VERSION)"
NAME=$(shell echo $(VERTICLE_NAME) | awk 'BEGIN{FS="~"}{print $$1"/"$$2}')
VERSION = $(VERTICLE_VERSION)
IMAGENAME = "$(NAME):$(VERSION)"
REGISTRY = $(DOCKER_REGISTRY_ENDPOINT)


.PHONY: all build install release

all: build

clean: 
	@echo "cleaning build dir."
	@if [ -d ./build ]; then rm -Rf ./build; fi
	@echo "killing any remainging running container before removing image from repository"
	@echo $(shell ./vocker.sh stop)
	@echo "cleaning latest docker images from repository"
	@echo $(shell docker rmi $(NAME):latest 2>/dev/null)

build-mod:
	./build-mod.sh $(MODNAME)

build-scripts:
	./build-scripts.sh

build: build-mod build-scripts
	./build-docker-img.sh $(NAME):latest

install: 
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F "latest"; then echo "$(NAME) is not yet built. Please run 'make build'"; false; fi
	docker push $(REGISTRY)/$(NAME):latest

release: install
	docker tag $(NAME):latest $(REGISTRY)/$(NAME):$(VERSION)
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(REGISTRY)/$(NAME):$(VERSION)
	@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"
