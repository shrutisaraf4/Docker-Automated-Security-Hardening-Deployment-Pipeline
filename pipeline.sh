#!/bin/bash

set -e

echo "Building image..."
docker build -t secure-app .

echo "Running Trivy scan..."

docker run --rm \
-v /var/run/docker.sock:/var/run/docker.sock \
aquasec/trivy image \
--severity CRITICAL \
--exit-code 1 \
secure-app

echo "No critical vulnerabilities found."
echo "Deploying application..."

docker run -d -p 3000:3000 secure-app
