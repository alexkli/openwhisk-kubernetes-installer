[![](https://images.microbadger.com/badges/version/alexkli/openwhisk-kubernetes-installer.svg)](https://microbadger.com/images/alexkli/openwhisk-kubernetes-installer) [![](https://images.microbadger.com/badges/image/alexkli/openwhisk-kubernetes-installer.svg)](https://microbadger.com/images/alexkli/openwhisk-kubernetes-installer "Get your own image badge on microbadger.com")

[![](http://dockeri.co/image/alexkli/openwhisk-kubernetes-installer)](https://hub.docker.com/r/alexkli/openwhisk-kubernetes-installer)

openwhisk-kubernetes-installer
==============================

This is a simple way to install and run [Apache OpenWhisk](https://openwhisk.apache.org) locally. It requires Docker for Mac with Kubernetes enabled, and uses the [OpenWhisk Deployment on Kubernetes](https://github.com/apache/incubator-openwhisk-deploy-kube). Most of the installer logic is in the [alexkli/openwhisk-kubernetes-installer](https://hub.docker.com/r/alexkli/openwhisk-kubernetes-installer) docker image used by the install script.

## Requirements

* Docker for Mac
* with Kubernetes enabled
* with 4 GB of RAM (advanced Docker settings)
* with `docker-for-desktop` context (should be the default)
* with a docker network `host` that allows access to the host from the containers via localhost (should be available by default)

## Install

Single command:

```
docker run --net=host -v ~/.kube:/root/.kube alexkli/openwhisk-kubernetes-installer
```

Alternatively use this script from this git repository (which might do some more checks in the future):

```
./install-openwhisk.sh
```

⏰ This might take a few minutes.

The output should end with instructions how to install [wsk](https://github.com/apache/incubator-openwhisk-cli) and with the `~/.wskprops` to use:

```
APIHOST=http://localhost:31001
AUTH=23bc46b1-71f6-4ed5-8c54-816aa4f8c502:123zO3xZCLrMN6v2BKK1dXYFpXlPkccOFqm12CdAsMgRU4VrNZ9lyGVCGuMDGIwP
NAMESPACE=guest
```

Openwhisk experts: Please note that the API host is `HTTP` and not `HTTPS`, which avoids the annoying self-signed certificate issue that would have required use of `wsk -i` everywhere. Not using SSL is fine since this is only meant for local development installations.

Verify that it works:

```
wsk namespace get
```

Should output:

```
Entities in namespace: guest
packages
actions
triggers
rules
```

## Stop/remove

Quitting Docker for Mac or stopping it's Kubernetes will shut things down. When starting it again, openwhisk should come back up.

To remove the installation, run this while Docker for Mac & Kubernetes is running:

```
./uninstall-openwhisk.sh
```

## Admin commands

### wskadmin

To run [wskadmin](https://github.com/apache/incubator-openwhisk/tree/master/tools/admin), use the included `wskadmin` script:

* create a user/namespace

    ```
    ./wskadmin user create userA
    ```

* list all users/namespaces

    ```
    ./wskadmin db get subjects | grep key
    ```

### helm

`helm` is also available as script. This can be used to inspect or manage the running environment, for example:

```
./helm get openwhisk
```

## Develop

The `alexkli/openwhisk-kubernetes-installer` docker image is in the [docker/](docker/) folder. Build it using `make`.
