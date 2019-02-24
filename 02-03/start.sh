#!/usr/bin/env bash

vagrant up

ansible-playbook playbooks/install-server.yml -i inventory/hosts.server