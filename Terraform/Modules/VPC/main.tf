data "aws_availability_zones" "available" {
    state = "available"
}

# VPC 
resource "aws_vpc" "MSK-VPC" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = var.name
    }
}

# Internet Gateway
resource "aws_internet_gateway" "IG" {
    vpc_id = aws_vpc.MSK-VPC.id

    tags = {
        Name = "${var.name}-igw"
    }
}

# Public Subnets
resource "aws_subnet" "Public-Subnet" {
    count = var.az_count
    vpc_id = aws_vpc.MSK-VPC.id
    cidr_block = "10.0.${count.index + 101}.0/24"
    availability_zone = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.name}-public-${count.index + 1}"
    }
}

# Private Subnet
resource "aws_subnet" "Private-Subnet" {
    count             = var.az_count
    vpc_id            = aws_vpc.MSK-VPC.id
    cidr_block        = "10.0.${count.index + 1}.0/24"
    availability_zone = data.aws_availability_zones.available.names[count.index]

    tags = {
        Name = "${var.name}-private-${count.index + 1}"
    }  
}

# Elastic IP for NAT
resource "aws_eip" "ELastic-IP-for-Nat" {
    count = var.enable_nat_gateway ? 1 : 0
    domain = "vpc" 
}

# NAT Gateway 
resource "aws_nat_gateway" "Nat-Gateway" {
    count = var.enable_nat_gateway ? 1 : 0
    allocation_id = aws_eip.ELastic-IP-for-Nat[0].id
    subnet_id = aws_subnet.Public-Subnet[0].id
    depends_on = [ aws_internet_gateway.IG ]
    tags = {
      Name = "${var.name}-Nat-Gateway"
    }
}

# Public Route Table
resource "aws_route_table" "Public-RT" {
    vpc_id = aws_vpc.MSK-VPC.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.IG.id
    }
    tags = {
        Name = "${var.name}-Public-RT"
    }
}

# Public Route Table Association 
resource "aws_route_table_association" "public" {
    count = var.az_count
    subnet_id = aws_subnet.Public-Subnet[count.index].id
    route_table_id = aws_route_table.Public-RT.id

}

# Private Route Table
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.MSK-VPC.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.Nat-Gateway[0].id
    } 
    tags = {
        Name = "${var.name}-Private-RT"
    }
}

# Private Route Table Association
resource "aws_route_table_association" "private" {
    count = var.az_count
    subnet_id = aws_subnet.Private-Subnet[count.index].id
    route_table_id = aws_route_table.private.id
}
