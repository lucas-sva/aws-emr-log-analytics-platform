# 1. Rede
module "networking" {
  source = "../../modules/networking"

  project_name         = var.project_name
  environment          = var.environment
  aws_region           = var.aws_region
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = var.availability_zones
}

# 2. Storage
module "storage" {
  source = "../../modules/storage"

  project_name = var.project_name
  environment  = var.environment
  buckets      = var.buckets
}

# 3. Compute (EMR)
module "emr" {
  source = "../../modules/emr"

  project_name = var.project_name
  environment  = var.environment

  # Networking
  vpc_id     = module.networking.vpc_id
  subnet_ids = module.networking.private_subnets # O EMR roda no privado!

  # Storage admin
  s3_bucket_log_id = module.storage.bucket_names["administrative"]

  depends_on = [module.networking, module.storage]
}