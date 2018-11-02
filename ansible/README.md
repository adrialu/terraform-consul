## Overview

`playbook.yml`
- defines all roles for machines in the inventory

`inventory`
- a wrapper for [terraform-inventory]() that creates a dynamic inventory for Ansible
- it also cleans up some extra inventory groups that _terraform-inventory_ defines
- it also updates the `ssh.cfg` file
	- `ssh.cfg` defines SSH configuration used by Ansible (used instead of `~/.ssh/config`)
	- it allows proxy connections _through_ the manager to the internal nodes
	- it requires the SSH key for the "manager" node to be at `~/.ssh/terraform.pem`

`roles/`
- defines all roles (tasks which should be performed)
- has handlers (event-based tasks)
- has templates (configurations with dynamic content)

`group_vars`
- holds group-wide variables for the inventory
	- used to tell Ansible which SSH config file to use (see `ssh.cfg`)

`library/`
- holds non-default Ansible modules
	- the only one we needed was the [Snap]() package module, which is slated for Ansible 2.8, the next version

## Usage

```
# install dependencies
go get -u github.com/adammck/terraform-inventory

# execute the playbook, using the inventory script
ansible-playbook -i inventory playbook.yml
```
