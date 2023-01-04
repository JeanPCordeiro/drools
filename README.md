# KIE WorkBench & Server on Kubernetes
Kubernetes manifests to install Jboss Drools KIE Business-Central Workbench and KIE Server

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/from-referrer/)

First, modify Makefile to apply to your environment :
```bash
export MASTER1 ?= vmi1053342.contaboserver.net
export DOMAIN ?= lean-sys.com
```

Then, set your environment :
```bash
make ssh_set
make ssh_test
make k3s_config
```

Then, install KIE WorkBench & Server :
```bash
make k3s_drools 
```

Configure, buil and deploy your model and test it :
```bash
make drools_test
```