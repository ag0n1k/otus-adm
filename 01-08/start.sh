#!/usr/bin/env bash

cd server
echo " > Ensure vagrant destroyed "
vagrant destroy -f

echo " > Vagrant up"
vagrant up

cd ../client
echo " > Ensure vagrant destroyed "
vagrant destroy -f

echo " > Vagrant up"
vagrant up

if [[ $1 -eq 'destroy' ]]; then

  echo " > Destroy images...."
  sleep 10

  vagrant destroy -f
  cd ../server/

  vagrant destroy -f
fi

echo " > All stages complete."
exit 0
