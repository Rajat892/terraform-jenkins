locals {
  project_id       = "yantrrik"
  pool_id          = "jenkins-pool"
  provider_id      = "jenkins-oidc"
  project_number   = "68726622663"  # Change this
  region  = "asia-south2"
  zone       = "asia-south2-b"
}

provider "google" {
  project = local.project_id
  region  = local.region

  # Workload Identity Federation
#   impersonate_service_account = "terraform-sa@${local.project_id}.iam.gserviceaccount.com"

   # WIF Credential Configuration (generated in Jenkins pipeline)
#   credentials = file("${path.cwd}/wif-creds.json")
#   Read credentials from env (GOOGLE_APPLICATION_CREDENTIALS)
#   disable_credentials_discovery = true
}

provider "google-beta" {
  project = local.project_id
  region  = local.region
#   impersonate_service_account = "terraform-sa@${local.project_id}.iam.gserviceaccount.com"
#   credentials = file("${path.cwd}/wif-creds.json")
}
