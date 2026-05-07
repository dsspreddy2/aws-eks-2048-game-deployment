#!/usr/bin/env bash
set -euo pipefail

AWS_REGION="eu-central-1"
CLUSTER_NAME="siva-eks-2048"
NAMESPACE="game-2048"
PROFILE_NAME="fp-game-2048"

kubectl apply -f manifests/namespace.yaml

eksctl create fargateprofile \
  --cluster "$CLUSTER_NAME" \
  --region "$AWS_REGION" \
  --name "$PROFILE_NAME" \
  --namespace "$NAMESPACE"

eksctl get fargateprofile \
  --cluster "$CLUSTER_NAME" \
  --region "$AWS_REGION"
