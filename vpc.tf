resource "aws_vpc" "hasnain_vpc" {
  cidr_block                       = "10.0.0.0/16"
  assign_generated_ipv6_cidr_block = false
  instance_tenancy                 = "default"

  tags = {
    Name = "hasnain_vpc"
  }
}
resource "aws_subnet" "hasnain-public_1" {
  vpc_id                  = aws_vpc.hasnain_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1a"
  tags = {
    Name = "hasnain-public_1"
  }
}
output "aws_subnet_subnet_1" {
  value = aws_subnet.hasnain-public_1.id
}
resource "aws_subnet" "hasnain-public_2" {
  vpc_id                  = aws_vpc.hasnain_vpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1b"
  tags = {
    Name = "hasnain-public_2"
  }
}
resource "aws_subnet" "hasnain_private_1" {
  vpc_id                  = aws_vpc.hasnain_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "eu-west-1b"
  tags = {
    Name = "hasnain_private_1"
  }
}
output "aws_subnet_Private_1" {
  value = aws_subnet.hasnain_private_1.id
}
resource "aws_eip" "nat_gateway" {

  vpc = true
}
resource "aws_internet_gateway" "hasnainIGW" {
  vpc_id = aws_vpc.hasnain_vpc.id

  tags = {
    Name = "hasnainIGW"
  }
}
resource "aws_route_table" "routetb" {
  vpc_id = aws_vpc.hasnain_vpc.id
  tags = {
    Name = "routetb"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hasnainIGW.id
  }

}

resource "aws_route_table_association" "table_subnet" {
  subnet_id      = aws_subnet.hasnain-public_1.id
  route_table_id = aws_route_table.routetb.id
}


resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = "${aws_eip.nat_gateway.id}"
  subnet_id = aws_subnet.hasnain-public_1.id

  tags = {
    Name = "nat_gateway"
  }
}

resource "aws_route_table" "routetb1" {
  vpc_id = aws_vpc.hasnain_vpc.id
  tags = {
    Name = "routetb1"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }

}

resource "aws_route_table_association" "table_subnet_1" {
  subnet_id      = aws_subnet.hasnain_private_1.id
  route_table_id = aws_route_table.routetb1.id
}


