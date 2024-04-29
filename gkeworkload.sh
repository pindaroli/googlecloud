gcloud config set compute/zone europe-west4-c
gcloud container clusters create test-cluster --num-nodes=3  --enable-ip-alias
cat << EOF > gb_frontend_pod.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: gb-frontend
  name: gb-frontend
spec:
    containers:
    - name: gb-frontend
      image: gcr.io/google-samples/gb-frontend-amd64:v5
      resources:
        requests:
          cpu: 100m
          memory: 256Mi
      ports:
      - containerPort: 80
EOF
kubectl apply -f gb_frontend_pod.yaml
#In order to take advantage of container-native load balancing, the VPC-native setting must be enabled on the cluster. This was indicated when you created the cluster and included the --enable-ip-alias flag.
cat << EOF > gb_frontend_cluster_ip.yaml
apiVersion: v1
kind: Service
metadata:
  name: gb-frontend-svc
  annotations:
    cloud.google.com/neg: '{"ingress": true}'
spec:
  type: ClusterIP
  selector:
    app: gb-frontend
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
EOF
#Next, create an ingress for your application:
kubectl apply -f gb_frontend_cluster_ip.yaml
cat << EOF > gb_frontend_ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: gb-frontend-ingress
spec:
  defaultBackend:
    service:
      name: gb-frontend-svc
      port:
        number: 80
EOF
kubectl apply -f gb_frontend_ingress.yaml
BACKEND_SERVICE=$(gcloud compute backend-services list | grep NAME | cut -d ' ' -f2)
gcloud compute backend-services get-health $BACKEND_SERVICE --global
kubectl get ingress gb-frontend-ingress
gsutil -m cp -r gs://spls/gsp769/locust-image .
gcloud builds submit \
    --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/locust-tasks:latest locust-image
gcloud container images list
gsutil cp gs://spls/gsp769/locust_deploy_v2.yaml .
sed 's/${GOOGLE_CLOUD_PROJECT}/'$GOOGLE_CLOUD_PROJECT'/g' locust_deploy_v2.yaml | kubectl apply -f -

apiVersion: apps/v1
kind: Deployment
metadata:
  name: locust-main
  labels:
    name: locust-main
spec:
  replicas: 1
  selector:
    matchLabels:
      app: locust-main
  template:
    metadata:
      labels:
        app: locust-main
    spec:
      containers:
        - name: locust-main
          image: gcr.io/${GOOGLE_CLOUD_PROJECT}/locust-tasks:latest
          env:
            - name: LOCUST_MODE
              value: main
            - name: TARGET_HOST
              value: http://gb-frontend-svc
          ports:
            - name: loc-main-web
              containerPort: 8089
              protocol: TCP
            - name: loc-main-p1
              containerPort: 5557
              protocol: TCP
            - name: loc-main-p2
              containerPort: 5558
              protocol: TCP
---
apiVersion: v1
kind: Service
metadata:
  name: locust-main
  labels:
    app: locust-main
spec:
  type: LoadBalancer
  ports:
    - port: 8089
      targetPort: loc-main-web
      protocol: TCP
      name: loc-main-web
    - port: 5557
      targetPort: loc-main-p1
      protocol: TCP
      name: loc-main-p1
    - port: 5558
      targetPort: loc-main-p2
      protocol: TCP
      name: loc-main-p2
  selector:
    app: locust-main
---
apiVersion: "apps/v1"
kind: "Deployment"
metadata:
  name: locust-worker
  labels:
    name: locust-worker
spec:
  replicas: 5
  selector:
    matchLabels:
      app: locust-worker
  template:
    metadata:
      labels:
        app: locust-worker
    spec:
      containers:
        - name: locust-worker
          image: gcr.io/${GOOGLE_CLOUD_PROJECT}/locust-tasks:latest
          env:
            - name: LOCUST_MODE
              value: worker
            - name: LOCUST_MAIN
              value: locust-main
            - name: TARGET_HOST
              value: http://gb-frontend-svc
kubectl get service locust-main
cat << EOF > liveness-demo.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    demo: liveness-probe
  name: liveness-demo-pod
spec:
  containers:
  - name: liveness-demo-pod
    image: centos
    args:
    - /bin/sh
    - -c
    - touch /tmp/alive; sleep infinity
    livenessProbe:
      exec:
        command:
        - cat
        - /tmp/alive
      initialDelaySeconds: 5
      periodSeconds: 10
EOF
kubectl apply -f liveness-demo.yaml
kubectl describe pod liveness-demo-pod
#cancello il file sotto il naso
kubectl exec liveness-demo-pod -- rm /tmp/alive
kubectl describe pod liveness-demo-pod
cat << EOF > readiness-demo.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    demo: readiness-probe
  name: readiness-demo-pod
spec:
  containers:
  - name: readiness-demo-pod
    image: nginx
    ports:
    - containerPort: 80
    readinessProbe:
      exec:
        command:
        - cat
        - /tmp/healthz
      initialDelaySeconds: 5
      periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: readiness-demo-svc
  labels:
    demo: readiness-probe
spec:
  type: LoadBalancer
  ports:
    - port: 80
      targetPort: 80
      protocol: TCP
  selector:
    demo: readiness-probe
EOF
kubectl apply -f readiness-demo.yaml
kubectl describe pod readiness-demo-pod
kubectl exec readiness-demo-pod -- touch /tmp/healthz
kubectl describe pod readiness-demo-pod | grep ^Conditions -A 5
kubectl delete pod gb-frontend
cat << EOF > gb_frontend_deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: gb-frontend
  labels:
    run: gb-frontend
spec:
  replicas: 5
  selector:
    matchLabels:
      run: gb-frontend
  template:
    metadata:
      labels:
        run: gb-frontend
    spec:
      containers:
        - name: gb-frontend
          image: gcr.io/google-samples/gb-frontend-amd64:v5
          resources:
            requests:
              cpu: 100m
              memory: 128Mi
          ports:
            - containerPort: 80
              protocol: TCP
EOF
kubectl apply -f gb_frontend_deployment.yaml
for node in $(kubectl get nodes -l cloud.google.com/gke-nodepool=default-pool -o=name); do
  kubectl drain --force --ignore-daemonsets --grace-period=10 "$node";
done
kubectl describe deployment gb-frontend | grep ^Replicas
for node in $(kubectl get nodes -l cloud.google.com/gke-nodepool=default-pool -o=name); do
  kubectl uncordon "$node";

kubectl create poddisruptionbudget gb-pdb --selector run=gb-frontend --min-available 4
for node in $(kubectl get nodes -l cloud.google.com/gke-nodepool=default-pool -o=name); do
  kubectl drain --timeout=30s --ignore-daemonsets --grace-period=10 "$node";
done
kubectl describe deployment gb-frontend | grep ^Replicas