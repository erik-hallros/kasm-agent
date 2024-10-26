#!/bin/sh

# Start dockerd in the background
dockerd &

# Wait a moment for dockerd to initialize
sleep 5

# Construct the installation command
install_command="yes | /install/kasm_release/install.sh --role agent --no-swap-check --skip-connection-test --no-start --accept-eula"

# Add flags if the corresponding environment variables are set
[ -n "$HOSTNAME" ] && install_command="$install_command --public-hostname $HOSTNAME"
[ -n "$MANAGER_HOSTNAME" ] && install_command="$install_command --manager-hostname $MANAGER_HOSTNAME"
[ -n "$DEFAULT_MANAGER_TOKEN" ] && install_command="$install_command --manager-token $DEFAULT_MANAGER_TOKEN"

# Execute the installation command
eval "$install_command"

# Print message indicating completion
echo "Installation completed."
