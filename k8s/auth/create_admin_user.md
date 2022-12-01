# K8s Users
[Doc](https://kubernetes.io/docs/reference/access-authn-authz/authentication/)
## Users in K8s
- Normal users and service accounts
  - normal users cannot be created via api but service accounts can

## Certs
- in order for a normal user to be able to access api, the user must have a certificate issued by the cluster and present that certificate to the api
0. set variables
```
set NEWUSERNAME $home-cluster-admin
set CLUSTERNAME $home-cluster
```
1. client can obtain X.509 certificates by first creating CertificateSigningRequest type resource
generate key and csr with openssl
```
openssl genrsa -out $CLUSTERNAME-admin.key 2048
openssl req -new -key $CLUSTERNAME-admin.key -out $CLUSTERNAME-admin.csr
```
create k8s csr resource
- in csr-manifest, spec.request, paste base64 encoded value of csr (`cat $CLUSTERNAME-admin.csr | base64 | tr -d "\n"`)
```
kubectl apply -f csr-manifest.yaml
```
2. the CertificateSigningRequest will be approved and signed by the controller
approve csr
```
kubectl certificate approve $CLUSTERNAME-admin
```
get certificate from csr and save.The certificate value is in Base64-encoded format under status.certificate
```
# kubectl get csr/$CLUSTERNAME-admin -o yaml
kubectl get csr $CLUSTERNAME-admin -o jsonpath='{.status.certificate}'| base64 -d > $CLUSTERNAME-admin.crt

```
3. create role binding to cluster-admin role
```
kubectl create clusterrolebinding cluster-admin-bind-$CLUSTERNAME-admin --role=cluster-admin --user=$CLUSTERNAME-admin
```
4. add to kubeconfig
```
cd ~/.kube/certs
kubectl config set-credentials $CLUSTERNAME-admin --client-key=$CLUSTERNAME-admin.key --client-certificate=$CLUSTERNAME-admin.crt
kubectl config set-context $CLUSTERNAME-admin --cluster=$CLUSTERNAME --user=$CLUSTERNAME-admin
```
