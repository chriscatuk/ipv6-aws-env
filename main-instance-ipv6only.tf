module "ipv6only_host" {
  source = "./modules/gp-instance"

  enabled = var.deploy.ipv6only_host

  subnet_id         = module.vpc.private_subnets_ipv6only[0].id
  sg_ids            = [module.vpc.vpc.default_security_group_id, aws_security_group.ipv6only_host.id]
  hostname          = "${local.fullname}-ipv6only"
  route53_zoneID    = var.dns.route53_zoneid
  dnsupdate_rolearn = var.dns.dnsupdate_rolearn
  dnsupdate_region  = var.dns.dnsupdate_region
  instance_type     = "t3.micro"
  template_path     = "${path.module}/templates/bastion-user_data.tpl"
  template_vars = {
    hostname = module.ipv6only.hostname
    keypubic = var.ssh.keypublic
    username = var.ssh.username
  }

  username    = var.ssh.username
  volume_size = 50

  keypublic = var.ssh.keypublic
}


########################
#    SECURITY GROUP    #
########################
resource "aws_security_group" "ipv6only_host" {
  vpc_id      = module.vpc.vpc.id
  name        = "${local.fullname}_ipv6only"
  description = "${local.fullname} ipv6only"

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
