#!/usr/bin/env bash
set -euo pipefail

AWS_REGION="eu-central-1"
CLUSTER_NAME="siva-eks-2048"
AWS_ACCOUNT_ID="123456789012"
POLICY_NAME="AWSLoadBalancerControllerIAMPolicy"
SERVICE_ACCOUNT_NAME="aws-load-balancer-controller"
NAMESPACE="kube-system"

# 1. Associate IAM OIDC provider with the EKS cluster.
eksctl utils associate-iam-oidc-provider \
  --cluster "$CLUSTER_NAME" \
  --region "$AWS_REGION" \
  --approve

# 2. Download the current IAM policy from the official AWS Load Balancer Controller project.
curl -fsSL \
  -o /tmp/iam_policy.json \
  https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json

# 3. Create policy if it does not already exist.
if ! aws iam get-policy --policy-arn "arn:aws:iam::${AWS_ACCOUNT_ID}:policy/${POLICY_NAME}" >/dev/null 2>&1; then
  aws iam create-policy \
    --policy-name "$POLICY_NAME" \
    --policy-document file:///tmp/iam_policy.json
else
  echo "IAM policy already exists: $POLICY_NAME"
fi

# 4. Create IAM role and Kubernetes service account.
eksctl create iamserviceaccount \
  --cluster "$CLUSTER_NAME" \
  --region "$AWS_REGION" \
  --namespace "$NAMESPACE" \
  --name "$SERVICE_ACCOUNT_NAME" \
  --attach-policy-arn "arn:aws:iam::${AWS_ACCOUNT_ID}:policy/${POLICY_NAME}" \
  --approve \
  --override-existing-serviceaccounts

# 5. Install controller using Helm.
helm repo add eks https://aws.github.io/eks-charts
helm repo update eks

helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n "$NAMESPACE" \
  --set clusterName="$CLUSTER_NAME" \
  --set serviceAccount.create=false \
  --set serviceAccount.name="$SERVICE_ACCOUNT_NAME" \
  --set region="$AWS_REGION"

kubectl get deployment -n kube-system aws-load-balancer-controller
