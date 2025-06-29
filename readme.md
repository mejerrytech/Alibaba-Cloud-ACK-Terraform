To start with Terraform script first run source .env
After that Run the terraform init, plan and apply
It will create a ACK cluster, after that go to the Alibaba Ack console, get the Public Kubeconfig.yaml and copy that from it,
Create a kubeconfig.yaml file in terraform directory and copy the ACK kubeconfig content in it and after that run terraform apply
in the end output will show the grafana end point with username and password with promethus and loki local url whoch need to be add on the grafana data source.