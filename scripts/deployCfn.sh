#!/bin/bash

aws cloudformation deploy --template-file cloudformation/cfn-virgo-stack.yaml --stack-name virgochat-stack \
    --parameter-overrides "SubnetAz1=ap-southeast-1a" "SubnetAz2=ap-southeast-1b" \
    --no-disable-rollback \
    --fail-on-empty-changeset 
