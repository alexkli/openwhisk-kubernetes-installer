#!/bin/bash

# TODO check if docker for mac + kubernetes is installed and give helpful message if not

# start a docker image with kubectl & helm preinstalled
# and run our installation commands from run.sh inside the container
docker run --net=host -v ~/.kube:/root/.kube alexkli/openwhisk-kubernetes-installer