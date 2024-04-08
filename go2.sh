#!/bin/bash
gcloud compute networks create privatenet --subnet-mode=custom
gcloud compute networks subnets create privatesubnet-eu --network=privatenet --region=europe-west1 --range=172.20.0.0/20
gcloud compute networks list
gcloud compute networks subnets list --sort-by=NETWORK
gcloud compute firewall-rules create privatenet-allow-icmp-ssh-rdp --direction=INGRESS --priority=1000 --network=privatenet --action=ALLOW --rules=icmp,tcp:22,tcp:3389 --source-ranges=0.0.0.0/0
gcloud compute firewall-rules list --sort-by=NETWORK
gcloud compute instances create managementnet-us-vm --project=qwiklabs-gcp-02-f294b371fc19 --zone=us-central1-a --machine-type=e2-micro --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=managementsubnet-us --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --service-account=734349048669-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --create-disk=auto-delete=yes,boot=yes,device-name=managementnet-us-vm,image=projects/debian-cloud/global/images/debian-12-bookworm-v20240312,mode=rw,size=10,type=projects/qwiklabs-gcp-02-f294b371fc19/zones/us-central1-a/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any

gcloud compute instances list --sort-by=ZONE

# Per gestire bucket
gcloud config list project
gsutil mb gs://<YOUR-BUCKET-NAME>
gsutil cp ada.jpg gs://YOUR-BUCKET-NAME
gsutil cp -r gs://YOUR-BUCKET-NAME/ada.jpg .
gsutil ls gs://YOUR-BUCKET-NAME
gsutil ls -l gs://YOUR-BUCKET-NAME/ada.jpg
gsutil acl ch -u AllUsers:R gs://YOUR-BUCKET-NAME/ada.jpg
gsutil acl ch -d AllUsers gs://YOUR-BUCKET-NAME/ada.jpg
gsutil rm gs://YOUR-BUCKET-NAME/ada.jpg

## agente di monitoring
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
sudo bash add-google-cloud-ops-agent-repo.sh --also-install
sudo systemctl status google-cloud-ops-agent"*"

#Google function
mkdir gcf_hello_world
cd gcf_hello_world
nano index.js
/**
* Background Cloud Function to be triggered by Pub/Sub.
* This function is exported by index.js, and executed when
* the trigger topic receives a message.
*
* @param {object} data The event payload.
* @param {object} context The event metadata.
*/
exports.helloWorld = (data, context) => {
const pubSubMessage = data;
const name = pubSubMessage.data
    ? Buffer.from(pubSubMessage.data, 'base64').toString() : "Hello World";

console.log(`My Cloud Function: ${name}`);
};

gsutil mb -p [PROJECT_ID] gs://[BUCKET_NAME]
gsutil mb -p qwiklabs-gcp-00-3d9d47031650 gs://qwiklabs-gcp-00-3d9d47031650
gcloud services disable cloudfunctions.googleapis.com
gcloud projects add-iam-policy-binding qwiklabs-gcp-00-3d9d47031650 \
--member="serviceAccount:qwiklabs-gcp-00-3d9d47031650@appspot.gserviceaccount.com" \
--role="roles/artifactregistry.reader"
gcloud functions deploy helloWorld \
  --stage-bucket qwiklabs-gcp-00-3d9d47031650 \
  --trigger-topic hello_world \
  --runtime nodejs20
gcloud functions describe helloWorld
DATA=$(printf 'Hello World!'|base64) && gcloud functions call helloWorld --data '{"data":"'$DATA'"}'
gcloud functions logs read helloWorld

gcloud pubsub subscriptions pull --auto-ack MySub