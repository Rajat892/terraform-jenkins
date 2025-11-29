pipeline {
    agent { label 'vinod' }

    parameters {
        choice(name: 'ENV', choices: ['dev', 'qa', 'prod'], description: 'Deployment environment')
    }

    environment {
        ENV_DIR        = "terraform/envs/${params.ENV}"
        WORKSPACE_DIR  = "${WORKSPACE}"
        PROJECT_ID     = "yantriks00"
        PROJECT_NUMBER = "496490171208"
        POOL_ID        = "jenkins-pool"
        PROVIDER_ID    = "jenkins-oidc"
        SERVICE_ACCOUNT= "terraform-sa@yantriks00.iam.gserviceaccount.com"
        WIF_PROVIDER   = "projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${POOL_ID}/providers/${PROVIDER_ID}"
        WIF_CREDS      = "${WORKSPACE}/wif-creds.json"
    }

    stages {
        stage("Workspace cleanup") {
            steps { cleanWs() }
        }

        stage("Checkout") {
            steps {
                git url: 'https://github.com/Rajat892/terraform-jenkins.git', branch: 'main'
            }
        }

        stage('Auth to GCP via WIF') {
            steps {
                withCredentials([string(credentialsId: 'jenkins-oidc-token', variable: 'OIDC_TOKEN')]) {
                    sh """
                        set -e

                        # Save Jenkins OIDC token
                        echo "\$OIDC_TOKEN" > oidc-token.jwt

                        # Create WIF credential JSON
                        gcloud iam workload-identity-pools create-cred-config \
                            "$WIF_PROVIDER" \
                            --service-account="$SERVICE_ACCOUNT" \
                            --output-file="$WIF_CREDS" \
                            --credential-source-file=oidc-token.jwt

                        # Disable VM metadata auth, force WIF usage
                        export GOOGLE_APPLICATION_CREDENTIALS="$WIF_CREDS"
                        export CLOUDSDK_AUTH_DISABLE_GCE_METADATA=1

                        # Generate short-lived token for Terraform backend
                        export GOOGLE_OAUTH_ACCESS_TOKEN=\$(gcloud auth print-access-token)

                        echo "WIF authentication ready"
                        gcloud auth list
                    """
                }
            }
        }

        stage('Terraform Init') {
            steps {
                sh """
                    set -e
                    cd "$ENV_DIR"
                    terraform init
                """
            }
        }

        stage('Terraform Plan') {
            steps {
                sh """
                    set -e
                    cd "$ENV_DIR"
                    terraform plan
                """
            }
        }
    }
}
