# Defines the Vars for the whole project
# You should defines your own values in terraform.tfvars (example in terraform.tfvars.example)

variable "subnet_id" {
  type = string
}

variable "sg_ids" {
  type    = list(any)
  default = []
}

#This hostname will be setup in Linux and added to Route 53 DNS Names
#Should be FQDN, ex: vpn-test.domain.com
variable "hostname" {
  type = string
}

variable "route53_zoneID" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "template_path" {
  type    = string
  default = null
}

variable "template_vars" {
  type    = map(string)
  default = {}
}

# Enable IPv6 support, in Dual Stack mode
variable "ipv6" {
  type    = bool
  default = true
}

# User with SSH and Sudo access.
variable "username" {
  type = string
}

#SSH Key Pair
variable "keypublic" { # keypublic line will be added to ~/.ssh/authorized_keys
  type = string
}

variable "public_ipv4" {
  type        = bool
  default     = true
  description = "required because we don't use NAT in this VPC"
}

variable "volume_size" {
  type    = string
  default = 10
}
