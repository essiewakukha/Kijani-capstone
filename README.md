# KijaniKiosk Capstone Project


---

# Project Overview

KijaniKiosk is a production-approaching CI/CD pipeline project built to automate the deployment workflow for the `kk-payments` service running on Kubernetes.

The project demonstrates an Infrastructure-first DevOps workflow integrating:

* Terraform infrastructure provisioning
* Jenkins CI/CD automation
* Docker containerization
* Kubernetes deployment management
* rollout validation and rollback handling
* staging and production environment separation
* AI-assisted operational troubleshooting with governance documentation

The goal of the project was to eliminate manual Kubernetes deployments and replace them with a controlled, validated, and approval-gated deployment pipeline suitable for a financial-services-style environment.

---

# Problem Statement

The `kk-payments` service originally relied on manual `kubectl apply` deployments directly to the production namespace with:

* no staging environment
* no deployment validation
* no rollback handling
* no approval gate before production deployment
* no automated CI/CD workflow

This created operational risk because failed deployments could directly impact payment processing.

This capstone project addresses those risks by implementing a production-style Kubernetes deployment pipeline with staging validation and controlled production promotion.

---

# Architecture

## Workflow

GitHub → Jenkins → Docker Build → Kubernetes Staging → Rollout Validation → Smoke Test → Approval Gate → Production Deployment

---

## Architecture Diagram

![Architecture Diagram](docs/architecture.png)

The system uses Jenkins to automate Docker image builds and Kubernetes deployments. Terraform provisions the staging namespace while Kubernetes ConfigMaps and Secrets manage runtime configuration. Jenkins validates staging deployments before requiring manual approval for production promotion.

---

# Technologies Used

| Technology              | Purpose                               |
| ----------------------- | ------------------------------------- |
| Terraform               | Infrastructure provisioning           |
| Jenkins                 | CI/CD pipeline automation             |
| Docker                  | Application containerization          |
| Kubernetes              | Container orchestration               |
| Minikube                | Local Kubernetes cluster              |
| GitHub                  | Source control and SCM integration    |
| ConfigMaps & Secrets    | Runtime configuration                 |
| ChatGPT (AI Assistance) | Troubleshooting and workflow guidance |

---

# Repository Structure

```text
Capstone_Project/
├── README.md
├── Jenkinsfile
├── Dockerfile
├── terraform/
│   └── main.tf
├── docs/
│   ├── architecture.png
│   └── ai-governance-log.md
├── k8s/
│   ├── kk-payments-deployment.yaml
│   ├── kk-payments-configmap.yaml
│   └── kk-payments-secrets.yaml
└── monitoring/
```

---

# Prerequisites

Before running the project, install the following tools:

* Docker
* Minikube
* kubectl
* Terraform
* Jenkins
* Git

Recommended versions:

| Tool       | Version |
| ---------- | ------- |
| Docker     | 24+     |
| Kubernetes | 1.32+   |
| Terraform  | 1.5+    |
| Jenkins    | LTS     |
| Minikube   | 1.38+   |

---

# Setup Instructions

## 1. Clone Repository

```bash
git clone https://github.com/essiewakukha/Kijani-capstone.git

cd Kijani-capstone
```

---

## 2. Start Minikube

```bash
minikube start
```

---

## 3. Provision Infrastructure

```bash
cd terraform

terraform init

terraform apply
```

This creates the `kijani-staging` namespace.

---

## 4. Configure Kubernetes Resources

```bash
kubectl apply -f k8s/
```

---

## 5. Start Jenkins

Run Jenkins container:

```bash
docker run -d \
  --name jenkins \
  --network minikube \
  -p 8080:8080 \
  -p 50000:50000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ~/.kube:/var/jenkins_home/.kube \
  -v ~/.minikube:/root/.minikube \
  kijani-jenkins
```

---

# Jenkins Pipeline Workflow

The Jenkins pipeline performs the following stages:

1. Checkout source code from GitHub
2. Build Docker image
3. Validate container runtime
4. Deploy to staging namespace
5. Validate Kubernetes rollout
6. Run smoke test
7. Await manual production approval
8. Deploy to production namespace

---

# How to Trigger the Pipeline

1. Push code changes to GitHub
2. Open Jenkins
3. Run the pipeline job
4. Monitor the deployment stages
5. Approve production deployment when prompted

---

# How to Verify the System

## Verify Staging Deployment

```bash
kubectl get pods -n kijani-staging
```

---

## Verify Production Deployment

```bash
kubectl get pods -n kijani-project
```

---

## Verify Rollout Status

```bash
kubectl rollout status deployment/kk-payments -n kijani-staging
```

---

## Verify Rollback Capability

```bash
kubectl rollout history deployment/kk-payments -n kijani-staging
```

---

# Runtime Features

The Kubernetes deployment includes:

* readiness probes
* liveness probes
* ConfigMaps
* Secrets
* rollout validation
* rollback handling
* namespace separation

---

# Rollback Handling

If deployment validation fails, Jenkins automatically triggers:

```bash
kubectl rollout undo deployment/kk-payments -n kijani-staging
```

This restores the previous stable deployment revision automatically.

---

# AI Governance Documentation

AI tooling was used to assist with:

* Jenkins troubleshooting
* Kubernetes authentication debugging
* kubeconfig integration
* Docker networking fixes
* Jenkinsfile stabilization
* rollout validation troubleshooting

The governance log is documented in:

```text
docs/ai-governance-log.md
```

---

# Known Limitations

The following items are intentionally out of scope:

* Prometheus and Grafana monitoring
* Multi-region deployments
* TLS and DNS configuration
* Automated production rollback
* Cloud-managed Kubernetes clusters

The project focuses primarily on the CI/CD delivery workflow.

---

# Success Criteria

The project successfully demonstrates:

* automated staging deployment
* rollout validation
* smoke testing
* approval-gated production deployment
* rollback capability
* Terraform-based infrastructure provisioning
* end-to-end Kubernetes delivery workflow

---

# Release Information

Annotated release tag:

```text
v1.0.0
```

Created using:

```bash
git tag -a v1.0.0 -m "Capstone submission: Track A production-grade Kubernetes CD pipeline"
```

---

# Conclusion

The KijaniKiosk Track A capstone successfully implemented a production-style Kubernetes CI/CD workflow integrating:

* Infrastructure as Code
* Continuous Delivery
* Kubernetes runtime management
* deployment governance
* rollback handling
* AI-assisted operational troubleshooting

The final solution demonstrates a reproducible and integrated DevOps delivery pipeline suitable for production-approaching environments.
