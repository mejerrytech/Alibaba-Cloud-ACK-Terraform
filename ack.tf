resource "alicloud_cs_managed_kubernetes" "ack" {
  name               = var.cluster_name
  cluster_spec       = "ack.pro.small"
  worker_vswitch_ids = [alicloud_vswitch.main.id]
  new_nat_gateway    = false

  version            = "1.33.1-aliyun.1"
  deletion_protection = false
  proxy_mode         = "ipvs"

  pod_cidr     = "172.16.0.0/16"
  service_cidr = "172.17.0.0/20"

  tags = {
    Name = "mon-ACK"
    Env  = "Dev"
  }
}
