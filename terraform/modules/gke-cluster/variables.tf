variable "project_id" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type    = string
  default = "asia-south2"
}

variable "subnet_self_link" {
  type = string
}

variable "net_self_link" {
    type = string
}

variable "cluster_name"{
  type = string
}

variable "zone" {

  type = string
}