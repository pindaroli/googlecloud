#!/bin/bash
R=us-east1
Z=us-east1-b
export BUCKET_NAME=
export TOPIC_NAME
export FUN_NAME=
export PROJECT_ID=
export CLOUD_STORAGE=

gcloud config set compute/region $R && export REGION=$(gcloud config get compute/region) && echo $REGION
gcloud config set compute/zone $Z && export ZONE=$(gcloud config get compute/zone) && echo $ZONE



#Create a Cloud Function called Cloud Function Name
mkdir $FUN_NAME
cd $FUN_NAME

#Task 1. Create a bucket
gsutil mb gs://$BUCKET_NAME
read -p "Press enter to continue"

#Task 2. Create a Pub/Sub topic
gcloud pubsub topics create $TOPIC_NAME

#Task 3. Create the thumbnail Cloud Function
cat << EOF > index.js
const functions = require('@google-cloud/functions-framework');
const crc32 = require("fast-crc32c");
const { Storage } = require('@google-cloud/storage');
const gcs = new Storage();
const { PubSub } = require('@google-cloud/pubsub');
const imagemagick = require("imagemagick-stream");

functions.cloudEvent('', cloudEvent => {
  const event = cloudEvent.data;

  console.log(`Event: ${event}`);
  console.log(`Hello ${event.bucket}`);

  const fileName = event.name;
  const bucketName = event.bucket;
  const size = "64x64"
  const bucket = gcs.bucket(bucketName);
  const topicName = "";
  const pubsub = new PubSub();
  if ( fileName.search("64x64_thumbnail") == -1 ){
    // doesn't have a thumbnail, get the filename extension
    var filename_split = fileName.split('.');
    var filename_ext = filename_split[filename_split.length - 1];
    var filename_without_ext = fileName.substring(0, fileName.length - filename_ext.length );
    if (filename_ext.toLowerCase() == 'png' || filename_ext.toLowerCase() == 'jpg'){
      // only support png and jpg at this point
      console.log(`Processing Original: gs://${bucketName}/${fileName}`);
      const gcsObject = bucket.file(fileName);
      let newFilename = filename_without_ext + size + '_thumbnail.' + filename_ext;
      let gcsNewObject = bucket.file(newFilename);
      let srcStream = gcsObject.createReadStream();
      let dstStream = gcsNewObject.createWriteStream();
      let resize = imagemagick().resize(size).quality(90);
      srcStream.pipe(resize).pipe(dstStream);
      return new Promise((resolve, reject) => {
        dstStream
          .on("error", (err) => {
            console.log(`Error: ${err}`);
            reject(err);
          })
          .on("finish", () => {
            console.log(`Success: ${fileName} → ${newFilename}`);
              // set the content-type
              gcsNewObject.setMetadata(
              {
                contentType: 'image/'+ filename_ext.toLowerCase()
              }, function(err, apiResponse) {});
              pubsub
                .topic(topicName)
                .publisher()
                .publish(Buffer.from(newFilename))
                .then(messageId => {
                  console.log(`Message ${messageId} published.`);
                })
                .catch(err => {
                  console.error('ERROR:', err);
                });
          });
      });
    }
    else {
      console.log(`gs://${bucketName}/${fileName} is not an image I can handle`);
    }
  }
  else {
    console.log(`gs://${bucketName}/${fileName} already has a thumbnail`);
  }
});
EOF

cat << EOF > package.json:
{
  "name": "thumbnails",
  "version": "1.0.0",
  "description": "Create Thumbnail of uploaded image",
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {
    "@google-cloud/functions-framework": "^3.0.0",
    "@google-cloud/pubsub": "^2.0.0",
    "@google-cloud/storage": "^5.0.0",
    "fast-crc32c": "1.0.4",
    "imagemagick-stream": "4.1.1"
  },
  "devDependencies": {},
  "engines": {
    "node": ">=4.3.2"
  }
}
EOF
read -p "Press enter to continue"

#enable api
gcloud services enable cloudfunctions.googleapis.com
gcloud services enable @google-cloud/functions-framework
gcloud services enable @google-cloud/storage
gcloud services enable @google-cloud/pubsub


# creo il contenitore per la funzione
gsutil mb -p $PROJECT_ID gs://$BUCKET_NAME

# 
gcloud functions deploy $FUN_NAME \
  --stage-bucket $BUCKET_NAME \
  --trigger-bucket $BUCKET_NAME \
  --runtime nodejs20

gcloud projects add-iam-policy-binding $PROJECT_ID \
--member="serviceAccount:$PROJECT_ID@appspot.gserviceaccount.com" \
--role="roles/artifactregistry.reader"

gcloud functions describe $FUN_NAME
read -p "Press enter to continue"

#Task 4. Test the Infrastructure
wget https://storage.googleapis.com/cloud-training/gsp315/map.jpg
gsutil cp map.jpg gs://$BUCKET_NAME/

