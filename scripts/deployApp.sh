#!/bin/bash

ansible-playbook ansible/playbooks/k3s-up.yaml --extra-vars "@ansible-vars.yaml"

echo "-----"
echo "kubernetes has been installed!"

chmod 600 kubeconfig
ansible-playbook ansible/playbooks/helm-up.yaml --extra-vars "@ansible-vars.yaml"
echo "virgo chat app has been deployed onto kubernetes!"