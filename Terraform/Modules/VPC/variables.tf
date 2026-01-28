variable "name" {
  description = "VPC name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "az_count" {
  description = "Number of AZs"
  type        = number
  default     = 3
}

variable "enable_nat_gateway" {
  default = true
  type        = bool
}
