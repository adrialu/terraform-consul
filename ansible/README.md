# Ansible Playbook

This part of the repository contains all the configuration files for the instances in our network, which is handled by Terraform. We're using Ansible to install and configure software on all the instances.

The cool thing about using Ansible here instead of alternatives like Puppet is that Ansible can get it's dynamic inventory in-directly from Terraform by utilizing a small program by @adammck called `terraform-inventory`.

`terraform-inventory` didn't suit us _entirely_, so we've made a small Python script to wrap and fix its shortcomings (`inventory`).

Since we've structured our "stack" in such a way that we only have one server with a public-facing IP that we remotely-access, we need to use a proxy to reach the inner instances (e.g. consul, web and haproxy). This is done with a custom SSH configuration that Ansible will use (`ssh.cfg`). This **requires** a SSH Agent running on the system executing Ansible. This `ssh.cfg` file is also updated by the `inventory` script from the dynamic inventory.

## Usage

Install `terraform-inventory` (requires `Go`)

```
go get -u github.com/adammck/terraform-inventory
```

The `terraform-inventory` binary must be available on the PATH.  
Make sure the SSH private key for remote access to the `manager` is available at `$HOME/.ssh/terraform.pem`.

Then just run `ansible-playbook` like so:

```
ansible-playbook -i inventory playbook.yml
```
