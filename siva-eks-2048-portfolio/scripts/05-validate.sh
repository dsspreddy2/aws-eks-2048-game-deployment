#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="game-2048"

echo "Nodes:"
kubectl get nodes -o wide

echo "\nPods:"
kubectl get pods -n "$NAMESPACE" -o wide

echo "\nService:"
kubectl get svc -n "$NAMESPACE"

echo "\nIngress:"
kubectl get ingress -n "$NAMESPACE"

echo "\nAWS Load Balancer Controller logs:"
kubectl logs -n kube-system deployment/aws-load-balancer-controller --tail=50
