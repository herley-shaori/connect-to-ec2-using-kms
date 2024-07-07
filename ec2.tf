# Get the latest Amazon Linux 2 AMI
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "private_instance" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  iam_instance_profile   = aws_iam_instance_profile.ssm_instance_profile.name
  user_data              = local.user_data
  tags = {
    Name = "sample_private_instance"
  }
}