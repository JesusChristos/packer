# How to build base image
Install packer https://learn.hashicorp.com/tutorials/packer/get-started-install-cli

Full in develop vars for digitalocean api key
---

Command:
```
packer validate base-docker-node.pkr.hcl
packer build -var-file develop_vars.pkr.hcl base-docker-node.pkr.hcl
```