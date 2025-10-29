#!/bin/bash

REGION="us-east-2"
export AWS_SHARED_CREDENTIALS_FILE="/home/e1087/devops/awsInfra/.aws/credentials"


# Fetch instance IDs, statuses, Name tags, and Public IPs in the specified region
INSTANCE_INFO=$(aws ec2 describe-instances \
    --query "Reservations[*].Instances[*].{
        InstanceId: InstanceId,
        Status: State.Name,
        Name: Tags[?Key=='Name'].Value | [0],
        PublicIP: PublicIpAddress
    }" \
    --output table \
    --region "$REGION")

# Check if any instance info was returned
if [ -z "$INSTANCE_INFO" ]; then
    echo "No instances found in region: $REGION"
    exit 1
fi

# Output the status, Name tag, and Public IP of all instances
echo "Instance Statuses, Name Tags, and Public IPs in region $REGION:"
echo "$INSTANCE_INFO"

