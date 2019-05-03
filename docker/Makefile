SHELL=/bin/bash
.PHONY: build
	
IMAGE_NAME=alexkli/openwhisk-kubernetes-installer

build:
	docker build -t $(IMAGE_NAME) .

push:
	docker push $(IMAGE_NAME)