resource "aws_vpc" "vpc-hcl" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc-hcl.id

}
resource "aws_subnet" "puplic-subnet" {
  vpc_id     = aws_vpc.vpc-hcl.id
  cidr_block = "10.0.1.0/24"

}
resource "aws_route_table" "puplic-rt" {
  vpc_id = aws_vpc.vpc-hcl.id

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.igw.id
  }
resource "aws_route_table_association" "public-rt-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.vpc-hcl.id
  cidr_block = "10.0.2.0/24"

}

resource "aws_nat_gateway" "nat-hcl" {
  allocation_id = aws_eip.example.id
  subnet_id     = aws_subnet.public-subnet.id
  depends_on = [aws_internet_gateway.igw]
}



