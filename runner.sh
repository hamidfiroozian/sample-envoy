#!/bin/bash

set -e

# Check if the config file path is provided
if [ $# -eq 0 ]; then
    echo "Please provide the path to your Envoy config file."
    echo "Usage: $0 <path_to_config_file>"
    exit 1
fi

CONFIG_FILE=$1

# Check if the config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Config file not found: $CONFIG_FILE"
    exit 1
fi



# Update system packages
sudo apt-get update

# Install necessary dependencies
sudo apt-get install -y curl apt-transport-https ca-certificates gnupg2 gettext

# Add Envoy's official GPG key
sudo mkdir -p /etc/apt/keyrings
wget -O- https://apt.envoyproxy.io/signing.key | sudo gpg --dearmor -o /etc/apt/keyrings/envoy-keyring.gpg

# Add the Envoy APT repository
echo "deb [signed-by=/etc/apt/keyrings/envoy-keyring.gpg] https://apt.envoyproxy.io bookworm main" | sudo tee /etc/apt/sources.list.d/envoy.list

# Update the APT package list
sudo apt-get update

# Install Envoy
sudo apt-get install -y envoy

# Verify installation
if envoy --version; then
    echo "Envoy installed successfully!"
else
    echo "Envoy installation failed."
    exit 1
fi

# Load the environment variables from .env file
if [ -f .env ]; then
    export $(cat .env | xargs)
    echo "Environment variables loaded."
else
    echo ".env file not found, please make sure it exists."
    exit 1
fi


# Run Envoy with the provided config file
echo "Starting Envoy with config file: $CONFIG_FILE"
envoy -c "$CONFIG_FILE"