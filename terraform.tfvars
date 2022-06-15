# ==================================================
# non Sentivite data that can be stored in Github
# ==================================================

# ==================================================
#   Sensitive data are in terraform.safe.tfvars
#      see terraform.safe.tfvars.example
# ==================================================

# All resources will have this Name tag (VPC, SG, IGW, Subnets...)
# a personalised name_suffix can be added (in example in terraform.save.tfvars.example)
name_prefix = "training-ipv6"

regions = {
  principal = "eu-west-1"
  secondary = "us-east-1"
}

deploy = {
  minikube      = true
  minikube6     = false # minikube currently doesn’t support IPv6 https://minikube.sigs.k8s.io/docs/faq/
  bastion       = true
  ipv4only_host = false
  ipv6only_host = false
}

#Subnet of the VPC (will be divided in 3 Availability Zones)
cidrs = {
  principal = "10.35.64.0/22"
  secondary = "10.35.128.0/22"
}

number_of_az = 2
tags = {
  deployment  = "terraform"
  environment = "dev"
  repository  = "https://github.com/chriscatuk/ipv6-aws-env"
  purpose     = "Training. No raison to keep it deployed outside of training time. Terraform destroy should be used"
  always_on   = "false" #Possible values are true/false.
}
