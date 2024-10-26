#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: $0"
    exit 1
}

# Start dockerd in the background
containerd &

sleep 10

/runtime/docker.sh

# Wait a moment for dockerd to initialize
sleep 5

# Construct the installation command
/opt/kasm/current/bin/start

# Execute the installation command
eval "$install_command"

docker logs -f kasm_agent
