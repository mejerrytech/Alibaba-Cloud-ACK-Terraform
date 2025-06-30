# Monitoring Stack on Alibaba Cloud ACK Using Terraform and Kubernetes

## 🔷 What is Alibaba Cloud ACK?

Alibaba Cloud Container Service for Kubernetes (ACK) is a managed Kubernetes service that makes it easy to run containerized applications on Alibaba Cloud without managing Kubernetes control plane infrastructure.

---

## 🔧 What is Terraform?

Terraform is an open-source infrastructure as code tool that allows you to define and provision cloud resources declaratively using `.tf` files.

---

## 📊 Monitoring Stack Components

This project deploys the following monitoring tools on Alibaba Cloud ACK:

- **Prometheus**: Collects metrics from nodes and services
- **Grafana**: Visualizes metrics through dashboards
- **Loki**: Stores logs in a time-series database optimized for logs
- **Promtail**: Agents on nodes to ship logs to Loki

## 📁 Repository Structure

```bash
ack.tf                    # ACK cluster provisioning
network.tf                # VPC, subnet, and networking configurations
nodepool.tf               # Node pool definitions
security_groups.tf        # Security group and firewall settings
monitoring.tf             # Kubernetes monitoring stack deployment
provider.tf               # Terraform provider configuration
variables.tf              # Input variables
output.tf                 # Output definitions
manifests/                # Kubernetes YAML manifests
README.md                 # Project documentation
