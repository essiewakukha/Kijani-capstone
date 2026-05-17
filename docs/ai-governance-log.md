# AI Tooling Governance Documentation – KijaniKiosk Capstone

## 1. Operational Task

AI tooling was used to assist with troubleshooting and integrating the Jenkins CI/CD pipeline, Docker container runtime, and Kubernetes deployment workflow for the KijaniKiosk Track A capstone project.

The AI assistance focused on:

* Jenkins container configuration
* Docker socket permission troubleshooting
* Kubernetes kubeconfig authentication fixes
* Minikube networking integration
* Jenkinsfile stabilization
* Kubernetes deployment debugging
* rollout validation and rollback handling

---

## 2. AI Tool Used

OpenAI ChatGPT (GPT-5.5)

The tool was used interactively during development to:

* generate troubleshooting suggestions
* explain Kubernetes and Jenkins integration issues
* propose pipeline improvements
* recommend deployment workflow corrections

---

## 3. Input Provided to AI

The following information was provided during troubleshooting:

* Jenkins console logs
* kubectl rollout output
* Docker build errors
* Kubernetes deployment manifests
* kubeconfig configuration details
* Minikube networking output
* Jenkinsfile pipeline definitions

The AI was also provided with the approved capstone scope document and project architecture requirements.

---

## 4. AI Output Generated

The AI generated:

* corrected Jenkins pipeline stages
* kubeconfig troubleshooting procedures
* Docker runtime fixes
* Kubernetes deployment recommendations
* namespace portability improvements
* rollback handling logic
* CI/CD workflow improvements


The AI also explained the integration seams between:

* Jenkins and Docker
* Jenkins and Kubernetes
* Kubernetes and ConfigMaps/Secrets
* Terraform and Kubernetes namespaces

---

## 5. What the AI Got Wrong

Several AI suggestions initially required correction during implementation:

* Early kubeconfig path recommendations referenced incorrect container paths.
* Initial Jenkins deployment manifests assumed generic deployment filenames that did not match the actual repository structure.
* Some rollback recommendations required adjustment to match the Kubernetes namespaces used in the project.
* Initial pipeline testing logic was too complex for the current application structure and had to be simplified.

These issues were identified during manual validation and corrected before final deployment.

---

## 6. Human Review and Corrections

All AI-generated recommendations were manually reviewed before implementation.

Corrections performed manually included:

* updating kubeconfig certificate paths
* fixing namespace mismatches
* simplifying Jenkinsfile test stages
* adjusting Kubernetes manifest references
* validating rollout behavior directly with kubectl
* verifying deployment state using Kubernetes commands

The final implementation decisions were made manually after testing in the Minikube cluster.

---

## 7. Governance and Risk Controls

The following governance controls were applied:

* No AI-generated code was deployed directly without review.
* Kubernetes rollout validation gates were enforced.
* Production deployment required human approval.
* Git version control tracked all infrastructure and pipeline changes.
* Rollback procedures were tested before final submission.
* Secrets were stored in Kubernetes Secrets objects and not hardcoded into the pipeline.

The AI tool acted as an engineering assistant, not an autonomous deployment system.

---

## 8. Final Outcome

AI assistance accelerated troubleshooting and integration of the CI/CD workflow, especially during:

* Jenkins container networking issues
* Kubernetes authentication setup
* pipeline stabilization
* deployment automation

The final system successfully demonstrated:

* automated staging deployment
* rollout validation
* smoke testing
* approval-gated production deployment
* rollback capability
* integrated Kubernetes delivery workflow

All final deployment decisions and validations were performed manually by the esther wakukha.
