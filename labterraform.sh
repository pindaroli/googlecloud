#!/bin/bash
R=us-central1
Z=us-central1-c
export PRJ=qwiklabs-gcp-00-dd1687b2224d
export IST1ID=759937300111188604
export IST2ID=4045485323322548860
export BUCKET_NAME=tf-bucket-284652
export VPC_NAME=tf-vpc-211009

gcloud config set compute/region $R && export REGION=$(gcloud config get compute/region) && echo $REGION
gcloud config set compute/zone $Z && export ZONE=$(gcloud config get compute/zone) && echo $ZONE

touch main.tf
touch variables.tf
mkdir modules
cd modules
mkdir instances
mkdir storage
touch instances/instances.tf
touch instances/variables.tf
touch instances/outputs.tf
touch storage/storage.tf
touch storage/variables.tf
touch storage/outputs.tf

cat << EOF > ../variables.tf
variable "region" {
  description = "The region where resources should be created"
  default     = "$REGION"
}

variable "zone" {
  description = "zone"
  type        = string
  default     = "$ZONE"
}

variable "prj" {
  description = "The name of the project"
  type        = string
  default    = "$PRJ"
}

variable "environment" {
  description = "The environment (e.g., prod, dev, staging)"
  type        = string
  default     = "dev"
}
EOF

cat << EOF > ../main.tf
provider "google" {
  version     = "<5.0"
  project     = "$PRJ"
  region      = "$REGION"
  zone        = "$ZONE"
}
EOF

cd ~
terraform init

read -p "Task 1. Create the configuration files"

cat << EOF >> main.tf
module "instances" {
  source = "./modules/instances"
  // inserisci qui le variabili del modulo
}

module "storage" {
  source = "./modules/storage"
  // inserisci qui le variabili del modulo
}
EOF
terraform init
cat << EOF > modules/instances/instances.tf
resource "google_compute_instance" "tf_instance-1" {
  name         = "tf-instance-1"
  machine_type = "e2-micro"
  zone         = "$ZONE"

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"

  }

  metadata_startup_script = "#!/bin/bash"
}

resource "google_compute_instance" "tf_instance-2" {
  name         = "tf-instance-2"
  machine_type = "e2-micro"
  zone         = "$ZONE"

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
  }

  metadata_startup_script = "#!/bin/bash"

}
EOF

terraform import module.instances.google_compute_instance.tf_instance-2 $IST2ID

terraform apply

read -p "task.2 Import infrastructure"

cat << EOF > modules/storage/storage.tf
resource "google_storage_bucket" "static-site" {
  name = "$BUCKET_NAME"
  location = "US"
  force_destroy = true
  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
  cors {
    origin          = ["http://image-store.com"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}
EOF

terraform apply

cat << EOF >> main.tf
terraform {
  backend "gcs" {
    bucket  = "$BUCKET_NAME"
    prefix  = "terraform/state"
  }
}
EOF

terraform init
read -p "Task 3. Configure a remote backend"

cat << EOF >> main.tf
module "vpc" {
    source  = "terraform-google-modules/network/google"
    version = "6.0.0"

    project_id   = "$PRJ"
    network_name = "$VPC_NAME"
    routing_mode = "GLOBAL"

    subnets = [
        {
            subnet_name           = "subnet-01"
            subnet_ip             = "10.10.10.0/24"
            subnet_region         = "$REGION"
        },
        {
            subnet_name           = "subnet-02"
            subnet_ip             = "10.10.20.0/24"
            subnet_region         = "$REGION"
            subnet_private_access = "true"
            subnet_flow_logs      = "true"
            description           = "This subnet has a description"
        }
    ]
}
EOF
read -p "Task 6. Use a module from the Registry"

cat << EOF >> main.tf
resource "google_compute_firewall" "default" {
  name    = "tf-firewall"
  network = "$VPC_NAME"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}
EOF

terraform apply

read -p "Task 7. Configure a firewall"
