#!/bin/bash
# questo script disinstalla e installa tekton

# disinstallazione
echo "Disinstallazione dashboard tekton..."
sudo kubectl delete --filename https://storage.googleapis.com/tekton-releases/dashboard/latest/release-full.yaml

echo "Disinstallazione tekton..."
sudo kubectl delete --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml

# verificare che nel file kind-config.yaml ci sia almeno la versione 1.28!!!!!

# installazione tekton e verifica
echo "Installazione tekton..."
sudo kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml

echo "Verifica installazione pods di tekton..."
sleep 20
sudo kubectl get pods --namespace tekton-pipelines

# installazione dashboard
echo "Installazione dashboard tekton..."
sudo kubectl apply --filename https://storage.googleapis.com/tekton-releases/dashboard/latest/release-full.yaml

echo "Verifica installazione pods di tekton..."
sleep 20
sudo kubectl get pods --namespace tekton-pipelines

echo
echo "Effettuare l'accesso a http://localhost:9097"
echo

echo "Port forwarding..."
sudo kubectl port-forward svc/tekton-dashboard -n tekton-pipelines 9097:9097