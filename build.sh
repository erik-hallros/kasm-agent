#!/bin/bash

# Load environment variables from .env file
set -a
source .env
set +a

# Run the docker buildx build command
echo "Building and pushing Docker image..."
echo "$DOCKER_TOKEN" | sudo docker login -u "$DOCKER_USERNAME" --password-stdin
sudo docker buildx build --push --allow security.insecure -t "$IMAGE_TAG" -f build/Dockerfile .

# Check for success
if [ $? -eq 0 ]; then
    echo "Docker image built and pushed successfully."
else
    echo "Failed to build and push Docker image."
    exit 1
fi
