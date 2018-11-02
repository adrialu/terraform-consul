# Terraform + Ansible + Consul

This repository contains the following:

- OpenStack orchestration with _Terraform_
- Software and configuration provisioning with _Ansible_
- Service/node discovery and DNS with _Consul_

The Ansible inventory is dynamically provided by Terraform using [terraform-inventory]() plus [a script]() to cut out the cruft. Web proxying is automatically handled with [Fabio]() using Consul's service discovery.

This repository is a demonstration of these technologies working together, but are not limited to each other.

- AWS (or any other cloud really) could have been used instead of OpenStack
	- No matter the cloud, Terraform provides **one** language to deal with them all
- Puppet could have been used instead of Ansible
	- We used Ansible because we wanted to learn something new, and it worked incredibly well with Terraform
- Haproxy could have been used instead of Fabio
	- We chose Fabio in the end since it shows off Consul better, which was one of the main intents of this project
