# Defines the Vars for the whole project
# You should defines your own values in terraform.tfvars (example in terraform.tfvars.example)
# Sensitive values in terraform.safe.tfvars (example in terraform.safe.tfvars.example)

variable "vpc_name" {
  description = "All resources will have a name starting with this name (VPC, SG, IGW, Subnets...)"
  type        = string
}

#Subnet of the VPC (will be divided in 3 Availability Zones)
variable "cidr" {
  description = "IPv4 CIDR of the VPC"
  type        = string
}

variable "number_of_az" {
  description = "Number of availability zones to use"
  type        = number
  default     = 2
}

variable "ipv6" {
  description = "either to create with IPv6 or not"
  type        = bool
  default     = true
}
