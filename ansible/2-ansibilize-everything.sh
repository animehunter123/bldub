#!/bin/bash

echo "
@@ OPENING UP UBUNTU"
ansible-playbook -i inventory/hosts.ini playbooks/ubuntu-openup.yml

echo "
@@ SETTING P@ pass"
ansible-playbook -i inventory/hosts.ini playbooks/ubuntu-set-root-password.yml #--ask-become-pass
