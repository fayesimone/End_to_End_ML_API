#Switch to w255 AKS context
kubectl config use-context w255-aks

#Apply the Kubernetes yaml files with kustomized development file
kubectl apply -k mlapi/.k8s/overlays/prod -n fayetitchenal

