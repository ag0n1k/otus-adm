#!/usr/bin/env bash
pid_=$$
echo "pid is "${pid_}
dd if=/dev/urandom of=/dev/null status=progress
