#!/usr/bin/env bash
set -euo pipefail

AWS_REGION="eu-central-1"
CLUSTER_NAME="siva-eks-2048"

# Creates an EKS cluster without a default node group.
# Workloads will run on AWS Fargate after the Fargate profile is created.
eksctl create cluster \
  --name "$CLUSTER_NAME" \
  --region "$AWS_REGION" \
  --fargate

aws eks update-kubeconfig \
  --region "$AWS_REGION" \
  --name "$CLUSTER_NAME"

kubectl get nodes
