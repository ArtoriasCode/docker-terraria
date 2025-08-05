#!/bin/bash

set -e

# Set non-interactive frontend to suppress prompts
export DEBIAN_FRONTEND=noninteractive

# Check if Docker is installed
if ! command -v docker >/dev/null 2>&1; then
    echo "Docker not found. Installing..."

    sudo apt update -y
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release

    # Add Docker GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Add Docker repository
    echo \
      "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update -y
    sudo apt install -y docker-ce
else
    echo "Docker is already installed."
fi

# Check if Docker Compose (v2) is available
if ! docker compose version >/dev/null 2>&1; then
    echo "Docker Compose v2 not found. Please install it manually:"
    echo "https://docs.docker.com/compose/install/"
    exit 1
fi

# Run docker compose
echo "Running: docker compose up --build -d"
docker compose up --build -d
