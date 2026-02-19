#!/bin/sh

dockerd-entrypoint.sh &

sleep 15

k3d cluster create wiki \
  --agents 1 \
  --port "8080:80@loadbalancer"

docker build -t wiki-service ./wiki-service
k3d image import wiki-service -c wiki

helm install wiki ./wiki-chart

echo "Cluster ready on port 8080"

tail -f /dev/null
