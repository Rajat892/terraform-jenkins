locals {
  project_id       = "yantriks00"
  pool_id          = "jenkins-pool"
  provider_id      = "jenkins-oidc"
  project_number   = "496490171208"  # Change this
  region  = "us-central1"
  zone       = "us-central1-a"
}

provider "google" {
  project = local.project_id
  region  = local.region

  # Workload Identity Federation
  impersonate_service_account = "terraform-sa@${local.project_id}.iam.gserviceaccount.com"

#   # WIF Credential Configuration (generated in Jenkins pipeline)
#   credentials = file("${path.cwd}/wif-creds.json")
  # Read credentials from env (GOOGLE_APPLICATION_CREDENTIALS)
  disable_credentials_discovery = true
}

provider "google-beta" {
  project = local.project_id
  region  = local.region
  impersonate_service_account = "terraform-sa@${local.project_id}.iam.gserviceaccount.com"
  credentials = file("${path.cwd}/wif-creds.json")
  disable_credentials_discovery = true
}
