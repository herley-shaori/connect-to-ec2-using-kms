resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 2, 1)
  map_public_ip_on_launch = false
  tags = {
    Name = "sample_private_subnet"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 2, 2)
  map_public_ip_on_launch = true
  tags = {
    Name = "sample_public_subnet"
  }
}