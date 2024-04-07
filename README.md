# virgo-infra

## Requirements

- [Install ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [Install kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
- (optional) install k9s
- Install helm

## Installing / uninstalling kubernetes on the cloud server

```
ansible-playbook ansible/playbooks/k3s-up.yaml
```

```
ansible-playbook ansible/playbooks/k3s-down.yaml
```
