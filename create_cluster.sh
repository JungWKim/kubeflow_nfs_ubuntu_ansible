#!/bin/bash

ADMIN=
ADMIN_HOME=/home/${ADMIN}
MASTER_IP=

#----------- check variables are defined
func_check_variable() {

	local ERROR_PRESENCE=0

	if [ -z ${ADMIN} ] ; then
		logger -s "[Error] ADMIN is not defined." ; ERROR_PRESENCE=1 ; fi
	if [ -z ${MASTER_IP} ] ; then
		logger -s "[Error] MASTER_IP is not defined." ; ERROR_PRESENCE=1 ; fi

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
	
	# ADMIN HOME existence check
	if [ ! -d ${ADMIN_HOME} ] ; then
		logger -s "[Error] ADMIN HOME directory doesn't exist"
		exit 1 ; fi

	logger -s "[INFO] ADMIN HOME directory exists."

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
}

#----------- call checking functions
func_check_variable
func_check_prerequisite

#----------- start to install k8s
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
ansible-playbook setup_master.yaml -kK -e "admin=${ADMIN} master_ip=${MASTER_IP}"

echo -e "                              *************************************************                              "
echo -e "                              *                                               *                              "
echo -e "                              *            execute join_worker.yaml           *                              "
echo -e "                              *                                               *                              "
echo -e "                              *************************************************                              \n\n"
ansible-playbook setup_worker.yaml -kK -e "admin=${ADMIN}"

echo -e "                              *************************************************                              "
echo -e "                              *                                               *                              "
echo -e "                              *         execute install_dashboard.yaml        *                              "
echo -e "                              *                                               *                              "
echo -e "                              *************************************************                              \n\n"
ansible-playbook install_dashboard.yaml -kK -e "admin=${ADMIN}"

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
