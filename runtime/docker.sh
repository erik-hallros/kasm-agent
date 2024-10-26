#!/bin/bash

# Number of retries
max_retries=5
# Delay between retries (in seconds)
retry_delay=10

# Function to start dockerd
start_dockerd() {
    dockerd &
}

# Loop to attempt starting dockerd
for (( i=1; i<=max_retries; i++ ))
do
    echo "Attempting to start dockerd (Attempt $i of $max_retries)..."

    # Start dockerd
    start_dockerd

    # Wait a moment to give dockerd time to start
    sleep 5

    # Check if dockerd is running
    if pgrep -x "dockerd" > /dev/null; then
        echo "dockerd started successfully."
        exit 0
    else
        echo "Failed to start dockerd."
    fi

    # Wait before retrying
    echo "Retrying in $retry_delay seconds..."
    sleep $retry_delay
done

echo "Exceeded maximum retries. Exiting."
exit 1
