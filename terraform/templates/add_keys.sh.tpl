#!/bin/bash

# add the keys
echo -n "${private_key}" > /home/ubuntu/.ssh/id_rsa
echo -n "${public_key}" > /home/ubuntu/.ssh/id_rsa.pub

# update permissions
chown ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa*
chmod 0600 /home/ubuntu/.ssh/id_rsa*
