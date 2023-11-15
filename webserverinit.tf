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
  

}

resource "aws_instance" "web_server" {
  ami           = "ami-06d4b7182ac3480fa"  # Amazon Linux 2023 AMI
  instance_type = "t2.micro"
  
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]
  
  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Hello, World!" > /var/www/html/index.html
              mkdir /tmp/ssm
              cd /tmp/ssm
              curl -O https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/amazon-ssm-agent.rpm
              dnf install -y amazon-ssm-agent.rpm
              systemctl enable amazon-ssm-agent
              rm amazon-ssm-agent.rpm
              EOF
}

output "public_ip" {
  value = aws_instance.web_server.public_ip
}
