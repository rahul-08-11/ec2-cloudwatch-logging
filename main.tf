terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# ----------------------
# AWS Provider
# ----------------------
provider "aws" {
  region = "us-east-1"
  access_key = "XXXXXXXXXXXXXXXX"
  secret_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

}


# ----------------------
# IAM role for EC2
# ----------------------
resource "aws_iam_role" "ec2_role" {
  name = "ec2-cloudwatch-logging-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action   = "sts:AssumeRole"
    }]
  })
}

# ----------------------
# IAM Role Policy for CloudWatch Logs
# ----------------------
resource "aws_iam_role_policy" "cw_policy" {
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = "*"
    }]
  })
}

# ----------------------
# IAM Instance Profile
# ----------------------
resource "aws_iam_instance_profile" "ec2_profile" {
  role = aws_iam_role.ec2_role.name
}


# ----------------------
# Security Group
# ----------------------
resource "aws_security_group" "sg" {
  name = "ec2-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ## For testing python App (Not safe in production)
  ingress {
    from_port = 8000
    to_port   = 8000
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ----------------------
# EC2 Instance
# ----------------------
resource "aws_instance" "app" {
  ami           = "ami-0f918f7e67a3323f0"
  instance_type = "t3.micro"

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  security_groups      = [aws_security_group.sg.name]

  user_data = <<-EOF
              #!/bin/bash
              set -e
              apt update -y

              # Install necessary packages
              apt install python3-pip -y
              apt install python3.12-venv -y
              # Clone private repo
              git clone -b app https://github.com/rahul-08-11/ec2-cloudwatch-logging.git app
              cd app
              tmux new-session -d -s app "bash setup.sh"

              cd ~
              # installing cloud watch agent
              wget https://s3.amazonaws.com/amazoncloudwatch-agent/debian/amd64/latest/amazon-cloudwatch-agent.deb
              dpkg -i -E ./amazon-cloudwatch-agent.deb

              # Create CloudWatch Agent configuration file
              tee /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json > /dev/null <<'CONFIG'
              {
                "logs": {
                  "logs_collected": {
                    "files": {
                      "collect_list": [
                        {
                          "file_path": "/app/app.log",
                          "log_group_name": "/ec2/pythonapp",
                          "log_stream_name": "{instance_id}-app",
                          "timestamp_format": "%Y-%m-%d %H:%M:%S"
                        },
                        {
                          "file_path": "/app/setup.log",
                          "log_group_name": "/ec2/pythonapp",
                          "log_stream_name": "{instance_id}-setup",
                          "timestamp_format": "%Y-%m-%d %H:%M:%S"
                        }
                      ]
                    }
                  }
                }
              }
              CONFIG



              # Start the CloudWatch Agent
              /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
                  -a fetch-config \
                  -m ec2 \
                  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
                  -s
            
              EOF

  tags = {
    Name = "ec2-cloudwatch-logging"
  }
}
