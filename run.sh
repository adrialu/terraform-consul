#!/bin/bash

cd terraform
terraform init
terraform apply

# wait for the network stacks to come up
sleep 60

cd ../ansible
ansible-playbook -i inventory playbook.yml
cd ..
