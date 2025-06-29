terraform {
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "1.244.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

provider "alicloud" {
  region = var.region
}


provider "kubernetes" {
  config_path = "${path.module}/kubeconfig.yaml"
}

