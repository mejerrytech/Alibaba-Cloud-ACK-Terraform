resource "alicloud_security_group" "ack_sg" {
  name        = "ack-workers-sg"
  vpc_id      = alicloud_vpc.main.id
  description = "Allow internal VPC traffic"
}

resource "alicloud_security_group_rule" "vpc_internal" {
  type              = "ingress"
  ip_protocol       = "all"
  port_range        = "-1/-1"
  security_group_id = alicloud_security_group.ack_sg.id
  cidr_ip           = var.vpc_cidr
  priority          = 1
}
