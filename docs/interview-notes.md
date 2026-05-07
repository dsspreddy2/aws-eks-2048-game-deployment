# Interview Notes

## How to explain this project

I deployed a real Kubernetes application on Amazon EKS. The application was the 2048 game running as Kubernetes pods. I used a namespace and Fargate profile so that workloads could run on serverless compute without managing worker nodes.

For external access, I used Kubernetes Ingress with the AWS Load Balancer Controller. When the Ingress resource was created, the controller automatically provisioned an AWS Application Load Balancer and routed traffic to the Kubernetes Service, which then forwarded traffic to the application pods.

## Key technical points

- EKS manages the Kubernetes control plane.
- Fargate removes the need to manage EC2 worker nodes for selected pods.
- Kubernetes Deployment manages pod replicas and rollout.
- Kubernetes Service provides stable internal access to pods.
- Kubernetes Ingress defines HTTP routing from outside the cluster.
- AWS Load Balancer Controller converts Ingress resources into AWS ALB resources.
- IAM OIDC provider and IAM service account are required so the controller can call AWS APIs securely.

## SRE angle

From an SRE perspective, I focused on validation and cleanup:

- Verified cluster access using `kubectl get nodes`
- Checked pod state using `kubectl get pods -o wide`
- Validated service and endpoint mapping
- Reviewed controller logs during Ingress troubleshooting
- Deleted Ingress before cluster cleanup to avoid orphaned load balancers

## Possible interview questions

### Why do we need AWS Load Balancer Controller?

Kubernetes Ingress is only a desired-state object. In AWS, we need a controller that watches that object and creates the actual AWS Application Load Balancer, listeners, target groups, and routing rules.

### Why use target type `ip` for Fargate?

With Fargate, pods do not run on customer-managed EC2 worker nodes. Targeting pod IPs allows the ALB to route traffic directly to the pod network endpoints.

### What is the purpose of the Fargate profile?

A Fargate profile tells EKS which pods should run on Fargate. It usually matches pods using namespace and optional labels.

### What would you improve for production?

- Use a custom domain and HTTPS certificate through ACM
- Use private subnets and controlled ingress rules
- Pin container image versions instead of using `latest`
- Add monitoring, logging, and alerts
- Use Terraform or GitOps for repeatable deployment
- Add resource requests, limits, readiness probes, and liveness probes
