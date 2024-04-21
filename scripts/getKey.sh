#!/bin/bash

set -e # stop immediately if any error happens

keyid=$(aws ec2 describe-key-pairs --query "KeyPairs[?KeyName=='virgo-virgochat-keypair'].KeyPairId" --output text)
aws ssm get-parameter --name /ec2/keypair/${keyid} --with-decryption --query Parameter.Value --output text > virgochat-key.pem

chmod 600 virgochat-key.pem

echo "keyfile obtained: virgochat-key.pem"