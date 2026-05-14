#!/bin/bash

echo "@@ Trying to install ansible and ansible-playbook..."
python3 -m pip install --user ansible
python3 -m pip install --user ansible-core
python3 -m pip install --upgrade --user ansible

echo "
Installation complete (I think?). Pip installed ansible, you can run it now.

--------------------------

IMPORTANT #1
THE ANSIBLE CONTROLLER HOST MUST BE RUNNING THE LATEST VERSION OF PYTHON. NO EXCUSES!!!
THUS - I HIGHLY RECCOMEND YOU USING THE LATEST VERSION OF PYTHON BEFORE CONTINUING TO THE NEXT SCRIPT.
I.e. 
conda create -y -n py3.14 python=3.14
conda activate py3.14  

IMPORTANT #2
@@ 1. MAKE SURE THE SSH KEY WORKS. (ssh-copy-id lmadmin@blah, AND NOPASSWD: for sudoers group)
@@ 2. FOR UB>2604 MAKE SURE that visudo has sudoers with NOPASSWD: THIS IS REQUIRED!!!!!!!!!!! UGH!!!!*****

IMPORTANT #3
@@ Make sure the ./ansible.cfg         LOOKS GOOD TO YOU
@@ Make sure the ./inventory/hosts.ini LOOKS GOOD TO YOU

Read the above carefully. Script complete.
"
