#!/bin/bash
R=us-east1
Z=us-east1-b
export NOMESERVER=nucleus-jumphost-845
export MYNAMEDPORT=http:80
export FWRULE=accept-tcp-rule-373

gcloud config set compute/region $R && export REGION=$(gcloud config get compute/region) && echo $REGION
gcloud config set compute/zone $Z && export ZONE=$(gcloud config get compute/zone) && echo $ZONE

gcloud compute instances create $NOMESERVER --machine-type e2-micro --zone $ZONE
read -p "Press enter to continue"



# create an instance template
cat << EOF > startup.sh
#! /bin/bash
apt-get update
apt-get install -y nginx
service nginx start
sed -i -- 's/nginx/Google Cloud Platform - '"\$HOSTNAME"'/' /var/www/html/index.nginx-debian.html
EOF

#Create an instance template. Don't use the default machine type. Make sure you specify e2-medium as the machine type.
gcloud compute instance-templates create nginx-template  \
   --region=$REGION \
   --network=default \
   --subnet=default \
   --tags=allow-health-check \
   --machine-type=e2-medium \
   --metadata-from-file startup-script=startup.sh
read -p "Press enter to continue"

# Create a managed instance group based on the template.
gcloud compute instance-groups managed create rocco-instance-group --template=nginx-template --size=2 --zone=$ZONE
gcloud compute instances list
read -p "Press enter to continue"

#Create name port for instances
gcloud compute instance-groups set-named-ports rocco-instance-group --named-ports $MYNAMEDPORT --zone $ZONE

#Create a firewall rule named as Firewall rule to allow traffic (80/tcp). "allow-healt-check permette di agganciarla alle istanze managed
gcloud compute firewall-rules create $FWRULE \
  --network=default \
  --action=allow \
  --direction=ingress \
  --source-ranges=130.211.0.0/22,35.191.0.0/16 \
  --target-tags=allow-health-check \
  --rules=tcp:80
read -p "Press enter to continue"

#Create a backend service and add your instance group as the backend to the backend service group with named port (http:80).

gcloud compute health-checks create http http-basic-check \
  --port 80
gcloud compute backend-services create web-backend-service \
  --protocol=HTTP \
  --port-name=http \
  --health-checks=http-basic-check \
  --global
read -p "Press enter to continue"

gcloud compute backend-services add-backend web-backend-service \
  --instance-group=rocco-instance-group \
  --instance-group-zone=$ZONE \
  --global
read -p "Press enter to continue"

#Create a URL map, and target the HTTP proxy to route the incoming requests to the default backend service.
gcloud compute url-maps create web-map-http \
    --default-service web-backend-service
read -p "Press enter to continue"

#Create a target HTTP proxy to route requests to your URL map
gcloud compute target-http-proxies create http-lb-proxy \
    --url-map web-map-http
read -p "Press enter to continue"

#Create external ip address and forwarding rule.
gcloud compute addresses create lb-ipv4-1 \
  --ip-version=IPV4 \
  --global
read -p "Press enter to continue"

export IP=$(gcloud compute addresses describe lb-ipv4-1 --format="get(address)" --global)

gcloud compute forwarding-rules create http-content-rule \
   --address=lb-ipv4-1\
   --global \
   --target-http-proxy=http-lb-proxy \
   --ports=80

echo "IP address is $IP"
exit 
### soluzione del professore
gcloud compute instance-templates create nucleus-instance-template-1 --region=$REGION --network=default --subnet=default --tags=allow-health-check --machine-type=e2-medium --image-family=debian-11 --image-project=debian-cloud --metadata-from-file=startup-script=startup.sh
gcloud compute instance-groups managed create nucleus-instance-group-1 --template=nucleus-instance-template-1 --size=2 --zone=$ZONE
gcloud compute instance-groups set-named-ports nucleus-instance-group-1 --named-ports http:80 --zone $ZONE
gcloud compute firewall-rules create $FWR --network=default --action=allow --direction=ingress --source-ranges=130.211.0.0/22,35.191.0.0/16 --target-tags=allow-health-check --rules=tcp:80
gcloud compute addresses create nucleus-ip-address-v4-1 --ip-version=ipv4 --global
export IP=$(gcloud compute addresses describe nucleus-ip-address-v4-1 --format="get(address)" --global)
gcloud compute health-checks create http nucleus-http-basic-check-1 --port 80
gcloud compute backend-services create nucleus-backend-service-1 --protocol=HTTP --port-name=http --health-checks=nucleus-http-basic-check-1 --global
gcloud compute backend-services add-backend nucleus-backend-service-1 --instance-group=nucleus-instance-group-1 --instance-group-zone=$ZONE --global
gcloud compute url-maps create nucleus-url-map-1 --default-service nucleus-backend-service-1
gcloud compute target-http-proxies create nucleus-target-http-proxy-1 --url-map nucleus-url-map-1
gcloud compute forwarding-rules create nucleus-forwarding-rule --address=nucleus-ip-address-v4-1 --global --target-http-proxy=nucleus-target-http-proxy-1 --ports=80

