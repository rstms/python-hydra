# python-tox Makefile

IMAGE := python-hydra
ORG := rstms
VERSION := 1.0.0

BASE_IMAGE = python:3.10.0-slim-buster
PYTHON_VERSIONS := '3.6 3.7 3.8 3.9 3.10'

# DOCKER_RUN(args,image_name)
DOCKER_RUN = $(ENV) docker run --rm $(1) $(2)

BUILD_ARGS := $(foreach ARG,BASE_IMAGE PYTHON_VERSIONS,--build-arg $(ARG)=$($(ARG)) )

# DOCKER_BUILD(options,image_name)
DOCKER_BUILD = $(ENV) docker build $(1) $(BUILD_ARGS) --tag $(2):latest $(2)

# set environment vars for docker commands
ENV := env DOCKER_BUILDKIT=1 BUILDKIT_PROGRESS=plain

build:
	$(call DOCKER_BUILD,,$(IMAGE)) 

rebuild:
	$(call DOCKER_BUILD,--no-cache,$(IMAGE)) 

# tag_and_push(local_image,org,name,version)
tag_and_push = docker tag $(1) $(2)/$(3):$(4) && docker push $(2)/$(3):$(4)
  
publish:
	@echo pushing images to dockerhub
	$(if $(wildcard ~/.docker/config.json),docker login,$(error docker-publish failed; ~/.docker/config.json required))
	$(foreach DOCKERTAG,$(VERSION) latest,$(call tag_and_push,$(IMAGE):latest,$(ORG),$(IMAGE),$(DOCKERTAG));)

run:
	$(call DOCKER_RUN,-it,$(IMAGE):latest) /bin/bash

TEST_CMD := $(foreach PV,$(PYTHON_VERSIONS),python$(PV) --version &&)

test:
	echo "TEST_CMD=$(TEST_CMD)"
	$(call DOCKER_RUN,,$(IMAGE):latest) /bin/bash -c 'pyenv versions && $(TEST_CMD) echo "OK"'

sterile: clean
	docker image prune -a -f

clean:
	docker image prune -f
	rm -f .dockerhub
