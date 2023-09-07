# 1. create A VPC Infrastructure
resource "aws_vpc" "kubenetes-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "kubenetes-vpc"
  }
}
#  2. create public subnet1. 
resource "aws_subnet" "kubenetes-pub-sn1" {
  vpc_id            = aws_vpc.kubenetes-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "kubenetes-pub_sn1"
  }
}
# 3. create public subnet2. 
resource "aws_subnet" "kubenetes-pub-sn2" {
  vpc_id            = aws_vpc.kubenetes-vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-west-2b"
  tags = {
    Name = "kubenetes-pub-sn2"
  }
}
# 6. internet gateways
resource "aws_internet_gateway" "kubenetes-igw" {
  vpc_id = aws_vpc.kubenetes-vpc.id
  tags = {
    Name = "kubenetes-igw"
  }
}
# 7. route tables
resource "aws_route_table" "kubenetes-rt" {
  vpc_id = aws_vpc.kubenetes-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kubenetes-igw.id
  }
  tags = {
    Name = "kubenetes-rt"
  }
}
# 8. route table association for Public Subnet1
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.kubenetes-pub-sn1.id
  route_table_id = aws_route_table.kubenetes-rt.id
}
#  9. route table association for Pubblic Subnet2
resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.kubenetes-pub-sn2.id
  route_table_id = aws_route_table.kubenetes-rt.id
}
# 10. Security/port
resource "aws_security_group" "kubenetes-fe-sg" {
  name        = "kubenetes-fe-sg"
  description = "inbound tls"
  vpc_id      = aws_vpc.kubenetes-vpc.id
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow all port to VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "kubenetes-fe-sg"
  }
}
# 11. Create a Keypair
resource "aws_key_pair" "kubenetes-key" {
  key_name   = var.keyname
  public_key = file(var.kubenetes-key)
}
# 12. Create Kubernetes Server
resource "aws_instance" "kubenetes-Servers" {
  count = 7
  ami                         = var.ami
  instance_type               = var.instance-type
  vpc_security_group_ids      = [aws_security_group.kubenetes-fe-sg.id]
  subnet_id                  = aws_subnet.kubenetes-pub-sn1.id
  key_name                    = var.keyname
  associate_public_ip_address = true
  tags = {
    Name = "kubenetes-Server${count.index}"
  }
}