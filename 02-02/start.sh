#!/usr/bin/env bash

vagrant destroy -f
vagrant up
ssh_port=$(vagrant ssh-config  | grep Port | awk '{print $2}')
ssh_host=$(vagrant ssh-config  | grep HostName | awk '{print $2}')
ssh_private_key=$(vagrant ssh-config  | grep IdentityFile | awk '{print $2}')

echo "--- Check the admin user: first line login, second groups, third sudo check"
ssh -i $ssh_private_key user_allow@$ssh_host -p $ssh_port "whoami; groups; sudo whoami"

echo "--- Check the non-admin user: deny"
ssh -i $ssh_private_key user_deny@$ssh_host -p $ssh_port

vagrant destroy -f