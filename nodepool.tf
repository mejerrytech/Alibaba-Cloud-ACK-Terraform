resource "alicloud_cs_kubernetes_node_pool" "nodepool" {
  cluster_id     = alicloud_cs_managed_kubernetes.ack.id
  name           = "${var.cluster_name}-nodepool"
  instance_types = var.worker_instance_types
  vswitch_ids    = [alicloud_vswitch.main.id]
  desired_size   = var.worker_number

  system_disk_category = "cloud_essd"
  system_disk_size     = 40

  tags = {
    Name = "nodepool"
  }
}
