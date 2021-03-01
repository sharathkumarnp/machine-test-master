# Selecting the region with the provider
provider "aws" {
	region = "us-east-1"
}

# Creating the VPC
resource "aws_vpc" "sharath_vpc" {
	cidr_block = "10.0.0.0/16"

	tags {
		Name = "Sharath_VPC"
	}
}

# Creating the public subnet
resource "aws_subnet" "sharath_public_subnet" {
	vpc_id                  = "${aws_vpc.sharath_vpc.id}"
	cidr_block              = "10.0.1.0/24"
	availability_zone       = "us-east-1a"

	tags = {
		Name = "Sharath_VPC_Public_Subnet"
	}
}

# Creating the private subnet 1
resource "aws_subnet" "techies_private_subnet_1" {
	vpc_id                  = "${aws_vpc.sharath_vpc.id}"
	cidr_block              = "10.0.2.0/24"
	availability_zone       = "us-east-1a"

	tags = {
		Name = "Sharath_VPC_Private_Subnet_1"
	}
}

# Creating the private subnet 2
resource "aws_subnet" "sharath_private_subnet_2" {
	vpc_id                  = "${aws_vpc.sharath_vpc.id}"
	cidr_block              = "10.0.3.0/24"
	availability_zone       = "us-east-1b"

	tags = {
		Name = "Sharath_VPC_Private_Subnet_2"
	}
}
