#!/bin/bash

ansible-playbook prerequisite.yaml -kK

ansible-playbook setup_master.yaml -kK

ansible-playbook join_worker.yaml -kK

ansible-galaxy collection install kubernetes.core      

ansible-playbook gpu_operator.yaml -kK
