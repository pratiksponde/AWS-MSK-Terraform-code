# MSK Security Group (Who can access MSK Cluster)
resource "aws_security_group" "MSK-Security-Group" {
    name = "${var.cluster_name}-sg"
    description = "Security Group For MSK Serverless Cluster"
    vpc_id = var.vpc_id
    tags = merge(var.tags, {
        Name = "${var.cluster_name}-sg"
    })
}

# Ingress rule KAFKA
resource "aws_vpc_security_group_ingress_rule" "Kafka" {
    security_group_id = aws_security_group.MSK-Security-Group.id

    from_port = 9098
    to_port = 9098
    ip_protocol = "tcp"
    cidr_ipv4 = var.allowed_cidr
  
}

# Egress rule KAFKA
resource "aws_vpc_security_group_egress_rule" "all" {
    security_group_id = aws_security_group.MSK-Security-Group.id

    ip_protocol = "-1"
    cidr_ipv4 = var.allowed_cidr
  
}

# AWS MSK Serverless CLuster
resource "aws_msk_serverless_cluster" "MSK-Cluster" {
    cluster_name = var.cluster_name
    vpc_config {
        subnet_ids = var.subnet_ids
        security_group_ids = [aws_security_group.MSK-Security-Group.id]
    }
    client_authentication {
        sasl {
            iam {
                enabled = true
      }
    }
  }

    tags = merge(var.tags, {
        Name = var.cluster_name
  })  
}


