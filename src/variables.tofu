variable "region" {
    type = string
    default = "eu-central-1"
    description = "aws region to deploy resources to"
}

variable "availability_zone" {
    type = string
    default = "eu-central-1a"
    description = "aws region to deploy resources to"
}

variable "instance_type" {
    type = string
    default = "g6e.2xlarge"
    description = "instance type to launch"
}