# Simple Explanation about create_cluster.sh
### 1. this is for creating 1 master and multiple worker nodes
### 2. It can be only executed on master node
### 3. kubectl can be used by both administrator and root
### 4. It installs gpu operator so if your cluster doesn't have any gpus, please comment the gpu operator installation line in create_cluster.sh"
#
# Prerequisite things you must do before starting create_cluster.sh
### 1. fix ips of every node
### 2. install sshpass on every node
### 3. change hostnames on each node
### 4. use same account and password through worker nodes
### 5. input 'nodes', 'master', 'workers' into /etc/ansible/hosts
### 6. input right values in 'admin' and 'master_ip' in create_cluster.sh
### 7. change values in /etc/ansible/ansible.cfg as you prefer
#
# Simple Explanation about create_kubeflow.sh
### 1. this script must be executed after create_cluster.sh which means k8s and gpu operator already have been installed
### 2. your cluster nodes must have gpus
### 3. this doesn't use cloud provisioner but nfs provisioner
