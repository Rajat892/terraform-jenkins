terraform {
  backend "gcs" {
    bucket  = "tf-state-bucket-01"
    prefix  = "dev"
  }
}
