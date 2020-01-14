variable "aws_region" {
  description = "AWS region"
}

variable "namespace" {
  description = "Unique name to use for DNS and resource naming"
}

variable "images" {
  type    = "map"
  default = {
    us-east-1 = "ami-00cd7c7e50f907643"
    us-west-1 = "ami-0370ed85c86cb1e55"
    us-west-2 = "ami-04dee29ccf39a0e40"
  }
}


variable "aws_instance_type" {
  description = "EC2 instance type"
}

variable "ssh_key_name" {
  description = "AWS key pair name to install on the EC2 instance"
}

variable "owner" {
  description = "EC2 instance owner"
}

variable "ttl" {
  description = "EC2 instance TTL"
  default     = "168"
}

variable "public_key" {}