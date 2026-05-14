// ============================================================
// KijaniKiosk – Track A Capstone
// Jenkinsfile: Checkout → Build → Test → Deploy Staging
//              → Approval Gate → Deploy Production
// ============================================================

pipeline {
    agent any

    environment {
        IMAGE_NAME        = "kk-payments"
        IMAGE_TAG         = "${BUILD_NUMBER}"
        STAGING_NAMESPACE = "kijani-staging"
        PROD_NAMESPACE    = "kijani-project"
        K8S_DIR           = "k8s"
        KUBECONFIG        = "/var/jenkins_home/.kube/config"
    }

    stages {

        // ── 1. Checkout ─────────────────────────────────────
        stage('Checkout') {
            steps {
                echo "Checking out source code..."
                checkout scm
            }
        }

        // ── 2. Build ─────────────────────────────────────────
        stage('Build') {
            steps {
                echo "Building Docker image ${IMAGE_NAME}:${IMAGE_TAG}..."

                sh """
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                    docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
                """
            }
        }

        // ── 3. Test ──────────────────────────────────────────
        stage('Test') {
            steps {
                echo "Running container validation..."

                sh """
                    docker run --rm ${IMAGE_NAME}:${IMAGE_TAG} node --version
                """
            }
        }

        // ── 4. Deploy to Staging ─────────────────────────────
        stage('Deploy to Staging') {
            steps {
                echo "Deploying to namespace: ${STAGING_NAMESPACE}..."

                sh """
                    kubectl --kubeconfig=${KUBECONFIG} apply \
                        -f ${K8S_DIR}/kk-payments-config.yaml \
                        -f ${K8S_DIR}/kk-payments-secrets.yaml \
                        -f ${K8S_DIR}/kk-payments-deployment.yaml \
                        -n ${STAGING_NAMESPACE}

                    kubectl --kubeconfig=${KUBECONFIG} rollout status \
                        deployment/kk-payments \
                        -n ${STAGING_NAMESPACE} \
                        --timeout=120s
                """
            }
        }

        // ── 5. Smoke Test Staging ────────────────────────────
        stage('Smoke Test Staging') {
            steps {
                echo "Running smoke test against staging..."

                sh """
                    kubectl --kubeconfig=${KUBECONFIG} get pods \
                        -n ${STAGING_NAMESPACE}

                    echo "Smoke test passed"
                """
            }
        }

        // ── 6. Approval Gate ─────────────────────────────────
        stage('Approve Production Deploy') {
            steps {
                echo "Staging deployment healthy. Awaiting approval..."

                timeout(time: 30, unit: 'MINUTES') {
                    input message: 'Deploy to production?',
                          ok: 'Deploy'
                }
            }
        }

        // ── 7. Deploy to Production ──────────────────────────
        stage('Deploy to Production') {
            steps {
                echo "Deploying to namespace: ${PROD_NAMESPACE}..."

                sh """
                    kubectl --kubeconfig=${KUBECONFIG} apply \
                        -f ${K8S_DIR}/kk-payments-config.yaml \
                        -f ${K8S_DIR}/kk-payments-secrets.yaml \
                        -f ${K8S_DIR}/kk-payments-deployment.yaml \
                        -n ${PROD_NAMESPACE}

                    kubectl --kubeconfig=${KUBECONFIG} rollout status \
                        deployment/kk-payments \
                        -n ${PROD_NAMESPACE} \
                        --timeout=120s
                """
            }
        }
    }

    // ── Post Actions ─────────────────────────────────────────
    post {

        success {
            echo "Pipeline SUCCESS – build ${IMAGE_TAG} deployed successfully."
        }

        failure {
            echo "Pipeline FAILED – rolling back staging deployment..."

            sh """
                kubectl --kubeconfig=${KUBECONFIG} rollout undo \
                    deployment/kk-payments \
                    -n ${STAGING_NAMESPACE} || true
            """
        }

        always {
            echo "Cleaning up local Docker image..."

            sh """
                docker rmi ${IMAGE_NAME}:${IMAGE_TAG} || true
            """
        }
    }
}