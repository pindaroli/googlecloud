export zone=us-west1-b
export kname=onlineboutique-cluster-197
export prj=qwiklabs-gcp-02-9d00a4cb2f57
export poolname=optimized-pool-6274
export maxreplicas=12

#Task 1. Create a cluster and deploy your app
gcloud config set compute/zone $zone

gcloud container clusters create $kname \
--zone $zone \
--num-nodes 2 \
--machine-type e2-standard-2 \
--release-channel rapid \
--project $prj

kubectl create namespace dev
kubectl create namespace prod

kubectl config set-context --current --namespace dev

git clone https://github.com/GoogleCloudPlatform/microservices-demo.git &&
cd microservices-demo && kubectl apply -f ./release/kubernetes-manifests.yaml --namespace dev

kubectl get svc -w --namespace dev
#35.205.226.178, 34.145.117.58

# non va gcloud compute addresses describe frontend-external --zone=$zone --format="get(address)"
kubectl config set-context --current --namespace dev

#Task 2. Migrate to an optimized node pool
gcloud container node-pools create $poolname \
--cluster=$kname \
--zone=$zone \
--machine-type=custom-2-3584 \
--num-nodes=2

#kubectl get nodes -l cloud.google.com/gke-nodepool=default-pool -o name | xargs -I {} kubectl cordon {}
for node in $(kubectl get nodes -l cloud.google.com/gke-nodepool=default-pool -o=name); do
  kubectl cordon "$node";
done

#kubectl get nodes -l cloud.google.com/gke-nodepool=default-pool -o name | xargs -I {} kubectl drain {} --force --ignore-daemonsets --delete-local-data --timeout=30s
for node in $(kubectl get nodes -l cloud.google.com/gke-nodepool=default-pool -o=name); do
  kubectl drain --force --ignore-daemonsets --delete-local-data --grace-period=10 "$node";
done

# per controllare
kubectl get pods -o=wide --namespace dev


gcloud container node-pools delete default-pool \
--cluster=$kname \
--zone=$zone

#TASK3 #fare aggironamenti a mano

apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: onlineboutique-frontend-pdb
  namespace: dev
spec:
  minAvailable: 1
  selector:
    matchLabels:
      app: frontend

#alternativa
kubectl create poddisruptionbudget onlineboutique-frontend-pdb \
--selector app=frontend --min-available 1  --namespace dev

#like a PRO
KUBE_EDITOR="nano -c" kubectl edit deployment/frontend --namespace dev



apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: frontend-hpa
  namespace: dev
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: frontend  # adjust to match the name of your deployment
  minReplicas: 1
  maxReplicas: 12  # adjust to match your maximum replica count
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50  # adjust to match your target CPU percentage
# in alternativa
kubectl autoscale deployment frontend --cpu-percent=50 \
   --min=1 --max=12 --namespace dev

kubectl get hpa --namespace dev

gcloud beta container clusters update $kname --enable-autoscaling \
--min-nodes 1 --max-nodes 6 \
--zone $zone 


kubectl exec $(kubectl get pod --namespace=dev | grep 'loadgenerator' | cut -f1 -d ' ') -it --namespace=dev -- bash -c 'export USERS=8000; locust --host="http://34.145.117.58" --headless -u "8000" 2>&1'