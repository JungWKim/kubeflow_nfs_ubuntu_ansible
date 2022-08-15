# Simple Explanation about the playbook
## 1. this is for creating 1 master and multiple worker nodes
## 2. It can be only executed on master node
## 3. kubectl can be used by both administrator and root
#
# Prerequisite things you must do before starting script
## 1. fix ips of every node
## 2. install sshpass on every node
## 3. change hostnames on each node
## 4. use same account and password through worker nodes
## 5. input 'nodes', 'master', 'workers' into /etc/ansible/hosts
## 6. input right values in 'admin' and 'master_ip' in create_cluster.sh
## 7. change values in /etc/ansible/ansible.cfg as you prefer
