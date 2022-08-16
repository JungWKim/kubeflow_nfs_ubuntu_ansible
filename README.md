# Summary
# k8s version : 1.20.11
# CRI : Docker v19.03
# CNI : flannel
# OS : Ubuntu 20.04.1
# provisioner : nfs
# kubeflow version : 1.5
# kustomize : 3.2.0
#
# Simple Explanation about this repository
### 1. create_cluster.sh creates 1 master and multiple worker nodes
### 2. create_cluster.sh can be executed only on master node
### 3. create_cluster.sh enables both root and one administrator account to use kubectl
### 4. craete_cluster.sh installs gpu operator so if your cluster doesn't have any gpus, please comment the gpu operator installation line in create_cluster.sh"
### 5. create_kubeflow.sh must be executed after create_cluster.sh which means k8s and gpu operator should have already been installed
### 6. create_kubeflow.sh only uses nfs provisioner
#
# How to use this repository
### 1. fix ips of every node
### 2. install sshpass on every node
### 3. change hostnames on each node(optional)
### 4. use same account and password through all nodes(this is not an option, you must do this!)
### 5. make groups 'nodes', 'master', 'workers' and write ips in /etc/ansible/hosts
### 6. input right values into 'admin', 'master_ip', 'nfs_ip', 'nfs_path' in create_cluster.sh & create_kubeflow.sh
### 7. change values in /etc/ansible/ansible.cfg as you prefer
