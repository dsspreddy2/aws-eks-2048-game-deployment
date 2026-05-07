# Implementation Runbook

## Goal

Deploy the 2048 game on Amazon EKS using Kubernetes manifests and expose it through an AWS Application Load Balancer.

## Step 1: Validate local tools

```bash
./scripts/00-prereqs-check.sh
```

Expected result:

- AWS CLI is installed
- kubectl is installed
- eksctl is installed
- helm is installed
- AWS identity is displayed successfully

## Step 2: Create EKS cluster

```bash
./scripts/01-create-cluster.sh
```

Expected result:

- EKS cluster is created
- kubeconfig is updated
- `kubectl get nodes` works

## Step 3: Create Fargate profile

```bash
./scripts/02-create-fargate-profile.sh
```

Expected result:

- Namespace `game-2048` exists
- Fargate profile is associated with namespace `game-2048`

## Step 4: Install AWS Load Balancer Controller

```bash
./scripts/03-install-aws-load-balancer-controller.sh
```

Expected result:

```bash
kubectl get deployment -n kube-system aws-load-balancer-controller
```

The controller should show available replicas.

## Step 5: Deploy application

```bash
./scripts/04-deploy-application.sh
```

Expected result:

- Deployment is available
- Service is created
- Ingress is created
- ALB DNS name appears in Ingress ADDRESS field

## Step 6: Access application

```bash
kubectl get ingress -n game-2048
```

Copy the ALB DNS name from the `ADDRESS` column and open it in a browser.

## Step 7: Cleanup

```bash
./scripts/99-cleanup.sh
```

Always clean up after the lab to avoid AWS cost.
