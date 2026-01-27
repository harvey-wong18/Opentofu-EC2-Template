data "aws_ami" "ubuntu" {

  most_recent = true

  # filter {
  #   name = "image-id"
  #   values = ["ami-03e35f6ff70a496aa"]
  # }

  # filter {
  #   name = "owner-id"
  #   values = ["099720109477"]
  # }
  # most_recent = true

  filter {
    name   = "name"
    values = ["Deep Learning OSS Nvidia Driver AMI GPU PyTorch 2.9 (Ubuntu 24.04)*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "owner-alias"
    values = ["amazon"]
  }

  # filter {
  #   name = "image-id"
  #   values = ["ami-034416e1a748e5344"]
  # }

  filter {
    name = "architecture"
    values= ["x86_64"]
  }

  owners = ["898082745236"]
}


resource "aws_key_pair" "instance_pub_key" {
    key_name   = "ec2_key"
    public_key = file("~/.ssh/ec2pub.pub")
}

resource "aws_instance" "ec2_Ubuntu" {
    ami           = data.aws_ami.ubuntu.id
    instance_type = var.instance_type
    #availability_zone = var.availability_zone
    # "c5.4xlarge""g6.2xlarge"
    # "g6.8xlarge"

    
  root_block_device {
      volume_size           = 120       # GiB
      volume_type           = "gp3"     # gp3 recommended for cost/perf
      delete_on_termination = true
      encrypted             = true
      # gp3-specific (optional):
      # iops                = 3000
      # throughput          = 125
    }


    subnet_id = aws_subnet.public.id
    associate_public_ip_address = true
    key_name = aws_key_pair.instance_pub_key.key_name

    vpc_security_group_ids     = [aws_security_group.sg_web.id]

    depends_on = [aws_internet_gateway.igw]

    tags = {
        Name = "HelloWorld"
    }

    user_data = filebase64("./user_data.sh")
                

}
