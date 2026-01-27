output "webserver_ip" {
  value = aws_instance.ec2_Ubuntu.public_ip
}
