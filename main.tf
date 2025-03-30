#*****************AWS VPC Creation********************#
resource "aws_vpc" "nike-main-vpc" {
  cidr_block = var.vpc_cidr_value
  tags = {
    Name = "nike-main-vpc"
    Environment = var.environment
  }
}

#*****************AWS IGW Creation********************#
resource "aws_internet_gateway" "nike-igw" {
  vpc_id = aws_vpc.nike-main-vpc.id
  tags = {
    Name = "nike-igw"
    Environment = var.environment
  }
}

#*****************AWS SUBNET Creation********************#
resource "aws_subnet" "nike-public-subnet1" {
  vpc_id = aws_vpc.nike-main-vpc.id
  cidr_block = var.public-subnet-cidr-value1
  map_public_ip_on_launch = true //this will provide public ip address to instance when launched in this subnet
  //availability_zone = data.aws_availability_zones.available[0].name
  availability_zone_id = data.aws_availability_zones.available.id
  tags = {
    Name = "nike-public-subnet-1"
    Environment = var.environment
  }
}

resource "aws_subnet" "nike-public-subnet2" {
  vpc_id = aws_vpc.nike-main-vpc.id
  cidr_block = var.public-subnet-cidr-value2
  map_public_ip_on_launch = true //this will provide public ip address to instance when launched in this subnet
  //availability_zone = data.aws_availability_zones.available[1].name
  availability_zone_id = data.aws_availability_zones.available.id
  tags = {
    Name = "nike-public-subnet-2"
    Environment = var.environment
  }
}

resource "aws_subnet" "nike-private-subnet1" {
  vpc_id = aws_vpc.nike-main-vpc.id
  cidr_block = var.private-subnet-cidr-value1
  map_public_ip_on_launch = false
  availability_zone_id = data.aws_availability_zones.available.id
  //availability_zone = data.aws_availability_zones.available[0].name
  tags = {
    Name = "nike-private-subnet-1"
    Environment = var.environment
  }
}

resource "aws_subnet" "nike-private-subnet2" {
  vpc_id = aws_vpc.nike-main-vpc.id
  cidr_block = var.private-subnet-cidr-value2
  map_public_ip_on_launch = false
  availability_zone_id = data.aws_availability_zones.available.id
  //availability_zone = data.aws_availability_zones.available[0].name
  tags = {
    Name = "nike-private-subnet-2"
    Environment = var.environment
  }
}

#*****************AWS ROUTE TABLE Creation********************#
resource "aws_route_table" "nike-public-route-table1" {
  vpc_id = aws_vpc.nike-main-vpc.id //new route table created in vpc
  tags = {
    Name = "nike-public-route-table1"
    Environment = var.environment
  }
}

resource "aws_route_table" "nike-public-route-table2" {
  vpc_id = aws_vpc.nike-main-vpc.id
  tags = {
    Name = "nike-public-route-table2"
    Environment = var.environment
  }
}

resource "aws_route_table" "nike-private-route-table1" {
  vpc_id = aws_vpc.nike-main-vpc.id
  tags = {
    Name = "nike-public-route-table1"
    Environment = var.environment
  }
}

resource "aws_route_table" "nike-private-route-table2" {
  vpc_id = aws_vpc.nike-main-vpc.id
  tags = {
    Name = "nike-public-route-table2"
    Environment = var.environment
  }
}

#*****************AWS SUBNET ROUTE TABLE ASSOCIATIONS********************#

resource "aws_route_table_association" "nike-public-route-table-association1" {
  subnet_id = aws_subnet.nike-public-subnet1.id
  route_table_id = aws_route_table.nike-public-route-table1.id
}

resource "aws_route_table_association" "nike-public-route-table-association2" {
  subnet_id = aws_subnet.nike-public-subnet2.id
  route_table_id = aws_route_table.nike-public-route-table2.id
}

resource "aws_route_table_association" "nike-private-route-table-association1" {
  subnet_id = aws_subnet.nike-private-subnet1.id
  route_table_id = aws_route_table.nike-private-route-table1.id
}

resource "aws_route_table_association" "nike-private-route-table-association2" {
  subnet_id = aws_subnet.nike-private-subnet2.id
  route_table_id = aws_route_table.nike-private-route-table2.id
}

#*****************AWS ROUTE ADDITION INTO ROUTE TABLES (adding internet & IGW into route tables)********************#

resource "aws_route" "nike-public-route1" { # This will create routes inside route table
  route_table_id = aws_route_table.nike-public-route-table1.id # this the route table in which routes will be created
  destination_cidr_block = "0.0.0.0/0"  # this is the route for internet connections
  gateway_id = aws_internet_gateway.nike-igw.id # This is internet gateway to the route traffic to internet connections
}

resource "aws_route" "nike-public-route2" {
  route_table_id = aws_route_table.nike-public-route-table2.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.nike-igw.id
}

#*****************AWS SECURITY GROUP********************#

resource "aws_security_group" "nike-security-group-main" { # This will create security group in vpc
  name = "nike-Security-Group" # name for security group
  description = "nike Security Group" # description for SG
  vpc_id = aws_vpc.nike-main-vpc.id # Vpc in which this SG will be created
  tags = {
    Name : "nike-Security-Group" # Tags for security group
    Environment : var.environment # Environment for the security group
  }
  ingress {  # This is for inbound rules in SG
    from_port   = 22 # This is syntax to open port 22
    to_port     = 22
    protocol    = "tcp" # its using SSH but we specify TCP here 
    cidr_blocks = ["0.0.0.0/0"] # To allow traffic from anywhere IPV4
  }
  ingress { 
    from_port   = 80  # This is syntax to open port 80
    to_port     = 80
    protocol    = "tcp" # its using HTTP but we specify TCP here
    cidr_blocks = ["0.0.0.0/0"] 
  }
  ingress {
    from_port   = 8080 # This is syntax to open port 8080
    to_port     = 8080
    protocol    = "tcp" 
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {  # This is syntax to open ports for outbound traffic
    from_port   = 0 # we are allowing all traffic for outbound
    to_port     = 0 # we are allowing all traffic for outbound
    protocol    = "-1" # all Protocols
    cidr_blocks = ["0.0.0.0/0"] # anywhere ipv4
    ipv6_cidr_blocks = ["::/0"] # anywhere ipv6
  }
}

