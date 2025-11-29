variable "project_id" {
  type = string
}

variable "environment" {
  type = string
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "subnet_self_link" {
  type = string
}

variable "machine_type" {
  type    = string
  default = "e2-medium"
}

variable "boot_image" {
  type    = string
  default = "ubuntu-minimal-2504-plucky-amd64-v20250430"
}
