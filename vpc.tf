# September 27,2022 04:44 AM WAT
# Code creates the following infrastructure on aws
#   > vpc and all it's components
#   > EC2 in the created VPC
#   > Clean files (Provider, Backend, Variables, vpc.tf)


# Creating the project VPC with name PROJECT-VPC
resource "aws_vpc" "Project-vpc" {

    cidr_block = "10.0.0.0/16"

    tags = {
      "Name" = "Project-vpc"
    }
}

#Creating Public subnets with cidr 10.0.1.0/24 in the us-east-1 availability zones
resource "aws_subnet" "Public-subnets" {
  
  count = length(var.public-subnet-cidrs)
  vpc_id = aws_vpc.Project-vpc.id
  cidr_block = element(var.public-subnet-cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
      Name = "Public Subnet ${count.index + 1}"
      # Name = var.ec2_name_tag[each.key]
}
  }

#Creating Private subnets with cidr 10.0.1.0/24 in the us-east-1 availability zones
resource "aws_subnet" "Private-subnets" {

  count = length(var.private-subnet-cidrs)
  vpc_id = aws_vpc.Project-vpc.id
  cidr_block = element(var.private-subnet-cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
  
}

# Resource to create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.Project-vpc.id

  tags = {
    "Name" = "Project-igw"
  }
}

#Resource to create Route Table
resource "aws_route_table" "project-vpc-rtb" {
  vpc_id = aws_vpc.Project-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "Name" = "project-vpc-rtb"
  }

}

# #Resource to create Route table associatiation
resource "aws_route_table_association" "Public-subnet-asso" {
  
  count = length(var.public-subnet-cidrs)
  subnet_id = element(aws_subnet.Public-subnets[*].id, count.index)
  route_table_id = aws_route_table.project-vpc-rtb.id
}

#Resource to create EC2
resource "aws_instance" "project-ec2" {
  for_each = var.ami_ids
  ami           = each.value
  instance_type = var.instance_type[each.key]

  subnet_id = aws_subnet.Public-subnets[0].id
  vpc_security_group_ids = [aws_security_group.project_sg.id ]

  tags = {
    Name = "project-ec2"
  }
}

#Security group to allow access to port 80 from anywhere
resource "aws_security_group" "project_sg" {
 name        = "project_sg"
 description = "Ingress for Vault"
 vpc_id = aws_vpc.Project-vpc.id 

 dynamic "ingress" {
   for_each = var.sg_ports
   iterator = port
   content {
     from_port   = port.value
     to_port     = port.value
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
 }

 dynamic "egress" {
   for_each = var.sg_ports
   iterator = port
   content {
     from_port   = port.value
     to_port     = port.value
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
 }
}