#!/bin/bash

# Exit script on error
set -e

# Variables
RESOURCE_GROUP="usecase-bhargav"
CLUSTER_NAME="usecase-aks"
NAMESPACE="default" # Set to "default" if not using a specific namespace

# Log into Azure
echo "Logging into Azure..."
az login --service-principal -u "$AZURE_CLIENT_ID" -p "$AZURE_CLIENT_SECRET" --tenant "$AZURE_TENANT_ID"

# Get AKS credentials
echo "Fetching AKS credentials..."
az aks get-credentials --resource-group "$RESOURCE_GROUP" --name "$CLUSTER_NAME" --overwrite-existing

# Check cluster health
echo "Checking cluster health..."
kubectl cluster-info
if [ $? -ne 0 ]; then
    echo "ERROR: Unable to connect to the Kubernetes cluster."
    exit 1
fi

# Check node health
echo "Checking node health..."
kubectl get nodes
if [ $? -ne 0 ]; then
    echo "ERROR: Node check failed."
    exit 1
fi

# Check pod health in the namespace
echo "Checking pod health in namespace '$NAMESPACE'..."
POD_STATUS=$(kubectl get pods -n "$NAMESPACE" --no-headers | awk '{print $3}' | grep -v -E "Running|Completed" || true)

if [ -n "$POD_STATUS" ]; then
    echo "ERROR: Some pods are not healthy."
    kubectl get pods -n "$NAMESPACE"
    exit 1
else
    echo "All pods are healthy in namespace '$NAMESPACE'."
    kubectl get pods -n "$NAMESPACE"
fi

# Script completed successfully
echo "AKS cluster and pod health checks completed successfully."
exit 0
