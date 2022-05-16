

##########################
########  MAIN VPC  ######
##########################
resource "aws_vpc" "nikko-vpc" {
  cidr_block = "10.100.0.0/16"
}

resource "aws_subnet" "nikko-pub-sub1" {
  vpc_id                  = aws_vpc.nikko-vpc.id
  
  cidr_block              = "10.100.0.0/24"
  availability_zone       = "us-east-1a"
 
  tags = {
    Name        = "PubSub1-Nikko"
   
  }
}
resource "aws_internet_gateway" "igw-nikko" {
  vpc_id = aws_vpc.nikko-vpc.id

  tags = {
    Name = "IGW"
  }
}

resource "aws_eip" "eip-nikko" {
  vpc      = true
}

resource "aws_nat_gateway" "NAT-Nikko" {
  allocation_id = aws_eip.eip-nikko.id
  subnet_id     = aws_subnet.nikko-pub-sub1.id

  tags = {
    Name = "gw NAT"
  }
}

resource "aws_subnet" "nikko-pub-sub2" {
  vpc_id                  = aws_vpc.nikko-vpc.id
  
  cidr_block              = "10.100.1.0/24"
  availability_zone       = "us-east-1b"
 
  tags = {
    Name        = "PubSub2-Nikko"
   
  }
}

resource "aws_subnet" "nikko-pub-sub3" {
  vpc_id                  = aws_vpc.nikko-vpc.id
  
  cidr_block              = "10.100.2.0/24"
  availability_zone       = "us-east-1c"
 
  tags = {
    Name        = "PubSub3-Nikko"
   
  }
}

#################################
########## PRIVATE SUBNETS
#################################
resource "aws_subnet" "nikko-priv-sub1" {
  vpc_id                  = aws_vpc.nikko-vpc.id
  
  cidr_block              = "10.100.3.0/24"
  availability_zone       = "us-east-1c"
 
  tags = {
    Name        = "PrivSub1-Nikko"
   
  }
}

resource "aws_subnet" "nikko-priv-sub2" {
  vpc_id                  = aws_vpc.nikko-vpc.id
  
  cidr_block              = "10.100.4.0/24"
  availability_zone       = "us-east-1b"
 
  tags = {
    Name        = "PrivSub2-Nikko"
   
  }
}

resource "aws_subnet" "nikko-priv-sub3" {
  vpc_id                  = aws_vpc.nikko-vpc.id
  
  cidr_block              = "10.100.5.0/24"
  availability_zone       = "us-east-1c"
 
  tags = {
    Name        = "PrivSub3-Nikko"
   
  }
}

#############################################
#-----------PUBLIC ROUTE TABLE-------------#
#############################################
resource "aws_route_table" "Nikko-RT-Pub" {
  vpc_id = aws_vpc.nikko-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-nikko.id

  }

  
  tags = {
    Name = "Nikko Public Route Table "
  }
}
resource "aws_route_table_association" "pub1a" {
  subnet_id      = aws_subnet.nikko-pub-sub1.id
  route_table_id = aws_route_table.Nikko-RT-Pub.id
}
resource "aws_route_table_association" "pub1b" {
  subnet_id      = aws_subnet.nikko-pub-sub2.id
  route_table_id = aws_route_table.Nikko-RT-Pub.id
}
resource "aws_route_table_association" "pub1c" {
  subnet_id      = aws_subnet.nikko-pub-sub3.id
  route_table_id = aws_route_table.Nikko-RT-Pub.id
}

#############################################
#-----------PRIVATE ROUTE TABLE-------------#
#############################################
resource "aws_route_table" "Nikko-RT-PRIVATE" {
  vpc_id = aws_vpc.nikko-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT-Nikko.id
  }

  
  tags = {
    Name = "Nikko Private Route Table"
  }
}
resource "aws_route_table_association" "priv1a" {
  subnet_id      = aws_subnet.nikko-priv-sub1.id
  route_table_id = aws_route_table.Nikko-RT-PRIVATE.id
}
resource "aws_route_table_association" "priv1b" {
  subnet_id      = aws_subnet.nikko-priv-sub2.id
  route_table_id = aws_route_table.Nikko-RT-PRIVATE.id
}
resource "aws_route_table_association" "priv1c" {
  subnet_id      = aws_subnet.nikko-priv-sub3.id
  route_table_id = aws_route_table.Nikko-RT-PRIVATE.id
}
