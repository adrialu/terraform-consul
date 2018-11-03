## Overview

`main.tf`
- defines the main router on OpenStack, connected to the external router
- defines the keypair used for remote access
- defines the remote access security group

`variables.tf`
- defines all the variables used throughout all the files
- has defaults specific to our OpenStack environment

`manager.tf`
- creates a "manager" instance, used for remote access to the internal network
- creates an internal management network which all instances are connected to
- creates security groups for internal SSH access
- creates floating IPs used to access the instance remotely
- uses "cloud-init" for SSH key provisioning
	- this has to be done early, hence here instead of in Ansible
	- templates for this is found in `templates/`

`consul.tf` + `proxy.tf` + `web.tf`
- creates instance(s) for themselves
- creates security group(s) for themselves
- creates internal network(s) for themselves
	- a `consul` network is used by all instances for node/service discovery
	- a `web` network is used by the `proxy` and `web` instances for HTTP communication
	- each network has its own CIDR

`terraform.tfvars`
- defines variable beforehand instead of having to input them interactively
	- see `terraform.tfvars.example` and comments in `variables.tf`

`terraform.tfstate`
- holds the current state of the applied infrastructure
	- should never be version controlled

## Usage

```
# generate the SSH key used internally between nodes
# this was a limitation of OpenStack/Terraform we found, so we had to create it beforehand, locally
ssh-keygen -t rsa -b 4096

# load the OpenStack environement file
# these could be defined directly in Terraform, but we used the OpenStack-provided "rc" file
source ~/project.rc

# initialize Terraform with the required modules
terraform init

# prepare the configurations and error checking/linting
terraform plan

# execute the instructions (and also does a "plan" first to make sure)
terraform apply

# destroy the entire infrastructure
terraform destroy
```
