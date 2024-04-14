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

gcloud pubsub topics create myTopic
gcloud pubsub topics create Test1
gcloud pubsub topics create Test2
gcloud pubsub topics list
gcloud pubsub topics delete Test1
gcloud  pubsub subscriptions create --topic myTopic mySubscription
gcloud  pubsub subscriptions create --topic myTopic Test1
gcloud pubsub topics list-subscriptions myTopic
gcloud pubsub subscriptions delete Test1
gcloud pubsub topics publish myTopic --message "Hello"
gcloud pubsub topics publish myTopic --message "Publisher's name is <YOUR NAME>"
gcloud pubsub subscriptions pull mySubscription --auto-ack
gcloud pubsub subscriptions pull mySubscription --auto-ack --limit=3

sudo apt-get install -y virtualenv
python3 -m venv venv
source venv/bin/activate
pip install --upgrade google-cloud-pubsub
git clone https://github.com/googleapis/python-pubsub.git
echo $GOOGLE_CLOUD_PROJECT
python publisher.py $GOOGLE_CLOUD_PROJECT create MyTopic
python subscriber.py $GOOGLE_CLOUD_PROJECT create MyTopic MySub
python subscriber.py $GOOGLE_CLOUD_PROJECT list-in-project
python subscriber.py -h
gcloud pubsub topics publish MyTopic --message "Hello"
gcloud pubsub topics publish MyTopic --message "Publisher's name is <YOUR NAME>"
python subscriber.py $GOOGLE_CLOUD_PROJECT receive MySub


gcloud compute instances create \	vm-internal \
    --project=qwiklabs-gcp-04-d387c1ae4b9a \
    --zone=us-east4-c \
    --machine-type=e2-medium \
    --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=privatenet-us \
    --metadata=enable-oslogin=true \
    --maintenance-policy=MIGRATE \
    --provisioning-model=STANDARD \
    --service-account=78100645807-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --create-disk=auto-delete=yes,boot=yes,device-name=\ \
vm-internal,image=projects/debian-cloud/global/images/debian-11-bullseye-v20240312,mode=rw,size=10,type=projects/qwiklabs-gcp-04-d387c1ae4b9a/zones/us-east4-c/diskTypes/pd-balanced \
    --no-shielded-secure-boot \
    --no-shielded-vtpm \
    --no-shielded-integrity-monitoring \
    --labels=goog-ec-src=vm_add-gcloud \
    --reservation-affinity=any

    Chiarire IAP
    gcloud compute ssh vm-internal --zone us-east4-c --tunnel-through-iap
    gcloud compute ssh vm-internal --zone us-east4-c --tunnel-through-iap

    85PE(O7sbne$LCe passwinvmn

     sudo dmidecode -t 17 memoria installata
     nproc
     lscpu info sul cpu

     sudo mkfs.ext4 -F -E lazy_itable_init=0,\
lazy_journal_init=0,discard \
/dev/disk/by-id/google-minecraft-disk

sudo mount -o discard,defaults /dev/disk/by-id/google-minecraft-disk /home/minecraft

sudo wget https://launcher.mojang.com/v1/objects/d0d0fe2b1dc6ab4c65554cb734270872b72dadd6/server.jar

sudo apt-get install -y screen
sudo screen -S mcs java -Xmx1024M -Xms1024M -jar server.jar nogui
#to detach the screen terminal, press Ctrl+A, Ctrl+D
sudo screen -r mcs # to reattach the screen terminal
sudo screen -r -X stuff '/stop\n' # to stop the Minecraft server
#backup
#!/bin/bash
screen -r mcs -X stuff '/save-all\n/save-off\n'
/usr/bin/gcloud storage cp -R ${BASH_SOURCE%/*}/world gs://${YOUR_BUCKET_NAME}-minecraft-backup/$(date "+%Y%m%d-%H%M%S")-world
screen -r mcs -X stuff '/save-on\n'