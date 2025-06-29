variable "region" {
  type    = string
  default = "me-central-1"
}

variable "zone_id" {
  type    = string
  default = "me-central-1a"
}

variable "vpc_cidr" {
  type    = string
  default = "192.168.0.0/16"
}

variable "vswitch_cidr" {
  type    = string
  default = "192.168.1.0/24"
}

variable "cluster_name" {
  type    = string
  default = "mon-ack-cluster"
}

variable "worker_instance_types" {
  type    = list(string)
  default = ["ecs.c6.large"]  # Valid instance type for ACK nodes in Riyadh
}

variable "worker_number" {
  type    = number
  default = 2
}

