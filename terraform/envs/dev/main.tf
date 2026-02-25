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

module "gke-cluster" {
  source = "../../modules/gke-cluster"
  project_id = local.project_id
  environment = var.environment
  cluster_name = local.cluster
  subnet_self_link = module.network.subnet_self_link
  net_self_link = module.network.network_self_link
  region = local.region
  zone = local.zone

}