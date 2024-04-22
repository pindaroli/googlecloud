export REGION=us-east4
export ZONE=us-east4-a


gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE

gcloud compute networks create securenetwork --subnet-mode=custom
gcloud compute networks subnets create securenet-sub --network=securenetwork --region=$REGION \
      --range=172.16.0.0/24

gcloud compute firewall-rules create rdprule --direction=INGRESS --priority=1000 \
  --network=securenetwork --action=ALLOW --rules=tcp:3389 \
  --source-ranges=0.0.0.0/0  --target-tags=rdptag

gcloud compute instances create vm-securehost \
    --image-family windows-2016 \
    --image-project windows-cloud \
    --boot-disk-size 50GB \
    --network-interface network=securenetwork,subnet=securenet-sub,no-address \
    --network-interface network=default,no-address \
    --zone=$ZONE



gcloud compute instances create vm-bastionhost \
    --image-family windows-2016 \
    --image-project windows-cloud \
    --boot-disk-size 50GB \
    --tags=rdptag \
    --network-interface network=securenetwork,subnet=securenet-sub  \
    --network-interface network=default,no-address \
    --zone=$ZONE


gcloud compute reset-windows-password vm-bastionhost --user app_admin --zone $ZONE
gcloud compute reset-windows-password vm-securehost --user app_admin --zone $ZONE
