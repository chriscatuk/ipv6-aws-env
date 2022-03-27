output "Bastion_Hostname" {
  #  sensitive = true
  value = "TBD"
}

output "minikube_Hostname" {
  #  sensitive = true
  value = "TBD"
}

output "vpc" {
  #  sensitive = true
  value = module.vpc
}
