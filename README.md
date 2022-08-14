# Simple Explanation about the playbook
## 1. this is for creating 1 master and multiple worker nodes
## 2. It can be only executed on master node
## 3. kubectl can be used by both administrator and root
#
# Prerequisite things you must do before starting script
## 1. fix every ip of every node
## 2. install sshpass on every node
## 3. change hostnames on each node
## 4. input 'nodes', 'master', 'workers' into /etc/ansible/hosts
## 5. use all the same account through worker nodes
## 6. input right 'admin', 'master_ip' in every yaml file
