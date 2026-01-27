variable "region" {
    type = string
    default = "eu-west-2"
    description = "aws region to deploy resources to"
}

variable "availability_zone" {
    type = string
    default = "eu-west-2b"
    description = "aws region to deploy resources to"
}

variable "instance_type" {
    type = string
    default = "g6e.2xlarge"
    description = "instance type to launch"
}