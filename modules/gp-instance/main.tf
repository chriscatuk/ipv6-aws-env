resource "aws_instance" "instance" {
  count         = var.enabled ? 1 : 0
  ami           = data.aws_ami.ami_amzn2.id
  instance_type = var.instance_type
  # # Removed. It was limited to RSA Keys.
  # # Replaced by Key directly in user_data
  # key_name                    = aws_key_pair.key.key_name
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.public_ip
  ipv6_address_count          = var.ipv6 ? 1 : 0
  vpc_security_group_ids      = var.sg_ids
  tags = {
    Name = var.hostname
  }

  lifecycle {
    create_before_destroy = true
  }
  credit_specification {
    cpu_credits = "standard"
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = var.volume_size
  }

  user_data = data.template_file.user_data.rendered
}

data "template_file" "user_data" {
  template = file(local.template_path)
  vars     = local.template_vars
}

########################
#          AMI         #
########################

# Latest AMI for Amazon Linux 2 in this region
# 28/04/2022: amzn2-ami-hvm-2.0.20220426.0-x86_64-gp2	

data "aws_ami" "ami_amzn2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

########################
#      ELASTIC IP      #
########################
resource "aws_eip" "ip" {
  count    = var.enabled && var.public_ip ? 1 : 0
  instance = aws_instance.instance[0].id
}

# Define the Key Pair you will add in AWS
# It must not exist before running the script

########################
#       Key Pair       #
########################
# # Removed. It was limited to RSA Keys.
# # Replaced by Key directly in user_data
# resource "aws_key_pair" "key" {
#   key_name   = var.keyname
#   public_key = var.keypublic
# }
