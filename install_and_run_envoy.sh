#!/bin/bash

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

# Substitute environment variables into envoy-template.yaml and create envoy.yaml
if [ -f envoy-template.yaml ]; then
    envsubst < envoy-template.yaml > envoy.yaml
    echo "envoy.yaml file created from template."
else
    echo "envoy-template.yaml file not found."
    exit 1
fi

# Move the generated configuration file to /etc/envoy
sudo mkdir -p /etc/envoy
sudo cp ./envoy.yaml /etc/envoy/envoy.yaml

# Create a systemd service file for Envoy
sudo tee /etc/systemd/system/envoy.service > /dev/null <<EOF
[Unit]
Description=Envoy Proxy
After=network.target

[Service]
ExecStart=/usr/bin/envoy -c /etc/envoy/envoy.yaml
Restart=always
User=root
Group=root

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to pick up the new service file
sudo systemctl daemon-reload

# Start and enable the Envoy service
sudo systemctl start envoy
sudo systemctl enable envoy

# Check if Envoy is running
sudo systemctl status envoy