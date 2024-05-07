

**Step1: Applying ConfigMap for the 2 Pods index html.**

kubectl apply -f website01.example.internal-configmap.yaml
kubectl apply -f website02.example.internal-configmap.yaml

**Step2: Createing to Pods** 

kubectl apply -f website01.yaml
kubectl apply -f website02.yaml

**Step3: Creating 2 services to expose the Pods**

kubectl apply -f website01-service.yaml
kubectl describe  svc website01-service

kubectl apply -f website02-service.yaml
kubectl describe svc website02-service


**Step4: Configure Ingress Controller**

helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace

helm list --all-namespaces

kubectl get ingressclass

kubectl get service -n ingress-nginx



**Step5: Create the Ingress Resources**

kubectl apply -f ingress.yaml

**Step6: Install MetalLB**

Execute this command and change strictARP to true

Edit strictARP: from false to true
kubectl edit configmap -n kube-system kube-proxy

installation apply this manifest

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.10/config/manifests/metallb-frr.yaml

kubectl get pods -n metallb-system

kubectl apply -f metallb.yaml
kubectl rollout restart deployment deployment controller -n metallb-system


**Step7: Applly Bellow on the Master node**

vim /etc/hosts
<ADD-LOAD-BALANCER-IP> website01.example.internal website02.example.internal

curl website01.example.internal
curl website02.example.internal





