#/bin/bash

set -e # stop on errors

# Set value to the first argument or a default if not provided
stackname="${1:-virgochat-stack}"

virgochatpublicip=$(aws cloudformation describe-stacks --stack-name ${stackname} --query "Stacks[0].Outputs[?OutputKey=='VirgoChatPublicIp'].OutputValue" --output text)
virgochatprivateip=$(aws cloudformation describe-stacks --stack-name ${stackname} --query "Stacks[0].Outputs[?OutputKey=='VirgoChatPrivateIp'].OutputValue" --output text)
dbendpoint=$(aws cloudformation describe-stacks --stack-name ${stackname} --query "Stacks[0].Outputs[?OutputKey=='VirgoDbEndpointAddress'].OutputValue" --output text)
dbpassword=$(aws secretsmanager get-secret-value --secret-id virgo-db-masteruser-secret --query 'SecretString' --output text | jq -r .password)

cat > ansible-vars.yaml << EOF
virgochat_public_ip: ${virgochatpublicip}
virgochat_private_ip: ${virgochatprivateip}
virgodb_endpoint: ${dbendpoint}
virgodb_password: ${dbpassword}
EOF

echo "yaml file created: ansible-vars.yaml"