#!/bin/bash

# Update and install prerequisites
sudo apt-get update
sudo apt-get install -y apt-transport-https curl gnupg2 lsb-release ca-certificates

# Add Envoy's official GPG key and repository
curl -sL 'https://getenvoy.io/gpg' | sudo apt-key add -
sudo add-apt-repository \
    "deb [arch=amd64] https://dl.cloudsmith.io/public/envoyproxy/envoy-stable/deb/ubuntu $(lsb_release -cs) main"

# Install Envoy
sudo apt-get update
sudo apt-get install -y envoy

# Verify installation
if envoy --version; then
    echo "Envoy installed successfully!"
else
    echo "Envoy installation failed."
    exit 1
fi

export $(cat .env | xargs) # Load the environment variables
envsubst <envoy-template.yaml >envoy.yaml

# Move the configuration file to /etc/envoy
sudo mkdir -p /etc/envoy
sudo cp ./envoy.yaml /etc/envoy/envoy.yaml

# Create a systemd service file for Envoy
sudo tee /etc/systemd/system/envoy.service >/dev/null <<EOF
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
