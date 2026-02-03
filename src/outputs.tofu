output "login_to_EC2_instance" {
  value = join("",["ssh -i ", var.keyName, " ubuntu@" ,aws_instance.ec2_Ubuntu.public_ip])
}
