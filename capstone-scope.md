# Capstone Scope Document
## KijaniKiosk — Production-Grade CD Pipeline for Kubernetes

---

## Problem Statement

The KijaniKiosk payments service (kk-payments) currently has no
automated delivery pipeline connecting code changes to the
Kubernetes cluster. Deployments require a manual kubectl apply
directly to the kijanipayment namespace, with no environment
isolation, no health validation, and no approval gate before
changes reach the production configuration. A bad image pushed
by any engineer deploys immediately with no automated safety net.
This is unacceptable for a financial services platform where a
failed deployment directly affects payment processing.

---

## Track

Track A — Infrastructure-first

---

## What I Will Build

- **Staging namespace:** A kijani-project Kubernetes namespace
  provisioned via Terraform, isolated from the production
  kijanipayment namespace, with its own environment variables
  configured via Ansible.

- **Jenkins CD pipeline:** A Jenkins pipeline that triggers on
  every merge to main, builds the Docker image, pushes it to
  Nexus, and deploys automatically to kijani-staging.

- **Health validation stage:** A pipeline stage that runs
  kubectl rollout status and a curl health check against the
  staging endpoint after deployment, failing the pipeline if
  the service does not become healthy within 120 seconds.

- **Manual approval gate:** A Jenkins input step that pauses
  the pipeline after successful staging validation and displays
  the staging health check result, requiring explicit engineer
  approval before promoting to the kijanipayment namespace.

- **Automated rollback:** A post-failure step that runs
  kubectl rollout undo automatically if the staging health
  check fails, returning the cluster to the last known good
  state without manual intervention.

---

## What Is Out of Scope

- **Production monitoring and alerting:** Prometheus and
  Grafana dashboards are not included because the capstone
  focuses on the delivery pipeline, not the observability
  layer. This is the next logical extension after the pipeline
  is stable.

- **Multi-region deployment:** Only a single cluster is
  targeted. Multi-region introduces networking complexity that
  is outside the one-week capstone timeframe.

-  **Production rollback:** Already implemented in kijani-project
  via Kubernetes native rollout history. The capstone extends this pattern by adding automated
  rollback to the staging pipeline before changes ever reach
  production, catching bad images earlier in the delivery chain.


---

## Success Criteria

1. A push to main triggers the Jenkins pipeline automatically,
   builds a versioned Docker image, and deploys it to
   kijani-staging without any manual kubectl commands.

2. A deliberately introduced bad image tag causes the health
   validation stage to fail, triggers an automated rollback
   in kijani-staging, and blocks the approval gate from
   appearing — confirmed by kubectl rollout history showing
   the previous revision restored.

3. A clean deployment to kijani-staging shows a passing health
   check in the Jenkins console, the approval gate appears,
   and after approval the same image is promoted to
   kijanipayment — confirmed by kubectl get pods -n
   kijanipayment showing the new image tag running.

---

## Architecture Diagram
