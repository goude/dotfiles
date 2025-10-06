#!/usr/bin/env bash
set -e

sudo apt update
sudo apt install ansible
ansible-playbook -k base.yml

