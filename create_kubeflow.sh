#!/bin/bash

echo "                              *************************************************                              "
echo "                              *                                               *                              "
echo "                              *          install nfs_provisioner.yaml         *                              "
echo "                              *                                               *                              "
echo -e "                              *************************************************                              \n\n"
ansible-playbook install_nfs_provisioner.yaml -kK -e "admin=gpuadmin nfs_ip=192.168.1.123 nfs_path=/rancher"

echo "                              *************************************************                              "
echo "                              *                                               *                              "
echo "                              *            install kubeflow v1.5.yaml         *                              "
echo "                              *                                               *                              "
echo -e "                              *************************************************                              \n\n"
#ansible-playbook install_kubeflow_v1.5.yaml -kK -e "admin=gpuadmin master_ip=192.168.1.47"
