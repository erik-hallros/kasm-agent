#!/bin/bash

# Load environment variables from .env file
set -a
source .env
set +a

# Check if the pod exists
if sudo kubectl get pod "$POD_NAME" > /dev/null 2>&1; then
    # Delete the existing pod
    echo "Deleting pod $POD_NAME..."
    sudo kubectl delete pod "$POD_NAME"

    # Check if the deletion was successful
    if [ $? -eq 0 ]; then
        echo "Pod $POD_NAME deleted successfully."
    else
        echo "Failed to delete pod $POD_NAME, but it may not exist."
    fi
else
    echo "Pod $POD_NAME does not exist, skipping deletion."
fi

sudo kubectl create secret docker-registry my-registry-secret \
    --docker-username=$DOCKER_USERNAME \
    --docker-password=$DOCKER_TOKEN \
    --docker-server=https://index.docker.io/v1/

# Redeploy by applying the YAML file
echo "Redeploying pod from $YAML_FILE..."
sudo kubectl apply -f "$YAML_FILE"

# Check if the redeployment was successful
if [ $? -eq 0 ]; then
    echo "Pod $POD_NAME redeployed successfully."
else
    echo "Failed to redeploy pod $POD_NAME."
    exit 1
fi

# View logs of the newly deployed pod
echo "Viewing logs for pod $POD_NAME..."
sleep 10
sudo kubectl logs -f "$POD_NAME"
