#Create the Beanstalk application
resource "aws_elastic_beanstalk_application" "sharath_website" {
	name        = "sharath_website"
	description = "Application for the website."
}

#Create the Beanstalk environment for the application
resource "aws_elastic_beanstalk_environment" "production" {
	depends_on = ["aws_vpc.sharath_vpc"]
	name                = "production"
	application         = "${aws_elastic_beanstalk_application.sharath_website.name}"
	solution_stack_name = "64bit Amazon Linux  v2.8.3 running PHP 7.2"

	setting {
		namespace = "aws:autoscaling:asg"
		name      = "Availability Zones"
		value     = "Any 1"
	}

	setting {
		namespace = "aws:autoscaling:trigger"
		name      = "Unit"
		value     = "Percent"
	}

	setting {
		namespace = "aws:autoscaling:trigger"
		name      = "MeasureName"
		value     = "CPUUtilization"
	}

	setting {
		namespace = "aws:autoscaling:trigger"
		name      = "LowerThreshold"
		value     = "20"
	}
	setting {
		namespace = "aws:autoscaling:trigger"
		name      = "UpperThreshold"
		value     = "80"
	}

	setting {
		namespace = "aws:ec2:vpc"
		name      = "VPCId"
		value     = "${aws_vpc.techies_vpc.id}"
	}

	setting {
		namespace = "aws:ec2:vpc"
		name      = "AssociatePublicIpAddress"
		value     = "false"
	}

	setting {
		namespace = "aws:ec2:vpc"
		name      = "Subnets"
		value     = "${aws_subnet.sharath_private_subnet_1.id}"
	}

	setting {
		namespace = "aws:ec2:vpc"
		name      = "ELBSubnets"
		value     = "${aws_subnet.sharath_public_subnet.id}"
	}
}
