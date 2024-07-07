resource "aws_security_group" "allow_ssh" {
  vpc_id = aws_vpc.main.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 0
    to_port   = 0
    self      = true
    protocol  = "-1"
  }
  tags = {
    Name = "sample_ec2_sg"
  }
}