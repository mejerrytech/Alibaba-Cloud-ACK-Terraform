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


## 🚀 Setup & Deployment

### 1. Clone the Repository

git clone https://github.com/your-org/Alibaba-Cloud-ACK-Terraform.git
cd Alibaba-Cloud-ACK-Terraform


### 2. Initialize Terraform

terraform init


### 3. Plan Infrastructure


terraform plan


### 4. Apply Infrastructure (Create ACK Cluster)

terraform apply


### 5. Get the Kubeconfig from Alibaba ACK Console

1. **Go to Alibaba Cloud ACK Console**
2. **Navigate to your cluster → Cluster Information**
3. **Click "Get Kubeconfig"**
4. **Choose Public Access or Private based on your setup**
5. **Copy the kubeconfig content**

### 6. Create a Local Kubeconfig File

In the root Terraform directory:

touch kubeconfig.yaml


Paste the copied content into `kubeconfig.yaml`.

### 7. Set Environment Variable (Optional)

Export your kubeconfig so that Terraform and kubectl can access it:


### 8. Run Terraform Again to Deploy Monitoring Stack

terraform apply


## ✅ Output

After successful deployment, the Terraform output will show:

- **Grafana endpoint URL:** `http://<public-ip>:3000`
- **Default credentials:** `admin` / `admin` (you can customize later)

## 🔍 Prometheus & Loki Internal URLs

These URLs will be used inside Grafana as data sources:

- **Prometheus:** `http://prometheus.monitoring.svc.cluster.local:9090`
- **Loki:** `http://loki.monitoring.svc.cluster.local:3100`

## 📌 Final Steps in Grafana

1. **Open the Grafana dashboard in your browser**
2. **Go to Configuration → Data Sources**
3. **Add the following:**
   - **Prometheus:**
     - **URL:** `http://prometheus.monitoring.svc.cluster.local:9090`
     - **Type:** Prometheus
   - **Loki:**
     - **URL:** `http://loki.monitoring.svc.cluster.local:3100`
     - **Type:** Loki


