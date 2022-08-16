#!/bin/bash

admin=gpuadmin
master_ip=192.168.1.47
nfs_ip=192.168.1.123
nfs_path=/rancher

echo -e "                              *************************************************                              "
echo -e "                              *                                               *                              "
echo -e "                              *          install nfs_provisioner.yaml         *                              "
echo -e "                              *                                               *                              "
echo -e "                              *************************************************                              \n\n"
ansible-playbook install_nfs_provisioner.yaml -kK -e "admin=${admin} nfs_ip=${nfs_ip} nfs_path=${nfs_path}"

sleep 30

echo -e "                              *************************************************                              "
echo -e "                              *                                               *                              "
echo -e "                              *            install kubeflow v1.5.yaml         *                              "
echo -e "                              *                                               *                              "
echo -e "                              *************************************************                              \n\n"
ansible-playbook install_kubeflow_v1.5.yaml -kK -e "admin=${admin} master_ip=${master_ip}"

cd ~/manifests
while ! kustomize build example | kubectl apply -f -; do echo "Retrying to apply resources"; sleep 10; done
cd -
