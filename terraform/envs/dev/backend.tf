terraform {
  backend "gcs" {
    bucket  = "dev-tf-state-bucket-01"
    prefix  = "dev"
  }
}
