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



# Update package list and install dependencies
sudo apt-get update
sudo apt-get install -y apt-transport-https gnupg2 curl lsb-release

# Add Envoy repository
curl -sL 'https://deb.dl.getenvoy.io/public/gpg.key' | sudo apt-key add -
echo "deb [arch=amd64] https://deb.dl.getenvoy.io/public/deb/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/getenvoy.list


# Update package list again and install Envoy
sudo apt-get update
sudo apt-get install -y getenvoy-envoy


# Run Envoy with the provided config file
echo "Starting Envoy with config file: $CONFIG_FILE"
envoy -c "$CONFIG_FILE"