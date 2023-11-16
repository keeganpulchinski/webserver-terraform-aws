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
  // Add IAM instance profile for SSM
  iam_instance_profile = aws_iam_instance_profile.web_server_profile.name
}

resource "aws_iam_instance_profile" "web_server_profile" {
  name = "web-server-ssm-profile"

  // Attach IAM role
  roles = [aws_iam_role.web_server_role.name]
}

resource "aws_iam_role" "web_server_role" {
  name = "web-server-ssm-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  // Attach IAM policies
  policies = [
    {
      name        = "ssm-policy",
      description = "SSM policy",
      policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:DescribeAssociation",
        "ssm:GetDeployablePatchSnapshotForInstance",
        "ssm:GetDocument",
        "ssm:DescribeDocument",
        "ssm:GetManifest",
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:ListAssociations",
        "ssm:ListInstanceAssociations",
        "ssm:PutInventory",
        "ssm:PutComplianceItems",
        "ssm:PutConfigurePackageResult",
        "ssm:UpdateAssociationStatus",
        "ssm:UpdateInstanceAssociationStatus",
        "ssm:UpdateInstanceInformation"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances",
        "ec2:RunInstances",
        "ec2:StartInstances",
        "ec2:StopInstances"
      ],
      "Resource": "*"
    }
  ]
}
EOF
    },
  ]
}

output "public_ip" {
  value = aws_instance.web_server.public_ip
}
