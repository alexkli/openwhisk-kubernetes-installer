#!/bin/sh

# this runs inside the container

echo
echo ">>> Adjusting openwhisk helm template <<<"
# change nginx to use HTTP port 80 (see also values.yaml)
sed -i 's/listen 443 default ssl;/listen 80;/' openwhisk-deploy-kube/helm/openwhisk/templates/nginx-cm.yaml
# change instructions to mention http for api host config
sed -i 's|wsk property set --apihost |wsk property set --apihost http://|' openwhisk-deploy-kube/helm/openwhisk/templates/NOTES.txt

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

echo ">>> wskadmin test - listing guest user <<<"
kubectl -n openwhisk exec openwhisk-wskadmin -- wskadmin user list guest

cat << EOF


>>> Install wsk cli <<<

To get started with OpenWhisk, you will need the command line tool "wsk"
https://github.com/apache/incubator-openwhisk-cli

Download from here:
    https://github.com/apache/incubator-openwhisk-cli/releases

You can also use Homebrew on Mac:

    brew install wsk

To get the latest prerelease version:

    brew tap alexkli/tap
    brew install alexkli/tap/wsk-latest


>>> Use this as ~/.wskprops <<<

----------------------------------------------------------------------------------------------------------
APIHOST=http://localhost:31001
AUTH=23bc46b1-71f6-4ed5-8c54-816aa4f8c502:123zO3xZCLrMN6v2BKK1dXYFpXlPkccOFqm12CdAsMgRU4VrNZ9lyGVCGuMDGIwP
NAMESPACE=guest
----------------------------------------------------------------------------------------------------------
EOF
