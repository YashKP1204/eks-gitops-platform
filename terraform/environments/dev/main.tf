
module "vpc" {
  source = "../../modules/vpc"

  aws_region       = var.aws_region
  project_name     = var.project_name
  environment      = var.environment
  vpc_cidr         = var.vpc_cidr
  public_cidr      = var.public_cidr
  private_cidr     = var.private_cidr
}