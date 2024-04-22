R=us-east1
export ZONE=us-west1-c
export PRJ=qwiklabs-gcp-04-05805755962a
export BCK=$PRJ-olibk


cat << EOF > install-web.sh
#!/bin/bash
      apt-get update
      apt-get install apache2 -y
      service apache2 restart
      echo "
<h3>Web Server: www1</h3>" | tee /var/www/html/index.html
EOF
gsutil mb gs://$BCK/
gsutil cp install-web.sh gs://$BCK/

gcloud compute firewall-rules create www-firewall-network-lb \
    --target-tags network-lb-tag --allow tcp:80



  gcloud compute instances create www \
    --zone=$ZONE \
    --tags=network-lb-tag \
    --machine-type=e2-small \
    --image-family=debian-11 \
    --image-project=debian-cloud \
    --scopes storage-ro \
    --metadata=startup-script-url=https://storage.googleapis.com/$BCK/install-web.sh

gcloud compute instances list
curl http://34.145.103.10