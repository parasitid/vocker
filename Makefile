include .envrc
MODNAME = "$(VERTICLE_NAME)~$(VERTICLE_VERSION)"
NAME=$(shell echo $(VERTICLE_NAME) | awk 'BEGIN{FS="~"}{print $$1"/"$$2}')
VERSION = $(VERTICLE_VERSION)
IMAGENAME = "$(NAME):$(VERSION)"

.PHONY: all build tag_latest release

all: build

clean: 
	@echo "cleaning build dir."
	@if [ -d ./build ]; then rm -Rf ./build; fi
	@echo "killing any remainging running container before removing image from repository"
	@echo $(shell ./vocker.sh stop)
	@echo "cleaning docker image from repository"
	@echo $(shell docker rmi $(IMAGENAME) 2>/dev/null)

build-mod:
	./build-mod.sh $(MODNAME)

build-scripts:
	./build-scripts.sh

build: build-mod build-scripts
	./build-docker-img.sh $(IMAGENAME)

tag_latest:
	docker tag $(IMAGENAME) $(NAME):latest

release: tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(NAME)
	@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"
