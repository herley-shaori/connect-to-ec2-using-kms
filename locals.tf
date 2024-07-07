locals {
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              sudo yum install -y wget git
              EOF
}