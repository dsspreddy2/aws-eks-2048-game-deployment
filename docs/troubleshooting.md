# Troubleshooting Guide

## 1. OIDC provider association fails

### Symptom

```text
No cluster found for name: <cluster-name>
```

### Checks

```bash
aws eks list-clusters --region eu-central-1
aws eks describe-cluster --name siva-eks-2048 --region eu-central-1
```

### Common cause

Wrong AWS region or cluster name.

### Fix

Use the same region and cluster name in every command.

---

## 2. Pods are pending

### Checks

```bash
kubectl get pods -n game-2048 -o wide
kubectl describe pod -n game-2048 <pod-name>
eksctl get fargateprofile --cluster siva-eks-2048 --region eu-central-1
```

### Common causes

- Namespace does not match Fargate profile selector
- Fargate profile creation is still in progress
- Insufficient IAM permissions

---

## 3. Ingress does not get ADDRESS

### Checks

```bash
kubectl get ingress -n game-2048
kubectl describe ingress ingress-2048 -n game-2048
kubectl logs -n kube-system deployment/aws-load-balancer-controller
```

### Common causes

- AWS Load Balancer Controller not running
- IAM policy or service account missing
- VPC subnet tags are missing or incorrect
- Ingress class is wrong

---

## 4. ALB created but browser cannot access the application

### Checks

```bash
kubectl get svc -n game-2048
kubectl get endpoints -n game-2048
kubectl describe svc service-2048 -n game-2048
```

### Common causes

- Service selector does not match pod labels
- Pod is not ready
- ALB target group health check is failing

---

## 5. Cleanup leaves ALB or target groups behind

### Checks

```bash
kubectl get ingress -A
aws elbv2 describe-load-balancers --region eu-central-1
```

### Fix

Delete Kubernetes Ingress first and wait before deleting the cluster.
