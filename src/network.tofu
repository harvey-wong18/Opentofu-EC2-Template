resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc"
  }
}

# subnet

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.vpc.id
  availability_zone = var.availability_zone
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public subnet"
  }
}

# internet gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "igw"
  }
}

#Route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "route-table-public"
  }
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id
  subnet_id = aws_subnet.public.id
}

resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id = aws_route_table.public.id
  gateway_id = aws_internet_gateway.igw.id
}

#Security rules
resource "aws_security_group" "sg_web" {
  name        = "web_security"
  description = "Allow HTTP, HTTPS & SSH"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "web-security"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.sg_web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80

}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.sg_web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.sg_web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.sg_web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}