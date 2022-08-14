#!/bin/bash
kubeadm join 192.168.1.47:6443 --token ksuejd.p2oog8d4dv3lwde2 \
    --discovery-token-ca-cert-hash sha256:faaba45a970eb1775216f133e25ca81a042104214ca02edcd3a8a23673a496d1 
