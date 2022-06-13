output "minikube" {
  value = module.minikube
}

output "bastion" {
  value = module.bastion
}

output "ipv6only_host" {
  value = module.ipv6only_host
}

# output "vpc" {
#   #  sensitive = true
#   value = module.vpc
# }
