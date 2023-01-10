# Jaeger installation
## Install jaeger operator
prerequisite: 
- cert-manager `../certmanager`
- persistent volume support by openebs  `../openebs`
- elasticsearch operator `../elasticsearch`

install operator
```
kubectl create ns observability
kubectl create -f https://github.com/jaegertracing/jaeger-operator/releases/download/v1.39.0/jaeger-operator.yaml -n observability
```
## Deploy elasticsearch cluster as jaeger storage
```
kubectl apply -f jaeger-backend-es-manifest.yaml -n observability
```

## Deploy Jaeger instance with Production strategy
create secret
```
set ESPW (kubectl get secret -n observability jaeger-backend-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode; echo)
kubectl create secret generic jaeger-secret --from-literal=ES_PASSWORD=$ESPW --from-literal=ES_USERNAME=elastic -n observability
```
apply jaeger manifest 
```
kubectl apply -f jaeger-manifest.yaml -n observability
```
