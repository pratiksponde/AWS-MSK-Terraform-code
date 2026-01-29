data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Key Pair
resource "aws_key_pair" "msk_client_key" {
  key_name   = "msk-client-key"
  public_key = tls_private_key.msk_client_key.public_key_openssh
}

resource "tls_private_key" "msk_client_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "private_key" {
  content         = tls_private_key.msk_client_key.private_key_pem
  filename        = "${path.module}/msk-client-key.pem"
  file_permission = "0400"
}

# EC2 Client Security Group
resource "aws_security_group" "ec2_client_sg" {
    name = "ec2_client_sg"
    description = "Security Group For MSK Serverless Cluster"
    vpc_id = var.vpc_id
    tags =  {
        Name = "ec2_client_sg"
    }
}

# Ingress rule KAFKA
resource "aws_vpc_security_group_ingress_rule" "Kafka" {
    security_group_id = aws_security_group.ec2_client_sg.id

    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
    cidr_ipv4 = "0.0.0.0/0"
}

# Egress rule KAFKA
resource "aws_vpc_security_group_egress_rule" "all" {
    security_group_id = aws_security_group.ec2_client_sg.id

    ip_protocol = "-1"
    cidr_ipv4 = "0.0.0.0/0"
  
}

# EC2 Instance
resource "aws_instance" "msk_client" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.msk_client_key.key_name
  vpc_security_group_ids = [aws_security_group.ec2_client_sg.id]
  subnet_id              = var.subnet_ids[0]
  iam_instance_profile   = aws_iam_instance_profile.msk_client_profile.name

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum -y install java-11
    cd /home/ec2-user
    wget https://archive.apache.org/dist/kafka/3.6.0/kafka_2.13-3.6.0.tgz
    tar -xzf kafka_2.13-3.6.0.tgz
    cd kafka_2.13-3.6.0/libs
    wget https://github.com/aws/aws-msk-iam-auth/releases/download/v1.1.1/aws-msk-iam-auth-1.1.1-all.jar
    cd /home/ec2-user/kafka_2.13-3.6.0/bin/
    cat << 'EOL' > client.properties
security.protocol=SASL_SSL
sasl.mechanism=AWS_MSK_IAM
sasl.jaas.config=software.amazon.msk.auth.iam.IAMLoginModule required;
sasl.client.callback.handler.class=software.amazon.msk.auth.iam.IAMClientCallbackHandler
EOL
    chown -R ec2-user:ec2-user /home/ec2-user/kafka_2.13-3.6.0
  EOF

  tags = {
    Name = "MSK-Client-EC2"
  }
}
# IAM Role for EC2
resource "aws_iam_role" "MSK-EC2-Role" {
  name = "MSK-Client-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "msk_client_policy" {
  name = "MSK-Client-Policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kafka-cluster:Connect",
          "kafka-cluster:AlterCluster",
          "kafka-cluster:DescribeCluster"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "kafka-cluster:*Topic*",
          "kafka-cluster:WriteData",
          "kafka-cluster:ReadData"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "kafka-cluster:AlterGroup",
          "kafka-cluster:DescribeGroup"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "msk_client_policy_attachment" {
  role       = aws_iam_role.MSK-EC2-Role.name
  policy_arn = aws_iam_policy.msk_client_policy.arn
}

resource "aws_iam_instance_profile" "msk_client_profile" {
  name = "MSK-Client-Profile"
  role = aws_iam_role.MSK-EC2-Role.name
}

