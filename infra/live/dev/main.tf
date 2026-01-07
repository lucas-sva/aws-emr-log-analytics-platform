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
  subnet_ids = module.networking.private_subnets

  # Storage admin
  s3_bucket_log_id = module.storage.bucket_names["administrative"]

  depends_on = [module.networking, module.storage]
}

# 4. Orquestração serverless com o lambda
module "orchestration" {
  source = "../../modules/lambda"

  project_name = var.project_name
  environment  = var.environment
  tags         = var.tags

  emr_cluster_id        = module.emr.cluster_id
  raw_bucket_id         = module.storage.buckets_ids["raw"]
  raw_bucket_arn        = module.storage.bucket_arns["raw"]
  processed_bucket_name = module.storage.bucket_names["processed"]
}