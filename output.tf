output "minikube_hostname" {
  value = module.minikube.hostname
}

output "vpc" {
  #  sensitive = true
  value = module.vpc
}
