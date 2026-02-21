variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "ec2-public"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type (t2.micro is free tier eligible)"
  type        = string
  default     = "t2.micro"
  
  validation {
    condition     = can(regex("^t2\\.(micro|small)", var.instance_type))
    error_message = "Instance type should be t2.micro or t2.small for free tier eligibility."
  }
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH access (change for production)"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # WARNING: This allows SSH from anywhere, restrict in production
}
