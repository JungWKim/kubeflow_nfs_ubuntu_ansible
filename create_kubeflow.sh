#!/bin/bash

ADMIN=
MASTER_IP=
NFS_IP=
NFS_PATH=

#----------- check variables are defined
func_check_variable() {

	local ERROR_PRESENCE=0

	if [ -z ${ADMIN} ] ; then
		logger -s "[Error] ADMIN is not defined." ; ERROR_PRESENCE=1 ; fi
	if [ -z ${MASTER_IP} ] ; then
		logger -s "[Error] MASTER_IP is not defined." ; ERROR_PRESENCE=1 ; fi
	if [ -z ${NFS_IP} ] ; then
		logger -s "[Error] NFS_IP is not defined." ; ERROR_PRESENCE=1 ; fi
	if [ -z ${NFS_PATH} ] ; then
		logger -s "[Error] NFS_PATH is not defined." ; ERROR_PRESENCE=1 ; fi

	if [ ${ERROR_PRESENCE} -eq 1 ] ; then
		exit 1 ; fi
}

func_check_prerequisite () {

	# /etc/os-release file existence check
	if [ ! -e "/etc/os-release" ] ; then
		logger -s "[Error] /etc/os-release doesn't exist. OS is unrecognizable."
		exit 1
	else
		# check OS distribution
		local OS_DIST=$(. /etc/os-release;echo $ID$VERSION_ID)

		if [ "${OS_DIST}" != "ubuntu20.04" ] ; then
			logger -s "[Error] OS distribution doesn't matche ubuntu20.04"
			exit 1 ; fi

		logger -s "[INFO] OS distribution matches ubuntu20.04"
	fi

	# Internet connection check
	ping -c 5 8.8.8.8 &> /dev/null
	if [ $? -ne "0" ] ; then
		logger -s "[Error] Network is unreachable."
		exit 1 ; fi

	logger -s "[INFO] Network is reachable."

	# master node connection check
	ping -c 5 ${MASTER_IP} &> /dev/null
	if [ $? -ne 0 ] ; then
		logger -s "[Error] master node is unreachable."
		exit 1 ; fi

	logger -s "[INFO] master node is reachable."

	# nfs server connection check
	ping -c 5 ${NFS_IP} &> /dev/null
	if [ $? -ne 0 ] ; then
		logger -s "[Error] nfs server is unreachable."
		exit 1 ; fi

	logger -s "[INFO] nfs server is reachable."
}

#----------- call checking functions
func_check_variable
func_check_prerequisite

#----------- start to install kubeflow
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
