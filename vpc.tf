#vpc
resource "aws_vpc" "lms-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "lms-vpc"
  }
}
#web subnet
resource "aws_subnet" "Lms-web-sn" {
  vpc_id     = aws_vpc.lms-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-west-2a"
  tags = {
    Name = "Lms-Web-subnet"
  }
}
#Api subnet
resource "aws_subnet" "lms-Api-sn" {
  vpc_id     = aws_vpc.lms-vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "Lms-Api-subnet"
  }
}
#database subnet
resource "aws_subnet" "lms-db-sn" {
  vpc_id     = aws_vpc.lms-vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "Lms-database-subnet"
  }
}
# internet gateway
resource "aws_internet_gateway" "lms-igw" {
  vpc_id = aws_vpc.lms-vpc.id

  tags = {
    Name = "Lms-Internet-gateway"
  }
}
#Lms-puplic-Rout table
resource "aws_route_table" "lms-pub-rt" {
  vpc_id = aws_vpc.lms-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lms-igw.id
  }

  tags = {
    Name = "Lms-puplic-Rout-table"
  }
}
#Lms Pravite-Rout table
resource "aws_route_table" "lms-pvt-rt" {
  vpc_id = aws_vpc.lms-vpc.id

  
  tags = {
    Name = "Lms-Pravite-Rout-table"
  }
}
# Web route table association
resource "aws_route_table_association" "lms-web-asc" {
  subnet_id      = aws_subnet.Lms-web-sn.id
  route_table_id = aws_route_table.lms-pub-rt.id
}
# Api route table association
resource "aws_route_table_association" "lms-Api-asc" {
  subnet_id      = aws_subnet.lms-Api-sn.id
  route_table_id = aws_route_table.lms-pub-rt.id
}
# Data Base route table association
resource "aws_route_table_association" "lms-db-asc" {
  subnet_id      = aws_subnet.lms-db-sn.id
  route_table_id = aws_route_table.lms-pvt-rt.id
}
# Create Web-NACL
resource "aws_network_acl" "lms-web-nacl" {
  vpc_id = aws_vpc.lms-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "lms-web-nacl"
  }
}
# Create API-NACL
resource "aws_network_acl" "lms-api-nacl" {
  vpc_id = aws_vpc.lms-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "lms-api-nacl"
  }
}
 # Create DB-NACL
resource "aws_network_acl" "lms-db-nacl" {
  vpc_id = aws_vpc.lms-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "lms-db-nacl"
  }
}
# Create web-NACL association
resource "aws_network_acl_association" "lms-web-nacl-ass" {
  network_acl_id = aws_network_acl.lms-web-nacl.id
  subnet_id      = aws_subnet.Lms-web-sn.id
}
# Create Api-NACL association
resource "aws_network_acl_association" "lms-api-nacl-ass" {
  network_acl_id = aws_network_acl.lms-api-nacl.id
  subnet_id      = aws_subnet.lms-Api-sn.id
}
# Create DB-NACL association
resource "aws_network_acl_association" "lms-db-nacl-ass" {
  network_acl_id = aws_network_acl.lms-db-nacl.id
  subnet_id      = aws_subnet.lms-db-sn.id
}
# create security Group - Web
resource "aws_security_group" "lms-web-sg" {
  name        = "lms-web-sg"
  description = "Allow ssh and http traffic"
  vpc_id      = aws_vpc.lms-vpc.id

  tags = {
    Name = "lms-web-sg"
  }
}
# create security Group - Web-incoming-ssh
resource "aws_vpc_security_group_ingress_rule" "lms-web-sg-ing-ssh" {
  security_group_id = aws_security_group.lms-web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
# create security Group - Web-incoming-http
resource "aws_vpc_security_group_ingress_rule" "lms-web-sg-ing-http" {
  security_group_id = aws_security_group.lms-web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
# create security Group - web-egress
resource "aws_vpc_security_group_egress_rule" "lms-web-sg-egs" {
  security_group_id = aws_security_group.lms-web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}

# create security Group - Api
resource "aws_security_group" "lms-api-sg" {
  name        = "lms-api-sg"
  description = "Allow ssh and nodejs traffic"
  vpc_id      = aws_vpc.lms-vpc.id

  tags = {
    Name = "lms-api-sg"
  }
}

# create security Group - api-incoming-ssh
resource "aws_vpc_security_group_ingress_rule" "lms-api-sg-ing-ssh" {
  security_group_id = aws_security_group.lms-api-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
# create security Group - api-incoming-nodejs
resource "aws_vpc_security_group_ingress_rule" "lms-api-sg-ing-nodejs" {
  security_group_id = aws_security_group.lms-api-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}
# create security Group - api-egress
resource "aws_vpc_security_group_egress_rule" "lms-api-sg-egs" {
  security_group_id = aws_security_group.lms-api-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}
# create security Group - DB
resource "aws_security_group" "lms-db-sg" {
  name        = "lms-db-sg"
  description = "Allow ssh and postgress traffic"
  vpc_id      = aws_vpc.lms-vpc.id

  tags = {
    Name = "lms-db-sg"
  }
}

# create security Group - db-incoming-ssh
resource "aws_vpc_security_group_ingress_rule" "lms-db-sg-ing-ssh" {
  security_group_id = aws_security_group.lms-db-sg.id
  cidr_ipv4         = "10.0.0.0/16"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
# create security Group - db-incoming-postgress
resource "aws_vpc_security_group_ingress_rule" "lms-db-sg-ing-postgress" {
  security_group_id = aws_security_group.lms-db-sg.id
  cidr_ipv4         = "10.0.0.0/16"
  from_port         = 5432
  ip_protocol       = "tcp"
  to_port           = 5432
}
# create security Group - db-egress
resource "aws_vpc_security_group_egress_rule" "lms-db-sg-egs" {
  security_group_id = aws_security_group.lms-db-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}