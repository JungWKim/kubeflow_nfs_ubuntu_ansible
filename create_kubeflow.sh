#!/bin/bash

ADMIN=
MASTER_IP=
NFS_IP=
NFS_PATH=

echo -e "                              *************************************************                              "
echo -e "                              *                                               *                              "
echo -e "                              *          install nfs_provisioner.yaml         *                              "
echo -e "                              *                                               *                              "
echo -e "                              *************************************************                              \n\n"
ansible-playbook install_nfs_provisioner.yaml -kK -e "admin=${ADMIN} nfs_ip=${NFS_IP} nfs_path=${NFS_PATH}"

sleep 30

echo -e "                              *************************************************                              "
echo -e "                              *                                               *                              "
echo -e "                              *            install kubeflow v1.5.yaml         *                              "
echo -e "                              *                                               *                              "
echo -e "                              *************************************************                              \n\n"
ansible-playbook install_kubeflow_v1.5.yaml -kK -e "admin=${ADMIN} master_ip=${MASTER_IP}"

cd ~/manifests
while ! kustomize build example | kubectl apply -f -; do echo "Retrying to apply resources"; sleep 10; done
cd -

kubectl apply -f files/certificate.yaml
