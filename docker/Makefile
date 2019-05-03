SHELL=/bin/bash
.PHONY: build
	
IMAGE_NAME=alexkli/openwhisk-kubernetes-installer

build:
	docker build -t $(IMAGE_NAME) .

run-bash: build
	docker run -it --net=host -v ~/.kube:/root/.kube $(IMAGE_NAME) /bin/bash

test-install: build
	docker run --net=host -v ~/.kube:/root/.kube $(IMAGE_NAME)

test-uninstall: build
	docker run --net=host -v ~/.kube:/root/.kube $(IMAGE_NAME) /bin/bash -c "helm delete openwhisk --purge"

push:
	docker push $(IMAGE_NAME)