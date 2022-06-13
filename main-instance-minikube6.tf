module "minikube6" {
  source = "./modules/gp-instance"

  count = var.deploy.minikube6 ? 1 : 0
  providers = {
    aws.dnsupdate = aws.dnsupdate
    aws           = aws
  }

  subnet_id      = module.vpc.private_subnets_ipv6only[0].id
  sg_ids         = [module.vpc.vpc.default_security_group_id, aws_security_group.minikube6.id]
  hostname       = "${local.fullname}-minikube6"
  route53_zoneID = var.dns.route53_zoneid
  instance_type  = "t3.medium"
  template_path  = "${path.module}/templates/minikube-user_data.tpl"
  template_vars = {
    hostname = "${local.fullname}-minikube6"
    keypubic = var.ssh.keypublic
    username = var.ssh.username
  }

  username    = var.ssh.username
  volume_size = 50

  keypublic = var.ssh.keypublic

  public_ipv4 = false
  ipv6        = true
}


########################
#    SECURITY GROUP    #
########################
resource "aws_security_group" "minikube6" {
  vpc_id      = module.vpc.vpc.id
  name        = "${local.fullname}_minikube6"
  description = "${local.fullname} minikube6"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    # cidr_blocks      = var.allowlists.ipv4
    # ipv6_cidr_blocks = var.allowlists.ipv6
    security_groups = [aws_security_group.bastion.id]
    description     = "SSH from bastion"
  }
}
