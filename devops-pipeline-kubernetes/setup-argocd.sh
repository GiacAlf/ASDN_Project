#!/bin/bash
# questo script disinstalla e installa argocd


# disinstallazione
echo "Disinstallazione argocd..."
sudo kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Eliminazione Namespace..."
sudo kubectl delete namespace argocd


# installazione
echo "Creazione Namespace..."
sudo kubectl create namespace argocd

echo "Installazione argocd..."
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Attesa creazione pod..."
sleep 180
sudo kubectl get pods -n argocd -o wide

echo "Collegarsi a https://localhost:8081"
echo "Username: main"
echo -n "Password: " && sudo kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
echo
echo "Port forwarding..."
sudo kubectl port-forward svc/argocd-server -n argocd 8081:443