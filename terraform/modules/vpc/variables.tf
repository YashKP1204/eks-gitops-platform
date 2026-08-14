variable "aws_region" {
  type        = string
  description = "AWS region where the infrastructure will be created"
  default     = "ap-south-1"
}

variable "project_name" {
  type        = string
  description = "Project name used for resource naming"
  default     = "eks-gitops-platform"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR Block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_cidr" {
  type        = list(string)
  description = "CIDR range for public subnet"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_cidr" {
  type        = list(string)
  description = "CIDR range for private subnet"
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}



