#!/usr/bin/env bash
set -euo pipefail

kubectl apply -k manifests/

kubectl rollout status deployment/deployment-2048 -n game-2048 --timeout=180s
kubectl get all -n game-2048
kubectl get ingress -n game-2048
