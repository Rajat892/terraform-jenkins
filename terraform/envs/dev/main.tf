locals {
  project_id = "yantriks00"
  region     = "us-central1"
  zone       = "us-central1-a"
}

module "network" {
  source = "../../modules/network"
  project_id  = local.project_id
  environment = var.environment
  region      = local.region
}

module "compute" {
  source = "../../modules/compute"
  project_id = local.project_id
  environment = var.environment
  zone = local.zone
  subnet_self_link = module.network.subnet_self_link
}

# module "storage" {
#   source = "../../modules/storage"
#   project_id = local.project_id
#   environment = "dev"
# }
