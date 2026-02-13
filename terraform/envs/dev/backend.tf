terraform {
  backend "gcs" {
    bucket  = "tf-state-bucket-0011"
    prefix  = "dev"
  }
}
