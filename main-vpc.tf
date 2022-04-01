module "vpc" {
  source       = "./modules/vpc"
  vpc_name     = local.fullname
  cidr         = var.cidrs.principal
  number_of_az = var.number_of_az
}
