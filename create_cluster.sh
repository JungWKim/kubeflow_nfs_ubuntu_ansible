#!/bin/bash

ansible-playbook prerequisite.yaml -kK -e "admin=gpuadmin"

ansible-playbook setup_master.yaml -kK -e "admin=gpuadmin master_ip=192.168.1.47"

ansible-playbook join_worker.yaml -kK -e "admin=gpuadmin"

ansible-galaxy collection install kubernetes.core

ansible-playbook gpu_operator.yaml -kK -e "admin=gpuadmin"
