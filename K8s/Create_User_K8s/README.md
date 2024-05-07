**Step 1: Generating a Key Pair and Certificate Signing Request (CSR)**

openssl genrsa -out developer.key 2048

openssl req -new -key developer.key -out developer.csr -subj "/CN=developer"

**Step 2: let’s create create a CSR YAML file named “csr_template.yaml” to submit to Kubernetes**

cat <<EOF > csr_template.yaml
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: developer-csr
spec:
  request: <Base64_encoded_CSR>
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
EOF

**Step 3: Replace <Base64_encoded_CSR> with the Base64-encoded content of the developer.csr file**

CSR_CONTENT=$(cat developer.csr | base64 | tr -d '\n')

sed "s|<Base64_encoded_CSR>|$CSR_CONTENT|" csr_template.yaml > developer_csr.yaml

**Step 4: Apply the CSR YAML file to Kubernetes**

kubectl create -f developer_csr.yaml

**Step 5: Approve the CSR and retrieve the approved certificate**

kubectl get csr
kubectl certificate approve developer-csr
kubectl get csr developer-csr -o jsonpath='{.status.certificate}' | base64 --decode > developer.crt
kubectl get csr

**Step 5: Generate and Configure a kubeconfig File**

kubectl config set-cluster kubernetes — server=https://<Kubernetes_API_server_endpoint>:<port> — certificate-authority=<Base64_encoded_CA_certificate> — embed-certs=true — kubeconfig=developer.kubeconfig

>[!CAUTION]
>First, we need to locate the cluster’s Kubernetes API access details and the Cluster CA certificate:

:+1: kubectl config view

:+1: ls /etc/kubernetes/pki/

> [!TIP]
>kubectl config set-cluster kubernetes — server=https://192.168.1.103:6443 — certificate-authority=/etc/kubernetes/pki/ca.crt — embed-certs=true — kubeconfig=developer.kubeconfig

>[!CAUTION]
>Replace <Kubernetes_API_server_endpoint> with the address of the Kubernetes API server and <port> with the corresponding port number.  
>Replace <Base64_encoded_CA_certificate> with the file path of the CA certificate in Base64 encoding.


**Set Credentials for Developer:**

kubectl config set-credentials developer --client-certificate=developer.crt --client-key=developer.key --embed-certs=true --kubeconfig=developer.kubeconfig

**Set Developer Context:**

kubectl config set-context developer-context --cluster=kubernetes --namespace=default --user=developer --kubeconfig=developer.kubeconfig

**Use Developer Context:**

kubectl config use-context developer-context --kubeconfig=developer.kubeconfig

**Step 6: Verify the kubeconfig file’s configuration**

kubectl --kubeconfig=developer.kubeconfig get pods

> [!WARNING]
> It Should fail we need to create the Role and RoleBinding First


**Step 7: Assign Roles for the Developer User**

developer-cluster-role.yaml

cat <<EOF > developer-cluster-role.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: developer-role
rules:
- apiGroups: ["", "extensions", "apps"]
  resources: ["*"]
  verbs: ["*"]
EOF

**Step 8: Assign Roles binding for the Developer User**

developer-role-binding.yaml

cat <<EOF > developer-role-binding.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: developer-binding
  namespace: default
subjects:
- kind: User
  name: developer
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: developer-role
  apiGroup: rbac.authorization.k8s.io
EOF

**Step 9: Apply the roles and role bindings**

kubectl apply -f developer-cluster-role.yaml -f developer-role-binding.yaml

**Step 10: Verify developer User Rights**

kubectl --kubeconfig=developer.kubeconfig get pods
kubectl --kubeconfig=developer.kubeconfig run nginx --image=nginx
kubectl --kubeconfig=developer.kubeconfig get pods

**Step 11: confirms that the developer user has appropriate access to pods in the default namespace**

kubectl --kubeconfig=developer.kubeconfig get pods -A

> [!WARNING]
> It Should fail.

