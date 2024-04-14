touch instance.tf
resource "google_compute_instance" "terraform" {
  project      = "qwiklabs-gcp-03-ae637f60d521"
  name         = "terraform"
  machine_type = "e2-medium"
  zone         = "us-central1-f"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
}
terraform init
terraform plan -out pippo
terraform apply 

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {

  project = "qwiklabs-gcp-00-5e4da03a8f57"
  region  = "us-west1"
  zone    = "us-west1-b"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

student_04_310a39777ac8@cloudshell:~ (qwiklabs-gcp-00-5e4da03a8f57)$ terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # google_compute_network.vpc_network will be created
  + resource "google_compute_network" "vpc_network" {
      + auto_create_subnetworks         = true
      + delete_default_routes_on_create = false
      + gateway_ipv4                    = (known after apply)
      + id                              = (known after apply)
      + ipv4_range                      = (known after apply)
      + name                            = "terraform-network"
      + project                         = (known after apply)
      + routing_mode                    = (known after apply)
      + self_link                       = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

google_compute_network.vpc_network: Creating...
google_compute_network.vpc_network: Still creating... [10s elapsed]
google_compute_network.vpc_network: Still creating... [20s elapsed]
google_compute_network.vpc_network: Still creating... [30s elapsed]
google_compute_network.vpc_network: Still creating... [40s elapsed]
google_compute_network.vpc_network: Creation complete after 43s [id=projects/qwiklabs-gcp-00-5e4da03a8f57/global/networks/terraform-network]

terraform show
terraform destroy

terraform plan -out static_ip

terraform apply "static_ip"

git clone https://github.com/terraform-google-modules/terraform-google-network
cd terraform-google-network
git checkout tags/v6.0.1 -b v6.0.1

ggcloud config list --format 'value(core.project)'
qwiklabs-gcp-01-b5c890943362
cd ~
rm -rd terraform-google-network -f

#Creare un modulo
cd ~
touch main.tf
mkdir -p modules/gcs-static-website-bucket

cd modules/gcs-static-website-bucket
touch website.tf variables.tf outputs.tf

tee -a README.md <<EOF
# GCS static website bucket

This module provisions Cloud Storage buckets configured for static website hosting.
EOF

tee -a LICENSE <<EOF
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
EOF

cd ~
curl https://raw.githubusercontent.com/hashicorp/learn-terraform-modules/master/modules/aws-s3-static-website-bucket/www/index.html > index.html
curl https://raw.githubusercontent.com/hashicorp/learn-terraform-modules/blob/master/modules/aws-s3-static-website-bucket/www/error.html > error.html

gsutil cp *.html gs://YOUR-BUCKET-NAME
#per recuperar id del proggetto
gcloud config list --format 'value(core.project)'
#se cambi il provider
terraform init -migrate-state

terraform import docker_container.web $(docker inspect -f {{.ID}} hashicorp-learn)