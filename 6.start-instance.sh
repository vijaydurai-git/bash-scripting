# #!/bin/bash

# # Prompt for user inputs
# read -p "Enter the AWS region: " REGION
# read -p "Enter the EC2 instance name (tag value): " INSTANCE_NAME

# export AWS_SHARED_CREDENTIALS_FILE="/home/vijaydurai/.aws/credentials"

# # Describe the instances and get the Instance ID(s)
# INSTANCE_IDS=$(aws ec2 describe-instances \
#     --filters "Name=tag:Name,Values=$INSTANCE_NAME" \
#     --query "Reservations[*].Instances[*].InstanceId" \
#     --output text \
#     --region $REGION)

# # Check if any instance IDs were returned
# if [ -z "$INSTANCE_IDS" ]; then
#     echo "No instances found with Name tag: $INSTANCE_NAME in region: $REGION"
#     exit 1
# fi

# # Start the instance(s)
# echo "Starting instance(s): $INSTANCE_IDS in region: $REGION..."
# aws ec2 start-instances --instance-ids $INSTANCE_IDS --region $REGION














##!/bin/bash

# Prompt for user inputs
# read -p "Enter the AWS region: " REGION



# REGION="us-east-2"

# read -p "Enter the EC2 instance name (tag value): " INSTANCE_NAME

# export AWS_SHARED_CREDENTIALS_FILE="/home/vijaydurai/.aws/credentials"

# # Describe the instances and get the Instance ID(s)
# INSTANCE_IDS=$(aws ec2 describe-instances \
#     --filters "Name=tag:Name,Values=$INSTANCE_NAME" \
#     --query "Reservations[*].Instances[*].InstanceId" \
#     --output text \
#     --region $REGION)

# # Check if any instance IDs were returned
# if [ -z "$INSTANCE_IDS" ]; then
#     echo "No instances found with Name tag: $INSTANCE_NAME in region: $REGION"
#     exit 1
# fi

# # Start the instance(s)
# echo "Starting instance(s): $INSTANCE_IDS in region: $REGION..."
# aws ec2 start-instances --instance-ids $INSTANCE_IDS --region $REGION

# # Wait for instance(s) to be in running state
# echo "Waiting for instances to start..."
# aws ec2 wait instance-running --instance-ids $INSTANCE_IDS --region $REGION

# # Retrieve and print the public IP address of the instance(s)
# PUBLIC_IPS=$(aws ec2 describe-instances \
#     --instance-ids $INSTANCE_IDS \
#     --query "Reservations[*].Instances[*].PublicIpAddress" \
#     --output text \
#     --region $REGION)

# if [ -z "$PUBLIC_IPS" ]; then
#     echo "No public IP address assigned yet. It might be an internal-only instance."
# else
#     echo "Public IP Address(es) of the instance(s): $PUBLIC_IPS"
# fi


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
    echo "Starting instance with Name tag: $INSTANCE_NAME..."

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

    # Start the instance
    echo "Starting instance(s): $INSTANCE_IDS in region: $REGION..."
    aws ec2 start-instances --instance-ids $INSTANCE_IDS --region $REGION

    # Wait for the instance to be running
    echo "Waiting for instance(s) to start..."
    aws ec2 wait instance-running --instance-ids $INSTANCE_IDS --region $REGION

    # Retrieve and print the public IP address of the instance(s)
    PUBLIC_IPS=$(aws ec2 describe-instances \
        --instance-ids $INSTANCE_IDS \
        --query "Reservations[*].Instances[*].PublicIpAddress" \
        --output text \
        --region $REGION)

    if [ -z "$PUBLIC_IPS" ]; then
        echo "No public IP address assigned yet. It might be an internal-only instance."
    else
        echo "Public IP Address(es) of the instance(s): $PUBLIC_IPS"
    fi

    echo "Instance(s) started successfully: $INSTANCE_IDS"
done

