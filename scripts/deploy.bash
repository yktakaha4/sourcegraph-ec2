#!/bin/bash -eu

base_dir="$(cd "$(dirname $0)/.."; pwd)"

aws cloudformation deploy \
    --stack-name "$RESOURCE_NAME" \
    --template-file "$base_dir/aws/cfn.yml" \
    --capabilities CAPABILITY_NAMED_IAM \
    --no-fail-on-empty-changeset \
    --parameter-overrides \
        ResourceName="$RESOURCE_NAME" \
        AvailabilityZoneName="$AVAILABILITY_ZONE" \
        SubnetId="$SUBNET_ID" \
        SecurityGroupIdList="$SECURITY_GROUP_ID_LIST"
