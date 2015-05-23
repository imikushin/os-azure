# Running RancherOS on MS Azure cloud

## Prerequisites

- [MS Azure account](http://azure.microsoft.com/)
- [Azure CLI](https://github.com/Azure/azure-xplat-cli)
- [Connect Azure CLI to your subscription](http://azure.microsoft.com/en-us/documentation/articles/xplat-cli/#configure)
- installed packages: apg, jq
- you are logged in with `azure` CLI


## Build the image

Check RancherOS version and edit the image name in `./common.sh`. Currently: 

```bash
RANCHEROS_VERSION="v0.3.1-rc3"
RANCHEROS_IMAGE=RancherOS-${RANCHEROS_VERSION}-debug1
```

Build the image:

```bash
./build-rancheros-image.sh
```

A new RancherOS image is built. Now you can quickly spin up an instance: 

```bash
./create-instance.sh
```
