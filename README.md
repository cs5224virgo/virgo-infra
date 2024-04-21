# virgo-infra

This repository contains all the tools and scripts you need to run virgo on AWS. What you need is only a local linux machine (ubuntu recommended) and an AWS Free Tier account.

## Requirements

A lot of tools is needed in order to fully deploy virgo on AWS. You can try this out in a Virtual Machine or even a docker container if you like.

- [Install ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
  - also install [PyYAML](https://pypi.org/project/PyYAML/)
- [Install kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
- [Install helm](https://helm.sh/docs/intro/install/)
- [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

## Steps

Follow these steps to get a fully working production environment of virgochat on AWS

1. Create a free-tier AWS Account
2. Ensure you can log in as Admin, either as a root account or an admin-level IAM User. Create an access key / secret key pair for cli access (go to aws console > IAM)
3. Set up AWS CLI with your credentials using `aws configure --profile virgo`
4. Test to see if AWS CLI is working with `aws sts get-caller-identity`
5. Run `./scripts/deployCfn.sh` -- this will create a cloudformation stack with name "virgochat-stack" and provision all the AWS resources necessary: from VPC, subnets, ACLs, to EC2 instance, RDS instance, and Security Groups.
6. Run `./scripts/getKey.sh` -- this will obtain the keypair of the EC2 instance and save it locally into `virgochat-key.pem`. Subsequent steps will use this key to deploy apps to the EC2 instance.
7. Run `./scripts/genArgs.sh` -- this will obtain all the necessary info to run ansible scripts later on. Namely, Public IP of the EC2 instance and RDS endpoints etc
8. Run `ansible-playbook ansible/playbooks/k3s-up.yaml --extra-vars "@ansible-vars.yaml"` -- This will install kubernetes (k3s) onto the EC2 instance
9. You can now access the one-node kubernetes cluster using `KUBECONFIG=kubeconfig kubectl get pods -A`
10. Run `ansible-playbook ansible/playbooks/helm-up.yaml --extra-vars "@ansible-vars.yaml"` -- This will deploy the backend and the frontend to run on the kubernetes cluster.

## Details of the AWS Stack

- Custom VPC -- we do not rely on the default VPC given to the AWS account after creating, instead we want to control it with CloudFormation.
- Region -- this cloudformation template assumes that it will be deployed onto Singapore (ap-southeast-1) region.
- Subnets -- two main subnets will be created in two separate availability zones.
- Network ACLs -- network ACLs are created with some permissive rules
- EC2 Instance -- One t2.micro instance will be created and placed in subnet1. It will have its own Security Group allowing the most basic access for the app to work.
- RDS Instance -- One db.t3.micro instance, running PostgreSQL v16. It will have its own Security Group allowing access.
