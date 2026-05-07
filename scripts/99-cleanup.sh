#!/usr/bin/env bash
set -euo pipefail

AWS_REGION="eu-central-1"
CLUSTER_NAME="siva-eks-2048"
NAMESPACE="game-2048"

# Delete application resources first so the ALB is removed before deleting the cluster.
kubectl delete ingress ingress-2048 -n "$NAMESPACE" --ignore-not-found=true
kubectl delete -k manifests/ --ignore-not-found=true

# Give AWS Load Balancer Controller time to remove ALB resources.
echo "Check that the ALB is deleted before continuing if this is a production or shared account."

# Delete the EKS cluster and related CloudFormation stacks.
eksctl delete cluster \
  --name "$CLUSTER_NAME" \
  --region "$AWS_REGION"
