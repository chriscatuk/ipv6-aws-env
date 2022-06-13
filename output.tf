output "minikube" {
  value = var.deploy.minikube ? module.minikube : null
}

output "bastion" {
  value = var.deploy.bastion ? module.bastion : null
}

output "ipv6only_host" {
  value = var.deploy.ipv6only_host ? module.ipv6only_host : null
}

output "ipv4only_host" {
  value = var.deploy.ipv4only_host ? module.ipv4only_host : null
}

# output "vpc" {
#   #  sensitive = true
#   value = module.vpc
# }
