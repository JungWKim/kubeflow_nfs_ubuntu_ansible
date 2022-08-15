#!/bin/bash

echo "                              *************************************************                              "
echo "                              *                                               *                              "
echo "                              *           execute prerequisite.yaml           *                              "
echo "                              *                                               *                              "
echo "                              *************************************************                              \n\n"
ansible-playbook prerequisite.yaml -kK -e "admin=gpuadmin"

echo "                              *************************************************                              "
echo "                              *                                               *                              "
echo "                              *           execute setup_master.yaml           *                              "
echo "                              *                                               *                              "
echo "                              *************************************************                              \n\n"
ansible-playbook setup_master.yaml -kK -e "admin=gpuadmin master_ip=192.168.1.47"

echo "                              *************************************************                              "
echo "                              *                                               *                              "
echo "                              *            execute join_worker.yaml           *                              "
echo "                              *                                               *                              "
echo "                              *************************************************                              \n\n"
ansible-playbook join_worker.yaml -kK -e "admin=gpuadmin"

echo "                              *************************************************                              "
echo "                              *                                               *                              "
echo "                              *       install k8s.core ansible-galaxy         *                              "
echo "                              *                                               *                              "
echo "                              *************************************************                              \n\n"
ansible-galaxy collection install kubernetes.core

echo "                              *************************************************                              "
echo "                              *                                               *                              "
echo "                              *           execute gpu_operator.yaml           *                              "
echo "                              *                                               *                              "
echo "                              *************************************************                              \n\n"
ansible-playbook gpu_operator.yaml -kK -e "admin=gpuadmin"
