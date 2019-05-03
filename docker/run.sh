#!/bin/sh

# this runs inside the container

echo
echo ">>> Setting up kubectl and helm <<<"

kubectl cluster-info
kubectl describe nodes | grep InternalIP

kubectl config use-context docker-for-desktop
kubectl label nodes --all --overwrite openwhisk-role=invoker

helm init --upgrade
kubectl create clusterrolebinding tiller-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:default

echo
echo ">>> Installing openwhisk <<<"
echo " - k8s namespace: openwhisk"
echo " - helm release : openwhisk"
helm install openwhisk-deploy-kube/helm/openwhisk --namespace=openwhisk --name=openwhisk -f values.yaml --replace --wait

kubectl -n openwhisk -ti exec openwhisk-wskadmin -- wskadmin user list guest

echo ">>> Use this as ~/.wskprops <<<"
cat << EOF 
APIHOST=localhost:31001
AUTH=23bc46b1-71f6-4ed5-8c54-816aa4f8c502:123zO3xZCLrMN6v2BKK1dXYFpXlPkccOFqm12CdAsMgRU4VrNZ9lyGVCGuMDGIwP
NAMESPACE=guest
EOF
