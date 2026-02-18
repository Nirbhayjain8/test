#!/bin/bash
set -e

echo "Starting Docker daemon..."
dockerd \
  --host=unix:///var/run/docker.sock \
  --host=tcp://0.0.0.0:2375 \
  > /var/log/docker.log 2>&1 &

sleep 10

# force k3d to use local socket
unset DOCKER_HOST
export DOCKER_HOST=unix:///var/run/docker.sock

echo "Docker info:"
docker info

echo "Creating k3d cluster..."
k3d cluster create wiki \
  --agents 1 \
  -p "8080:80@loadbalancer"

export KUBECONFIG=$(k3d kubeconfig write wiki)

echo "Building FastAPI image..."
cd wiki-service
docker build -t wiki-service .
cd ..

echo "Importing image into cluster..."
k3d image import wiki-service -c wiki

echo "Installing Helm chart..."
cd wiki-chart
helm dependency update || true
helm install wiki .

echo "Cluster ready at http://localhost:8080"
tail -f /dev/null
