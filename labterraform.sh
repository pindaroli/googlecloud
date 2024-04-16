#!/bin/bash
R=europe-west4
Z=europe-west4-a
export PRJ=qwiklabs-gcp-01-19604e18d13b
export IST1ID=ist1
export IST2ID=ist2
export BUCKET_NAME=
export VPC_NAME=

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

variable "proj" {
  description = "The name of the project"
  type        = string
}

variable "environment" {
  description = "The environment (e.g., prod, dev, staging)"
  type        = string
  default     = "dev"
}
EOF

cat << EOF > ../main.tf
provider "google" {
  project     = "$PRJ"
  region      = "$REGION"
}
EOF

cd ~
terraform init

read -p "Task 1. Create the configuration files"

cat << EOF >> main.tf
module "instances" {
  source = "~/modules/instances"
  // inserisci qui le variabili del modulo
}

module "storage" {
  source = "~/modules/storage"
  // inserisci qui le variabili del modulo
}
EOF

cat << EOF > modules/instances/instances.tf
resource "google_compute_instance" "tf_instance_1" {
  name         = "tf-instance-1"
  machine_type = "e2-micro"
  zone         = var.zone

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

resource "google_compute_instance" "tf_instance_2" {
  name         = "tf-instance-2"
  machine_type = "e2-micro"
  zone         = var.zone

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

terraform import google_compute_instance.tf_instance_1 $PRJ/$ZONE/$IST1ID
terraform import google_compute_instance.tf_instance_2 $PRJ/$ZONE/$IST2ID

terraform apply

read -p "Import infrastructure"

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
    bucket  = "$BUCKET_NAME
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
    network_name = "$VPC_VPC_NAME"
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
