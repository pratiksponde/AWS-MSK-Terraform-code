variable "cluster_name" {
  description = "Name of MSK Serverless Cluster"
}

variable "vpc_id" {
  description = "VPC ID"   
}

variable "subnet_ids" {
  type = list(string)  
  description = "Private Subnet IDs"
}

variable "allowed_cidr" {
  description = "CIDR allowed to access Kafka (9098)"
}

variable "tags" {
  type = map(string)
  default = {}
}