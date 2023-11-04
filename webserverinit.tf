provider "aws" {
  region = "us-east-2"
}

resource "aws_security_group" "web_server_sg" {
  name        = "web-server-sg"
  description = "security group for web server"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["your-ip-address/32"]  # Replace with your public IP address
  }
}

resource "aws_instance" "web_server" {
  ami           = "ami-089c26792dcb1fbd4"  # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]
  
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Hello, World!" > /var/www/html/index.html
              EOF
}

output "public_ip" {
  value = aws_instance.web_server.public_ip
}
