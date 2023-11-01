#!/bin/bash

# Deploy the 01-namespace.yaml first
kubectl apply -f 01-namespace.yaml

NAMESPACE=vote

# List of all manifest files in the order you specified
manifests=(
  "02-redis-deployment.yaml"
  "03-redis-service.yaml"
  "04-vote-deployment.yaml"
  "05-vote-service.yaml"
  "06-db-deployment.yaml"
  "07-db-service.yaml"
  "08-worker-deployment.yaml"
  "09-result-deployment.yaml"
  "10-result-service.yaml"
)

for manifest in "${manifests[@]}"; do
  # Apply the current manifest
  kubectl apply -f $manifest

  # If the manifest is a deployment, then wait for its rollout status
  if [[ $manifest == *"-deployment.yaml" ]]; then
    # Extracting deployment name from the manifest file
    deployment_name=$(grep 'name:' $manifest | head -1 | awk '{print $2}')
    
    echo "Waiting for deployment $deployment_name in namespace $NAMESPACE to complete..."
    kubectl rollout status deployment/$deployment_name -n $NAMESPACE
  fi
done

echo "All manifests have been deployed!"

echo
echo "Setting up Port Forwarding..."

./port-forwards.sh

echo
echo "Port forwarding setup. The Apps are availabe at:"
echo "Cast a Vote: http://localhost:5000"
echo "View the Results: http://localhost:5001"