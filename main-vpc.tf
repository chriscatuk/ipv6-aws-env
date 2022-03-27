module "vpc" {
  source       = "./modules/vpc"
  vpc_name     = "${var.name_prefix}${var.name_suffix}"
  cidr         = var.cidrs.principal
  number_of_az = var.number_of_az
}
