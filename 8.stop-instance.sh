#!/bin/bash

REGION="us-east-2"
export AWS_SHARED_CREDENTIALS_FILE="/home/e1087/devops/awsInfra/.aws/credentials"

# Check if arguments are passed
if [ $# -eq 0 ]; then
    echo "No instance names provided. Please provide instance names as arguments."
    exit 1
fi

# Loop through each instance name passed as arguments
for INSTANCE_NAME in "$@"; do
    echo "Stopping instance with Name tag: $INSTANCE_NAME..."

    # Get the Instance ID(s) based on the Name tag
    INSTANCE_IDS=$(aws ec2 describe-instances \
        --filters "Name=tag:Name,Values=${INSTANCE_NAME}" \
        --query "Reservations[*].Instances[*].InstanceId" \
        --output text \
        --region $REGION)

    # Check if the instance ID was found
    if [ -z "$INSTANCE_IDS" ]; then
        echo "No instance found with Name tag: $INSTANCE_NAME in region: $REGION"
        continue  # Skip to the next instance name
    fi

    # Stop the instance
    echo "Stopping instance(s): $INSTANCE_IDS in region: $REGION..."
    aws ec2 stop-instances --instance-ids $INSTANCE_IDS --region $REGION

    # Wait for the instance to be stopped
    echo "Waiting for instance(s) to stop..."
    aws ec2 wait instance-stopped --instance-ids $INSTANCE_IDS --region $REGION

    echo "Instance(s) stopped successfully: $INSTANCE_IDS"
done
