#!/bin/bash

ADMIN=
MASTER_IP=

echo -e "                              *************************************************                              "
echo -e "                              *                                               *                              "
echo -e "                              *           execute prerequisite.yaml           *                              "
echo -e "                              *                                               *                              "
echo -e "                              *************************************************                              \n\n"
ansible-playbook prerequisite.yaml -kK -e "admin=${ADMIN}"

echo -e "                              *************************************************                              "
echo -e "                              *                                               *                              "
echo -e "                              *           execute setup_master.yaml           *                              "
echo -e "                              *                                               *                              "
echo -e "                              *************************************************                              \n\n"
ansible-playbook setup_master.yaml -kK -e "admin=${ADMIN} MASTER_IP=${MASTER_IP}"

echo -e "                              *************************************************                              "
echo -e "                              *                                               *                              "
echo -e "                              *            execute join_worker.yaml           *                              "
echo -e "                              *                                               *                              "
echo -e "                              *************************************************                              \n\n"
ansible-playbook setup_worker.yaml -kK -e "admin=${ADMIN}"

echo -e "                              *************************************************                              "
echo -e "                              *                                               *                              "
echo -e "                              *       install k8s.core ansible-galaxy         *                              "
echo -e "                              *                                               *                              "
echo -e "                              *************************************************                              \n\n"
ansible-galaxy collection install kubernetes.core

echo -e "                              *************************************************                              "
echo -e "                              *                                               *                              "
echo -e "                              *           execute gpu_operator.yaml           *                              "
echo -e "                              *                                               *                              "
echo -e "                              *************************************************                              \n\n"
ansible-playbook install_gpu_operator.yaml -kK -e "admin=${ADMIN}"
