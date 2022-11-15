# Jaeger installation
## Install jaeger operator
prerequisite
```
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.10.0/cert-manager.yaml
```
install operator
```
kubectl create ns observability
kubectl create -f https://github.com/jaegertracing/jaeger-operator/releases/download/v1.39.0/jaeger-operator.yaml -n observability
```

## Deploy Jaeger instance with Production strategy
create secret
```
kubectl get secret -n observability {es cluster name}-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode; echo
kubectl create secret generic jaeger-secret --from-literal=ES_PASSWORD={secret from above} --from-literal=ES_USERNAME=elastic -n observability
```
