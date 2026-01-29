variable "vpc_id" {
  description = "VPC ID"  
  type =  string
}
variable "subnet_ids" {
  type = list(string)  
  description = "Private Subnet IDs"
}