# machine-test-master
Terraform machine test.
The proposed infrastructure has been designed on Amazon Web Services.
The solution consists of a high availability PHP application launched on Elastic Beanstalk with an external Amazon RDS database with the multi AZ feature enabled.
The infrastructure is hosted on a single VPC with three subnets.
One subnet is a public subnet and the other two subnets are private subnets.
The public subnet contains the load balancer for the Elastic Beanstalk cluster.
One private subnet contains the auto scaling group to which the Elastic load balancer connects to and the RDS database.
To deal with increases in traffic Beanstalk is configured to scale up buy one instance when CPU utilization goes above 80% and scale down when CPU utilization goes below 20%.
To keep things simple, Beanstalk is configured to work in one availability zone i.e. when CPU utilization goes up a new server is added to the same availability zone (i.e. the same subnet).
The second subnet contains the replica for the main RDS database in the first subnet.
The VPC contains an internet gateway to allow communication between the instances in the VPC and the internet.
The public subnet contains a NAT gateway to enable outgoing internet connectivity from the private subnet.
It is a requirement for instances in a Beanstalk auto scaling group to connect to the internet and the NAT gateway helps meet this requirement.
During the creation of the Beanstalk cluster two security groups are automatically generated by Beanstalk.
One is attached to the load balancer so that web requests can connect with the load balancer on port 80.
The other is attached to the auto scaling group so that requests from the load balancer can connect with the instances in the auto scaling group on port 80.
