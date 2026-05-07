#!/usr/bin/env bash
set -euo pipefail

commands=(aws kubectl eksctl helm)

for cmd in "${commands[@]}"; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "ERROR: $cmd is not installed or not in PATH"
    exit 1
  fi
  echo "OK: $cmd found"
done

echo "\nAWS identity:"
aws sts get-caller-identity
