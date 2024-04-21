gcloud auth list
gcloud config list project
gcloud config set compute/region us-east1
gcloud compute project-info describe --project $(gcloud config get-value project)
gcloud config --help
gcloud config list --all
gcloud compute instances list
gcloud compute instances list --filter="name=('gcelab2')"
gcloud compute firewall-rules list
gcloud compute firewall-rules list --filter="network='default'"
gcloud compute firewall-rules list --filter="NETWORK:'default' AND ALLOW:'icmp'"
gcloud compute ssh gcelab2 --zone $ZONE
gcloud compute instances add-tags gcelab2 --tags http-server,https-server
gcloud compute firewall-rules create default-allow-http --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server
gcloud compute firewall-rules list --filter=ALLOW:'80'
curl http://$(gcloud compute instances list --filter=name:gcelab2 --format='value(EXTERNAL_IP)')
gcloud logging logs list
gcloud logging logs list --filter="compute"
gcloud logging read "resource.type=gce_instance" --limit 5
gcloud logging read "resource.type=gce_instance AND labels.instance_name='gcelab2'" --limit 5

gcloud compute networks create privatenet --subnet-mode=custom
gcloud compute networks subnets create privatesubnet-us --network=privatenet --region=us-east4 --range=172.16.0.0/24
gcloud compute networks subnets create privatesubnet-eu --network=privatenet --region=europe-west1 --range=172.20.0.0/20
gcloud compute networks list
gcloud compute networks subnets list --sort-by=NETWORK
POST https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-03-f8dc44dbd06e/global/firewalls
{
  "kind": "compute#firewall",
  "name": "managementnet-allow-icmp-ssh-rdp",
  "selfLink": "projects/qwiklabs-gcp-03-f8dc44dbd06e/global/firewalls/managementnet-allow-icmp-ssh-rdp",
  "network": "projects/qwiklabs-gcp-03-f8dc44dbd06e/global/networks/managementnet",
  "direction": "INGRESS",
  "priority": 1000,
  "allowed": [
    {
      "IPProtocol": "tcp",
      "ports": [
        "22",
        "3389"
      ]
    },
    {
      "IPProtocol": "icmp"
    }
  ],
  "sourceRanges": [
    "0.0.0.0/0"
  ]
}
gcloud compute firewall-rules create privatenet-allow-icmp-ssh-rdp --direction=INGRESS --priority=1000 --network=privatenet --action=ALLOW --rules=icmp,tcp:22,tcp:3389 --source-ranges=0.0.0.0/0
gcloud compute instances create privatenet-us-vm --zone=us-east4-c --machine-type=e2-micro --subnet=privatesubnet-us
gcloud compute instances list --sort-by=ZONE


gcloud compute forwarding-rules describe www-rule --region us-east1
IPADDRESS=$(gcloud compute forwarding-rules describe www-rule --region us-east1 --format="json" | jq -r .IPAddress)

while true; do curl -m1 $IPADDRESS; done

gcloud compute instance-templates create lb-backend-template \
   --region=us-east1 \
   --network=default \
   --subnet=default \
   --tags=allow-health-check \
   --machine-type=e2-medium \
   --image-family=debian-11 \
   --image-project=debian-cloud \
   --metadata=startup-script='#!/bin/bash
     apt-get update
     apt-get install apache2 -y
     a2ensite default-ssl
     a2enmod ssl
     vm_hostname="$(curl -H "Metadata-Flavor:Google" \
     http://169.254.169.254/computeMetadata/v1/instance/name)"
     echo "Page served from: $vm_hostname" | \
     tee /var/www/html/index.html
     systemctl restart apache2'

     gcloud compute instance-groups managed create lb-backend-group \
   --template=lb-backend-template --size=2 --zone=us-east1-c

   gcloud compute firewall-rules create fw-allow-health-check \
  --network=default \
  --action=allow \
  --direction=ingress \
  --source-ranges=130.211.0.0/22,35.191.0.0/16 \
  --target-tags=allow-health-check \
  --rules=tcp:80
  gcloud compute addresses create lb-ipv4-1 \
  --ip-version=IPV4 \
  --global
  gcloud compute addresses describe lb-ipv4-1 \
  --format="get(address)" \
  --global
  gcloud compute health-checks create http http-basic-check \
  --port 80
  gcloud compute backend-services create web-backend-service \
  --protocol=HTTP \
  --port-name=http \
  --health-checks=http-basic-check \
  --global
  gcloud compute backend-services add-backend web-backend-service \
  --instance-group=lb-backend-group \
  --instance-group-zone=us-east1-c \
  --global
  gcloud compute url-maps create web-map-http \
    --default-service web-backend-service

gcloud compute target-http-proxies create http-lb-proxy \
    --url-map web-map-http
gcloud compute forwarding-rules create http-content-rule \
   --address=lb-ipv4-1\
   --global \
   --target-http-proxy=http-lb-proxy \
   --ports=80

gsutil mb gs://$DEVSHELL_PROJECT_ID
gsutil ls
echo "Hello World!" > sample.txt
gsutil cp sample.txt gs://$DEVSHELL_PROJECT_ID
gsutil ls gs://$DEVSHELL_PROJECT_ID
gcloud compute networks create mynetwork --subnet-mode=auto
gcloud compute instances create default-us-vm \
--zone=us-east1-c --network=mynetwork \
--machine-type=e2-medium
gsutil rm -r gs://$DEVSHELL_PROJECT_ID

logName=("projects/qwiklabs-gcp-00-dd3325549569/logs/cloudaudit.googleapis.com%2Factivity" OR "projects/qwiklabs-gcp-00-dd3325549569/logs/cloudaudit.googleapis.com%2Fdata_access" OR "projects/qwiklabs-gcp-00-dd3325549569/logs/cloudaudit.googleapis.com%2Fsystem_event")
gcloud logging read \
"logName=projects/$DEVSHELL_PROJECT_ID/logs/cloudaudit.googleapis.com%2Fdata_access"