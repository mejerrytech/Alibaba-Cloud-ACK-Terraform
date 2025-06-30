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

Setup & Deployment Steps
Clone the Repository

bash
Copy
Edit
git clone https://github.com/your-org/Alibaba-Cloud-ACK-Terraform.git
cd Alibaba-Cloud-ACK-Terraform
Initialize Terraform

bash
Copy
Edit
terraform init
Plan Infrastructure

bash
Copy
Edit
terraform plan
Apply Infrastructure (Create ACK Cluster)

bash
Copy
Edit
terraform apply
Get the Kubeconfig from Alibaba ACK Console

Go to Alibaba Cloud ACK Console

Navigate to your cluster → Cluster Information

Click "Get Kubeconfig"

Choose Public Access or Private based on your setup

Copy the kubeconfig content

Create a Local Kubeconfig File

In the root Terraform directory:

bash
Copy
Edit
touch kubeconfig.yaml
Paste the copied content into kubeconfig.yaml.

Set Environment Variable (Optional)

Export your kubeconfig so that Terraform and kubectl can access it:

bash
Copy
Edit
export KUBECONFIG=./kubeconfig.yaml
Run Terraform Again to Deploy Monitoring Stack

bash
Copy
Edit
terraform apply
✅ Output
After successful deployment, the Terraform output will show:

✅ Grafana endpoint

URL: http://<public-ip>:3000

Default credentials: admin / admin (you can customize later)

🔍 Prometheus & Loki Internal URLs
These URLs will be used inside Grafana as data sources:

Prometheus: http://prometheus.monitoring.svc.cluster.local:9090

Loki: http://loki.monitoring.svc.cluster.local:3100

📌 Final Steps in Grafana
Open the Grafana dashboard in your browser.

Go to Configuration → Data Sources

Add the following:

Prometheus:

URL: http://prometheus.monitoring.svc.cluster.local:9090

Type: Prometheus

Loki:

URL: http://loki.monitoring.svc.cluster.local:3100

Type: Loki
