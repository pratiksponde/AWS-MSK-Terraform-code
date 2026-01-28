output "vpc_id"  {
    value = aws_vpc.MSK-VPC.id
}

output "private_subnet_ids" {
    value = aws_subnet.Private-Subnet[*].id
}

output "public_subnet_ids" {
    value = aws_subnet.Public-Subnet[*].id
}