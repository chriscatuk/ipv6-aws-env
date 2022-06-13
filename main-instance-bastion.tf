module "bastion" {
  source = "./modules/gp-instance"

  count = var.deploy.bastion ? 1 : 0
  providers = {
    aws.dnsupdate = aws.dnsupdate
    aws           = aws
  }

  subnet_id      = module.vpc.public_subnets[0].id
  sg_ids         = [module.vpc.vpc.default_security_group_id, aws_security_group.bastion.id]
  hostname       = "${local.fullname}-bastion"
  route53_zoneID = var.dns.route53_zoneid
  instance_type  = "t3.micro"
  template_vars = {
    hostname = "${local.fullname}-bastion"
    keypubic = var.ssh.keypublic
    username = var.ssh.username
  }

  username    = var.ssh.username
  volume_size = 50

  keypublic = var.ssh.keypublic

  public_ipv4 = true
}

########################
#    SECURITY GROUP    #
########################
resource "aws_security_group" "bastion" {

  vpc_id      = module.vpc.vpc.id
  name        = "${local.fullname}_bastion"
  description = "${local.fullname} bastion"

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.allowlists.ipv4
    ipv6_cidr_blocks = var.allowlists.ipv6
    description      = "SSH from home"
  }
}
