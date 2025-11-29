module "network" {
  source = "../../modules/network"
  project_id = "yantriks00"
  environment = "dev"
}

module "compute" {
  source = "../../modules/compute"
  project_id = "yantriks00"
  environment = "dev"
  subnet_self_link = module.network.subnet_self_link
}

# module "storage" {
#   source = "../../modules/storage"
#   project_id = local.project_id
#   environment = "dev"
# }
