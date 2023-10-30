
#Create VPC 
resource "aws_vpc" "eks-vpc" {
  # CIDR Block for the VPC
  cidr_block = "10.0.0.0/16"

  # required for EKS, Enable/disable DNS Support and Hostname in the VPC
  enable_dns_support   = true
  enable_dns_hostnames = true

  # Makes your instance shared on the host
  instance_tenancy = "default"

  tags = {
    "Name" = "eks-vpc"
  }
}

/* #Create Subnet 
resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.eks-vpc.id
  count                   = length(var.subnet_cidrs_public)
  cidr_block              = var.subnet_cidrs_public[count.index]
  availability_zone      = var.availability_zone[count.index]
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${var.availability_zone[count.index]}-pub"
  }
}

resource "aws_subnet" "private-sub" {
  vpc_id                  = aws_vpc.eks-vpc.id
  count                   = length(var.subnet_cidrs_private)
  cidr_block              = var.subnet_cidrs_private[count.index]
  availability_zone       = var.availability_zone[count.index]
  map_public_ip_on_launch = false

  tags = {
    "Name" = "${var.availability_zone[count.index]}-pvt"
  }

} */

resource "aws_subnet" "public-sub1" {
  vpc_id                  = aws_vpc.eks-vpc.id
  cidr_block              = var.subnet_cidrs_public[0]
  availability_zone       = var.availability_zone[0]
  map_public_ip_on_launch = true

  tags = {
    "Name" = "public-sub1"
  }
}

resource "aws_subnet" "public-sub2" {
  vpc_id                  = aws_vpc.eks-vpc.id
  cidr_block              = var.subnet_cidrs_public[1]
  availability_zone       = var.availability_zone[1]
  map_public_ip_on_launch = true

  tags = {
    "Name" = "public-sub2"
  }
}

resource "aws_subnet" "private-sub1" {
  vpc_id                  = aws_vpc.eks-vpc.id
  cidr_block              = var.subnet_cidrs_private[0]
  availability_zone       = var.availability_zone[0]
  map_public_ip_on_launch = false

  tags = {
    "Name" = "private-sub1"
  }
}

resource "aws_subnet" "private-sub2" {
  vpc_id                  = aws_vpc.eks-vpc.id
  cidr_block              = var.subnet_cidrs_private[1]
  availability_zone       = var.availability_zone[1]
  map_public_ip_on_launch = false

  tags = {
    "Name" = "private-sub2"
  }
}
#Create Internet Gateway
resource "aws_internet_gateway" "eks_internet_gateway" {
  vpc_id = aws_vpc.eks-vpc.id
}

resource "aws_eip" "nat-eip" {
  depends_on = [
    aws_internet_gateway.eks_internet_gateway
  ]
}

resource "aws_nat_gateway" "nat-gateway1" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.private-sub1.id

  tags = {
    "Name" = "nat-gateway"
  }

}

#Create Route table and attached internet gateway
resource "aws_route_table" "eks_route_table_public" {
  vpc_id = aws_vpc.eks-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_internet_gateway.id
  }
}

resource "aws_route_table" "eks_route_table_private" {
  vpc_id = aws_vpc.eks-vpc.id
  /* count = length(var.subnet_cidrs_private) */
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway1.id
  }

}



resource "aws_route_table_association" "rt_public_1" {
  subnet_id      = aws_subnet.public-sub1.id
  route_table_id = aws_route_table.eks_route_table_public.id
}

resource "aws_route_table_association" "rt_private_1" {
  subnet_id      = aws_subnet.private-sub1.id
  route_table_id = aws_route_table.eks_route_table_private.id
}

resource "aws_route_table_association" "rt_public_2" {
  subnet_id      = aws_subnet.public-sub2.id
  route_table_id = aws_route_table.eks_route_table_public.id
}

resource "aws_route_table_association" "rt_private_2" {
  subnet_id      = aws_subnet.private-sub2.id
  route_table_id = aws_route_table.eks_route_table_private.id
}



#Create Security Group for test
resource "aws_security_group" "eks_security_group" {
  name        = "allow Access"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.eks-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "eks-security-group"
  }

}

