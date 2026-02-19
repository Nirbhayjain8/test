#!/bin/sh
set -e

echo "Starting Docker daemon..."

# Start Docker daemon in background
dockerd-entrypoint.sh > /var/log/dockerd.log 2>&1 &

# Wait for Docker to be ready
until docker info > /dev/null 2>&1
do
  echo "Waiting for Docker to start..."
  sleep 2
done

echo "Docker is ready."

# Create k3d cluster and expose port 8080
k3d cluster create wiki \
  --agents 1 \
  -p "8080:80@loadbalancer"

echo "k3d cluster created."

# Build FastAPI image inside DinD
cd /app/wiki-service
docker build -t wiki-service:latest .

# Import image into k3d
k3d image import wiki-service:latest -c wiki

echo "FastAPI image imported into cluster."

# Install Helm chart
cd /app/wiki-chart
helm install wiki .

echo "Helm chart installed."

echo "Cluster is fully ready on port 8080."

# Keep container running
tail -f /dev/null
