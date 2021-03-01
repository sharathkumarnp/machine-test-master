
resource "aws_security_group" "sharath_vpc_db_security_group" {
  name        = "sharath_vpc_db_security_group"
  description = "Allow traffic to DB"
  vpc_id = "${aws_vpc.techies_vpc.id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.2.0/24"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/16"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
}

  tags {
    Name = "sharath_vpc_db_security_group"
  }
}


resource "aws_db_subnet_group" "sharath_vpc_db_subnet_group" {
  name       = "sharath_vpc_db_subnet_group"
  subnet_ids = ["${aws_subnet.sharath_private_subnet_2.id}", "${aws_subnet.sharath_private_subnet_1.id}"]

  tags {
    Name = "Sharath_VPC_DB_subnet_group"
  }
}

resource "aws_db_instance" "sharath_vpc_db" {
	allocated_storage    = 10
	storage_type         = "gp2"
	engine               = "mysql"
	engine_version       = "5.7"
	instance_class       = "db.t2.medium"
	name                 = "mydb"
	username             = "foo"
	password             = "foobarbaz"
	parameter_group_name = "default.mysql5.7"
	db_subnet_group_name = "${aws_db_subnet_group.sharath_vpc_db_subnet_group.id}"
	multi_az = "true"
	vpc_security_group_ids = ["${aws_security_group.sharath_vpc_db_security_group.id}"]
	final_snapshot_identifier = "sharath-vpc-db-final-snapshot"
}
