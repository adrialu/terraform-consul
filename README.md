# Terraform + Ansible + Consul

This repository contains the following:

- [OpenStack](https://www.openstack.org/) orchestration with [Terraform](https://www.terraform.io/)
- Software and configuration provisioning with [Ansible](https://www.ansible.com/)
- Service/node discovery and DNS with [Consul](https://www.consul.io/)

The Ansible inventory is dynamically provided by Terraform using [terraform-inventory](https://github.com/adammck/terraform-inventory) plus [a script](/blob/cleanup/ansible/inventory) to cut out the cruft. Web proxying is automatically handled with [Fabio](https://fabiolb.net/) using Consul's service discovery.

This repository is a demonstration of these technologies working together, but are not limited to each other.

- [AWS](https://aws.amazon.com/) (or [any other cloud](https://www.terraform.io/docs/providers/index.html) really) could have been used instead of OpenStack
	- No matter the cloud, Terraform provides **one** language to deal with them all
- [Puppet](https://puppet.com/) could have been used instead of Ansible
	- We used Ansible because we wanted to learn something new, and it worked incredibly well with Terraform
- [Haproxy](https://www.haproxy.org/) could have been used instead of Fabio
	- We chose Fabio in the end since it shows off Consul better, which was one of the main intents of this project
