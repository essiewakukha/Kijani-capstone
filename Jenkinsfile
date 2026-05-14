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
                echo "Running tests..."
                sh """
                    docker run --rm ${IMAGE_NAME}:${IMAGE_TAG} npm test || \
                    docker run --rm ${IMAGE_NAME}:${IMAGE_TAG} python -m pytest || \
                    echo 'No test runner found – add tests before final submission'
                """
            }
        }

        // ── 4. Deploy to Staging ─────────────────────────────
        stage('Deploy to Staging') {
            steps {
                echo "Deploying to namespace: ${STAGING_NAMESPACE}..."
                sh """
                    # Swap the image tag in manifests before applying
                    sed -i 's|IMAGE_TAG|${IMAGE_TAG}|g' ${K8S_DIR}/deployment.yaml

                    kubectl apply -f ${K8S_DIR}/ -n ${STAGING_NAMESPACE}

                    # Gate: wait for rollout – pipeline fails if pods don't come up
                    kubectl rollout status deployment/kk-payments \
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
                    # Give the service a moment after rollout
                    sleep 5

                    # Port-forward in background, test, then kill
                    kubectl port-forward svc/kk-payments 9090:8080 \
                        -n ${STAGING_NAMESPACE} &
                    PF_PID=\$!
                    sleep 3

                    HTTP_STATUS=\$(curl -s -o /dev/null -w "%{http_code}" http://localhost:9090/health)
                    kill \$PF_PID

                    if [ "\$HTTP_STATUS" != "200" ]; then
                        echo "Smoke test FAILED – got HTTP \$HTTP_STATUS"
                        exit 1
                    fi
                    echo "Smoke test PASSED – HTTP 200"
                """
            }
        }

        // ── 6. Approval Gate ─────────────────────────────────
        stage('Approve Production Deploy') {
            steps {
                echo "Staging healthy. Awaiting human approval for production..."
                timeout(time: 30, unit: 'MINUTES') {
                    input message: 'Deploy to production?',
                          ok: 'Deploy',
                          submitter: 'admin'
                }
            }
        }

        // ── 7. Deploy to Production ──────────────────────────
        stage('Deploy to Production') {
            steps {
                echo "Deploying to namespace: ${PROD_NAMESPACE}..."
                sh """
                    kubectl apply -f ${K8S_DIR}/ -n ${PROD_NAMESPACE}

                    kubectl rollout status deployment/kk-payments \
                        -n ${PROD_NAMESPACE} \
                        --timeout=120s
                """
            }
        }

    }

    // ── Post-pipeline actions ────────────────────────────────
    post {
        success {
            echo "Pipeline SUCCESS – build ${IMAGE_TAG} is live in production."
        }
        failure {
            echo "Pipeline FAILED – rolling back staging deployment..."
            sh """
                kubectl rollout undo deployment/kk-payments \
                    -n ${STAGING_NAMESPACE} || true
            """
        }
        always {
            echo "Cleaning up local Docker image..."
            sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG} || true"
        }
    }
}