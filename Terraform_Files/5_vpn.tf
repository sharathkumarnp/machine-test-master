
resource "aws_vpn_gateway" "techies_vpn_gateway" {
	vpc_id = "${aws_vpc.techies_vpc.id}"
}

resource "aws_customer_gateway" "techies_customer_gateway" {
	bgp_asn    = 65000
	ip_address = "172.0.0.1"
	type       = "ipsec.1"
}

resource "aws_vpn_connection" "main" {
	vpn_gateway_id      = "${aws_vpn_gateway.techies_vpn_gateway.id}"
	customer_gateway_id = "${aws_customer_gateway.techies_customer_gateway.id}"
	type                = "ipsec.1"
	static_routes_only  = true
}

