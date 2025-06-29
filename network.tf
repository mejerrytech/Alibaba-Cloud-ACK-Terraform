resource "alicloud_vpc" "main" {
  name       = "mon-vpc"
  cidr_block = var.vpc_cidr
}

resource "alicloud_vswitch" "main" {
  name       = "mon-vswitch"
  vpc_id     = alicloud_vpc.main.id
  cidr_block = var.vswitch_cidr
  zone_id    = var.zone_id
}

resource "alicloud_nat_gateway" "nat" {
  vpc_id     = alicloud_vpc.main.id
  vswitch_id = alicloud_vswitch.main.id  
  nat_type   = "Enhanced"

  tags = {
    Name = "nat-gateway"
  }
}

resource "alicloud_eip" "nat_eip" {
  bandwidth            = 10
  internet_charge_type = "PayByTraffic"
}

resource "alicloud_eip_association" "nat_eip_assoc" {
  allocation_id = alicloud_eip.nat_eip.id
  instance_id   = alicloud_nat_gateway.nat.id
}

resource "alicloud_snat_entry" "snat" {
  snat_table_id     = alicloud_nat_gateway.nat.snat_table_ids  # ✅ Flattened index
  source_vswitch_id = alicloud_vswitch.main.id
  snat_ip           = alicloud_eip.nat_eip.ip_address
}
