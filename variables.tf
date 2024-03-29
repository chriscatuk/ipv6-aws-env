# Defines the Vars for the whole project
# You should defines your own values in terraform.tfvars (example in terraform.tfvars.example)
# Sensitive values in terraform.safe.tfvars (example in terraform.safe.tfvars.example)

variable "name_prefix" {
  description = "All resources will have a name starting with this prefix (VPC, SG, IGW, Subnets...)"
  type        = string
  default     = "training-ipv6"
}

variable "name_suffix" {
  description = "(optional) All resources will have a name ending with this suffix (VPC, SG, IGW, Subnets...)"
  type        = string
  default     = ""
}

variable "regions" {
  description = "Regions where to deploy resources"
  type = object({
    principal = string
    secondary = string
  })
  default = {
    principal = "eu-west-1"
    secondary = "us-east-1"
  }
}

#Subnet of the VPC (will be divided in 3 Availability Zones)
variable "cidrs" {
  type = map(string)
  default = {
    principal = "10.35.64.0/22"
    secondary = "10.35.128.0/22"
  }
}

#Subnet of the VPC (will be divided in 3 Availability Zones)
variable "number_of_az" {
  description = "Number of availability zones to use"
  type        = number
}

variable "deploy" {
  description = "Do we deploy those resources or not?"
  type = object({
    minikube      = bool
    minikube6     = bool
    bastion       = bool
    ipv6only_host = bool
    ipv4only_host = bool
  })
  default = {
    minikube      = false
    minikube6     = false
    bastion       = true
    ipv6only_host = false
    ipv4only_host = false
  }
}

variable "tags" {
  description = "List of tags"
  type        = map(string)
  default = {
    deployment  = "terraform"
    environment = "training"
    repository  = "https://github.com/chriscatuk/ipv6-aws-env"
  }
}


variable "dns" {
  description = "(optional) DNS Route 53 settings, can be from another account. Default; no DNS record will be created"
  type = object({
    route53_domain    = string # example "aws.domain.net"
    route53_zoneid    = string # "ZZZZZZZZZZZZZ"
    dnsupdate_rolearn = string # "arn:aws:iam::111111111111:role/service-role/external-terraform-user-role"
    dnsupdate_region  = string # "eu-west-2"

  })
  default = null
}

variable "ssh" {
  description = "Each EC2 instance will be created with this admin user and their SSH public key"
  type = object({
    username   = string # example "john"
    keypublic  = string # "ssh-ed25519 AAAAAAA"
    allowlists = bool   # if false, will allow SSH from all IPs
  })
}

variable "allowlists" {
  description = "(Optional) Where to allow access from. Default: 0.0.0.0/0 and ::/0"
  type = object({
    ipv4 = list(string)
    ipv6 = list(string)
  })
  default = {
    ipv4 = ["0.0.0.0/0"]
    ipv6 = ["::/0"]
  }
}
