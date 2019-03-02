#!/usr/bin/env bash

vagrant up
echo "- Generate ssh-keys"
mkdir playbooks/files
ssh-keygen -t rsa -N "" -f playbooks/files/vasia.rsa

ansible-playbook playbooks/platform.yml

# vagrant destroy