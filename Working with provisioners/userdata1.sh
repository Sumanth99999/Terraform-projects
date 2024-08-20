#!/bin/bash

# Update package lists and install Docker
apt update
apt install -y docker.io

# Start Docker service and enable it to start on boot
systemctl start docker
systemctl enable docker

# Log in to Docker Hub (optional, if your images are private, replace with your credentials)
# docker login -u your_username -p your_password

# Pull Docker images from Docker Hub
docker pull sumanthreddy1242/college-erp


# Run Docker containers
docker run -d --name college-erp -p 5000:5000 sumanthreddy1242/college-erp

# Display running containers
docker ps
