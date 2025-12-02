pipeline {
    agent { label 'vinod' }

    parameters {
        choice(name: 'ENV',  choices: ['dev', 'qa', 'prod'],  description: 'Target environment')
        choice(name: 'MODE', choices: ['create', 'delete'],   description: 'Action')
    }

    environment {
        PROJECT_ID      = "yantriks00"
        PROJECT_NUMBER  = "496490171208"
        POOL_ID         = "jenkins-pool"
        PROVIDER_ID     = "jenkins-oidc"
        SERVICE_ACCOUNT = "terraform-sa@yantriks00.iam.gserviceaccount.com"
        WIF_PROVIDER    = "projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${POOL_ID}/providers/${PROVIDER_ID}"
    }

    stages {

        stage('Workspace cleanup') {
            steps { cleanWs() }
        }

        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/Rajat892/terraform-jenkins.git', branch: 'main'
            }
        }

        stage('Set Environment Variables') {
            steps {
                script {
                    // Directory for the environment
                    env.ENV_DIR = "terraform/envs/${params.ENV}"

                    // Path for the WIF credentials JSON
                    env.WIF_CREDS = "${env.ENV_DIR}/wif-creds.json"
                }
            }
        }

        stage('Auth to GCP via WIF') {
            steps {
                withCredentials([string(credentialsId: 'jenkins-oidc-token', variable: 'OIDC_TOKEN')]) {
                    sh """
                        set -e

                        echo "\$OIDC_TOKEN" > oidc-token.jwt

                        # 1. Create WIF credential config JSON
                        gcloud iam workload-identity-pools create-cred-config \
                            "$WIF_PROVIDER" \
                            --service-account="$SERVICE_ACCOUNT" \
                            --output-file="wif-creds.json" \
                            --credential-source-file=oidc-token.jwt

                        # 2. Patch service account impersonation into the JSON
                        jq '.service_account_impersonation_url = "https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/${SERVICE_ACCOUNT}:generateAccessToken"' \
                            wif-creds.json > wif-creds-imp.json

                        mv wif-creds-imp.json wif-creds.json

                        # 3. Export the WIF credentials (disable metadata ADC)
                        export GOOGLE_APPLICATION_CREDENTIALS="wif-creds.json"
                        export CLOUDSDK_AUTH_DISABLE_GCE_METADATA=1

                        echo "Testing GCP authentication..."
                        gcloud auth list --filter=status:ACTIVE
                        gcloud auth print-access-token
                    """
                }
            }
        }



        stage('Terraform Init') {
            steps {
                sh """
                    set -e
                    set +x
                    cd "${ENV_DIR}"

                    # Ensure Terraform GCS backend uses WIF token
                    export GOOGLE_OAUTH_ACCESS_TOKEN=\$(gcloud auth print-access-token)

                    terraform init
                """
            }
        }

        stage('Terraform Plan') {
            when { expression { params.MODE == 'create' } }
            steps {
                sh """
                    set -e
                    set +x
                    cd "${ENV_DIR}"

                    # Ensure Terraform GCS backend uses WIF token
                    export GOOGLE_OAUTH_ACCESS_TOKEN=\$(gcloud auth print-access-token)

                    terraform plan
                """
            }
        }

        stage('Terraform Apply') {
            when {
                expression { params.MODE == 'create' && params.ENV != 'prod' } // Only auto-apply non-prod
            }
            steps {
                sh """
                    set -e
                    set +x # it will not expose secrets on the console
                    cd "${ENV_DIR}"

                    export GOOGLE_OAUTH_ACCESS_TOKEN=\$(gcloud auth print-access-token)
                    terraform apply -auto-approve
                """
            }
        }
        stage('Terraform Destroy') {
            when {
                expression { params.MODE == 'delete' && params.ENV != 'prod' } // Only auto-apply non-prod
            }
            steps {
                sh """
                    set -e
                    set +x
                    cd "${ENV_DIR}"

                    export GOOGLE_OAUTH_ACCESS_TOKEN=\$(gcloud auth print-access-token)
                    terraform destroy -auto-approve
                """
            }
        }
    }
}
