provider "aws" {
  region = "us-east-1"  # Replace with your desired AWS region
}

resource "aws_security_group" "web_server_sg" {
  name        = "web-server-sg"
  description = "Security group for web server"
  
  // Allow incoming HTTP traffic (port 80) from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  // Allow incoming SSH traffic (port 22) only from your IP address
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["your-ip-address/32"]  # Replace with your public IP address
  }
}

resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  
  // Associate the security group with the instance
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]
  
  // User data to install a basic web server
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
