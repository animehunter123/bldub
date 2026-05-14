#!/bin/bash

echo "
@@ OPENING UP UBUNTU"
ansible-playbook -i inventory/hosts.ini playbooks/ubuntu-openup.yml

echo "
@@ Installing docker-ce UBUNTU"
ansible-playbook -i inventory/hosts.ini playbooks/ubuntu-install-docker #--ask-become-pass

echo "
@@ SETTING P@ pass"
ansible-playbook -i inventory/hosts.ini playbooks/ubuntu-set-root-password.yml #--ask-become-pass
