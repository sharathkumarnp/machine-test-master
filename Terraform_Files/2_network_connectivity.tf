
# Creating the Internet Gateway
resource "aws_internet_gateway" "sharath_vpc_gw" {
	vpc_id = "${aws_vpc.sharath_vpc.id}"

	tags {
		Name = "Sharath_VPC_Internet_Gateway"
	}
}

# Creating the Elastic IP for the NAT gateway
resource "aws_eip" "sharath_vpc_nat_eip" {
	vpc      = true
	depends_on = ["aws_internet_gateway.sharath_vpc_gw"]

	tags {
		Name = "Sharath_VPC_Nat_EIP"
	}
}

# Creating the NAT gateway
resource "aws_nat_gateway" "sharath_vpc_nat" {
	allocation_id = "${aws_eip.sharath_vpc_nat_eip.id}"
	subnet_id = "${aws_subnet.sharath_public_subnet.id}"
	depends_on = ["aws_internet_gateway.sharath_vpc_gw"]

	tags {
		Name = "Sharath_VPC_NAT"
	}

}

#Point default route in main route table to NAT gateway
resource "aws_default_route_table" "r" {
	default_route_table_id = "${aws_vpc.sharath_vpc.default_route_table_id}"

	route {
		cidr_block = "0.0.0.0/0"
		nat_gateway_id = "${aws_nat_gateway.sharath_vpc_nat.id}"
	}
}

#Create custom route table
resource "aws_route_table" "custom_route_table" {
    vpc_id = "${aws_vpc.sharath_vpc.id}"

    tags {
        Name = "Sharath_VPC_custom_route_table"
    }
}

#Create route to internet gateway
resource "aws_route" "igw_route" {
	route_table_id  = "${aws_route_table.custom_route_table.id}"
	destination_cidr_block = "0.0.0.0/0"
	gateway_id = "${aws_internet_gateway.sharath_vpc_gw.id}"
}

# Associate custom route table with public subnet
resource "aws_route_table_association" "public_subnet_custom_route_table_association" {
	subnet_id = "${aws_subnet.sharath_public_subnet.id}"
	route_table_id = "${aws_route_table.custom_route_table.id}"
}

# Associate main route table with private subnet 1
resource "aws_route_table_association" "private_subnet_1_custom_route_table_association" {
	subnet_id = "${aws_subnet.sharath_private_subnet_1.id}"
	route_table_id = "${aws_vpc.sharath_vpc.default_route_table_id}"
}

# Associate main route table with private subnet 2
resource "aws_route_table_association" "private_subnet_2_custom_route_table_association" {
	subnet_id = "${aws_subnet.sharath_private_subnet_2.id}"
	route_table_id = "${aws_vpc.sharath_vpc.default_route_table_id}"
}