output "ack_cluster_id" {
  description = "ACK Cluster ID"
  value       = alicloud_cs_managed_kubernetes.ack.id
}

output "grafana_access_url" {
  description = "Grafana URL for accessing the UI"
  value       = "http://${kubernetes_service.grafana.status[0].load_balancer[0].ingress[0].ip}:3000"
}


output "grafana_default_login" {
  description = "Grafana default login credentials"
  value       = "Username: admin / Password: admin"
}

output "vpc_id" {
  description = "VPC ID for the ACK cluster"
  value       = alicloud_vpc.main.id
}

output "vswitch_id" {
  description = "VSwitch ID used by ACK"
  value       = alicloud_vswitch.main.id
}

output "nat_gateway_eip" {
  description = "Public EIP for NAT Gateway"
  value       = alicloud_eip.nat_eip.ip_address
}
output "prometheus_internal_url" {
  description = "Prometheus internal cluster DNS URL"
  value       = "http://${kubernetes_service.prometheus.metadata[0].name}.${kubernetes_service.prometheus.metadata[0].namespace}.svc.cluster.local:${kubernetes_service.prometheus.spec[0].port[0].port}"
}
output "loki_internal_url" {
  description = "Loki internal cluster DNS URL"
  value       = "http://${kubernetes_service.loki.metadata[0].name}.${kubernetes_service.loki.metadata[0].namespace}.svc.cluster.local:${kubernetes_service.loki.spec[0].port[0].port}"
}
