gsutil -m cp -r gs://spls/gsp766/gke-qwiklab ~
cd ~/gke-qwiklab
export ZONE=us-west1-c
#This command retrieves the access credentials for multi-tenant-cluster and automatically configures kubectl, the Kubernetes command-line tool. This means that any subsequent kubectl commands you run will interact with multi-tenant-cluster.
gcloud config set compute/zone ${ZONE} && gcloud container clusters get-credentials multi-tenant-cluster
kubectl get namespace
kubectl api-resources --namespaced=true
kubectl get services --namespace=kube-system
kubectl create namespace team-a && \
kubectl create namespace team-b
kubectl run app-server --image=centos --namespace=team-a -- sleep infinity && \
kubectl run app-server --image=centos --namespace=team-b -- sleep infinity
kubectl get pods -A
kubectl describe pod app-server --namespace=team-a
kubectl config set-context --current --namespace=team-a
#Note: To grant IAM roles in a project, you'll need the Project IAM Admin role assigned. This is already set up in your Qwiklabs temporary account.
gcloud projects add-iam-policy-binding ${GOOGLE_CLOUD_PROJECT} \
--member=serviceAccount:team-a-dev@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com  \
--role=roles/container.clusterViewer
kubectl create role pod-reader \
--resource=pods --verb=watch --verb=get --verb=list
# apiVersion: rbac.authorization.k8s.io/v1
# kind: Role
# metadata:
#   namespace: team-a
#   name: developer
# rules:
# - apiGroups: [""]
#   resources: ["pods", "services", "serviceaccounts"]
#   verbs: ["update", "create", "delete", "get", "watch", "list"]
# - apiGroups: ["apps"]
#   resources: ["deployments"]
#   verbs: ["update", "create", "delete", "get", "watch", "list"]
kubectl create -f developer-role.yaml
#Create a role binding between the team-a-developers serviceaccount and the developer-role:
kubectl create rolebinding team-a-developers \
--role=developer --user=team-a-dev@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com
#Download the service account keys used to impersonate the service account:
gcloud iam service-accounts keys create /tmp/key.json --iam-account team-a-dev@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com
#in un altro terminale: Here, run the following to activate the service account. This will allow you to run the commands as the account:
gcloud auth activate-service-account  --key-file=/tmp/key.json
export ZONE=us-west1-c
gcloud container clusters get-credentials multi-tenant-cluster --zone ${ZONE} --project ${GOOGLE_CLOUD_PROJECT}
export ZONE=us-west1-c
gcloud container clusters get-credentials multi-tenant-cluster --zone ${ZONE} --project ${GOOGLE_CLOUD_PROJECT}
kubectl get pods --namespace=team-a
#questo non funziona perche non hai i privileggi
kubectl get pods --namespace=team-b
#torniamo al primo terminale
#Renew the cluster credentials and reset your context to the team-a namespace:
export ZONE=us-west1-c
gcloud container clusters get-credentials multi-tenant-cluster --zone ${ZONE} --project ${GOOGLE_CLOUD_PROJECT}
#set quta pod 2
kubectl create quota test-quota \
--hard=count/pods=2,count/services.loadbalancers=1 --namespace=team-a
kubectl run app-server-3 --image=centos --namespace=team-a -- sleep infinity
kubectl describe quota test-quota --namespace=team-a
#update test-quota
export KUBE_EDITOR="nano"
kubectl edit quotapiVersion: v1
# kind: ResourceQuota
# metadata:
#   name: cpu-mem-quota
#   namespace: team-a
# spec:
#   hard:
#     limits.cpu: "4"
#     limits.memory: "12Gi"
#     requests.cpu: "2"
#     requests.memory: "8Gia test-quota --namespace=team-a
kubectl create -f cpu-mem-quota.yaml
# apiVersion: v1
# kind: Pod
# metadata:
#   name: cpu-mem-demo
#   namespace: team-a
# spec:
#   containers:
#   - name: cpu-mem-demo-ctr
#     image: nginx
#     resources:
#       requests:
#         cpu: "100m"
#         memory: "128Mi"
#       limits:
#         cpu: "400m"
#         memory: "512Mi"
kubectl create -f cpu-mem-demo-pod.yaml --namespace=team-a
kubectl describe quota cpu-mem-quota --namespace=team-a
#Run the following to enable GKE usage metering on the cluster and specify the dataset cluster_dataset:
export ZONE=us-east1-c
gcloud container clusters \
  update multi-tenant-cluster --zone ${ZONE} \
  --resource-usage-bigquery-dataset cluster_dataset
#https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-usage-metering#create_the_cost_breakdown_table

export GCP_BILLING_EXPORT_TABLE_FULL_PATH=${GOOGLE_CLOUD_PROJECT}.billing_dataset.gcp_billing_export_v1_xxxx
export USAGE_METERING_DATASET_ID=cluster_dataset
export COST_BREAKDOWN_TABLE_ID=usage_metering_cost_breakdown

export USAGE_METERING_QUERY_TEMPLATE=~/gke-qwiklab/usage_metering_query_template.sql
export USAGE_METERING_QUERY=cost_breakdown_query.sql
export USAGE_METERING_START_DATE=2020-10-26

sed \
-e "s/\${fullGCPBillingExportTableID}/$GCP_BILLING_EXPORT_TABLE_FULL_PATH/" \
-e "s/\${projectID}/$GOOGLE_CLOUD_PROJECT/" \
-e "s/\${datasetID}/$USAGE_METERING_DATASET_ID/" \
-e "s/\${startDate}/$USAGE_METERING_START_DATE/" \
"$USAGE_METERING_QUERY_TEMPLATE" \
> "$USAGE_METERING_QUERY"


bq query \
--project_id=$GOOGLE_CLOUD_PROJECT \
--use_legacy_sql=false \
--destination_table=$USAGE_METERING_DATASET_ID.$COST_BREAKDOWN_TABLE_ID \
--schedule='every 24 hours' \
--display_name="GKE Usage Metering Cost Breakdown Scheduled Query" \
--replace=true \
"$(cat $USAGE_METERING_QUERY)"

CmxfU1ZJX0VJZnozLVhNNTRVREdBa2lQMDFCUlVSSVpsOXhZVFIzTlU5RVRWTmhTVUpTV0dONGFtZGhhVUZGTTNCdGIybzFNM1UyU2xWNVRFUlNabTVsTTA4d05VaERRelJUYUZsTGJERkhid18