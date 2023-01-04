# KIE WorkBench & Server on Kubernetes
Kubernetes manifests to install Jboss Drools KIE Business-Central Workbench and KIE Server

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/from-referrer/)

First, modify Makefile to apply to your environment :
```bash
export MASTER1 ?= <your k3s cluster server ip or fqdn name> 
export DOMAIN ?= <your domain name>
```

Then, set your environment :
```bash
make ssh_set
make ssh_test
make k3s_config
```

Then, install KIE WorkBench & Server,
the url for your WB will be https://kie-wb.drools.<your domain name>
the url for your Server will be https://kie-server.drools.<your domain name>
```bash
make k3s_drools 
```

Configure, buil and deploy your model and test it :
```bash
make drools_test
```