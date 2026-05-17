


# KijaniKiosk Operational Runbook

## Track A Kubernetes CI/CD Pipeline

---

# Purpose

This runbook provides operational procedures for deploying, validating, troubleshooting, and recovering the `kk-payments` application running in the KijaniKiosk Kubernetes environment.

The system uses:

* Terraform for infrastructure provisioning
* Jenkins for CI/CD automation
* Docker for containerization
* Kubernetes for runtime orchestration
* Prometheus for monitoring configuration

---

# System Components

| Component  | Purpose                       |
| ---------- | ----------------------------- |
| GitHub     | Source control                |
| Jenkins    | CI/CD pipeline                |
| Docker     | Container image build         |
| Kubernetes | Application runtime           |
| Terraform  | Namespace provisioning        |
| Prometheus | Metrics scraping and alerting |

---

# Kubernetes Namespaces

| Namespace      | Purpose                |
| -------------- | ---------------------- |
| kijani-staging | Staging environment    |
| kijani-project | Production environment |

---

# Deployment Workflow

## Standard Deployment Process

1. Developer pushes changes to GitHub
2. Jenkins pipeline starts automatically
3. Docker image is built
4. Image validation test runs
5. Deployment applied to staging
6. Kubernetes rollout validation occurs
7. Smoke testing runs
8. Engineer approves production deployment
9. Production deployment executes

---

# Verify Cluster Health

## Check Namespaces

```bash id="ggzwny"
kubectl get namespaces
```

---

## Check Running Pods

### Staging

```bash id="c2a2k7"
kubectl get pods -n kijani-staging
```

### Production

```bash id="pt9y5m"
kubectl get pods -n kijani-project
```

Expected state:

```text id="ujj7gx"
STATUS = Running
READY = 1/1
```

---

# Verify Deployment Rollout

## Staging Rollout

```bash id="ck1j3r"
kubectl rollout status deployment/kk-payments -n kijani-staging
```

---

## Production Rollout

```bash id="v8xj1s"
kubectl rollout status deployment/kk-payments -n kijani-project
```

Expected output:

```text id="2p6j5k"
deployment "kk-payments" successfully rolled out
```

---

# Restart Application Deployment

## Restart Staging

```bash id="9wq9jr"
kubectl rollout restart deployment/kk-payments -n kijani-staging
```

---

## Restart Production

```bash id="p1tw4w"
kubectl rollout restart deployment/kk-payments -n kijani-project
```

---

# Rollback Procedure

If deployment validation fails or application health degrades:

## View Rollout History

```bash id="s0f0yv"
kubectl rollout history deployment/kk-payments -n kijani-staging
```

---

## Rollback Deployment

### Staging

```bash id="q1y1cd"
kubectl rollout undo deployment/kk-payments -n kijani-staging
```

### Production

```bash id="0fd6j6"
kubectl rollout undo deployment/kk-payments -n kijani-project
```

---

# Troubleshooting Guide

## 1. Pod CrashLoopBackOff

### Symptoms

```text id="u4ikn9"
STATUS = CrashLoopBackOff
```

### Investigation

```bash id="64sqk8"
kubectl describe pod <pod-name> -n kijani-staging
```

```bash id="ef7dvh"
kubectl logs <pod-name> -n kijani-staging
```

### Common Causes

* missing ConfigMap
* missing Secret
* invalid environment variables
* application startup failure

---

## 2. CreateContainerConfigError

### Investigation

```bash id="ztf91n"
kubectl describe pod <pod-name> -n kijani-staging
```

### Common Causes

* Secret not found
* ConfigMap not found
* namespace mismatch

### Resolution

Verify:

```bash id="d9bg5u"
kubectl get configmap -n kijani-staging

kubectl get secrets -n kijani-staging
```

---

## 3. Rollout Timeout

### Symptoms

```text id="v6m5cf"
deployment exceeded its progress deadline
```

### Investigation

```bash id="tnkzfx"
kubectl get pods -n kijani-staging

kubectl describe deployment kk-payments -n kijani-staging
```

### Resolution

* inspect failing pod
* validate probes
* verify image accessibility
* rollback deployment if required

---

## 4. Jenkins Pipeline Failure

### Investigation

1. Open Jenkins dashboard
2. Select failed build
3. Review Console Output

### Common Causes

* Docker daemon unavailable
* Kubernetes authentication failure
* rollout timeout
* invalid manifest configuration

---

# Monitoring

## Prometheus Configuration

Monitoring configuration files are located in:

```text id="mcvnwm"
monitoring/
```

Files:

* `prometheus.yml`
* `alerts.yml`

---

# Health Verification

## Application Health Endpoint

```bash id="df0q5p"
curl http://localhost:3000/health
```

Expected response:

```json id="r9sq6g"
{
  "status": "healthy"
}
```

---

# Infrastructure Recovery

## Recreate Terraform Resources

```bash id="z1mdgs"
cd terraform

terraform init

terraform apply
```

---

# Git Operations

## View Branches

```bash id="rvm9yy"
git branch
```

---

## View Commit History

```bash id="d3wxy7"
git log --oneline --graph --decorate
```

---

## View Release Tags

```bash id="3h6cz7"
git tag
```

Expected tag:

```text id="m6sbg8"
v1.0.0
```

---

# Security Practices

The following security controls are enforced:

* Secrets stored in Kubernetes Secrets
* No production credentials committed to Git
* Approval gate before production deployment
* Rollback capability enabled
* Environment separation between staging and production

---

# AI Governance Reference

AI tooling governance documentation is available in:

```text id="jlwm411"
docs/ai-governance-log.md
```

---

# Escalation Guidance

If deployment issues cannot be resolved:

1. Roll back to previous deployment revision
2. Capture logs and rollout history
3. Review Jenkins console output
4. Validate Kubernetes cluster health
5. Escalate to platform engineering support

---

# Conclusion

This runbook provides operational guidance for maintaining and troubleshooting the KijaniKiosk Kubernetes CI/CD environment. It supports deployment validation, recovery procedures, rollback handling, and runtime verification for the `kk-payments` service.
