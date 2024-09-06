#!/bin/bash

# questo script disinstalla e reinstalla argocd

# Funzione per verificare se tutti i pod sono in stato Running
check_pods_running() {
    pods=$(kubectl get pods -n argocd --no-headers | awk '{print $3}')
    for pod in $pods; do
        if [ "$pod" != "Running" ]; then
            return 1
        fi
    done
    return 0
}

# STEP 0: disinstalla argocd se esiste
echo "Rimuovendo ArgoCD se installato..."
sudo rm -f /usr/local/bin/argocd
rm -rf ~/.config/argocd
sudo kubectl delete namespace argocd --ignore-not-found=true

# STEP 1: Verifica l'esecuzione del cluster Kind
echo "Verificando lo stato del cluster..."
sudo kubectl get nodes

# STEP 2: Creare un namespace dedicato ad ArgoCD
echo "Creando il namespace argocd..."
sudo kubectl create namespace argocd

# STEP 3: Installazione di ArgoCD tramite manifesti yaml
echo "Installando ArgoCD..."
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# STEP 4: Verificare l'installazione
echo "Verificando l'installazione (pod in esecuzione)..."
sudo kubectl get pods -n argocd -o wide

# STEP 5: Attendere che tutti i pod siano in stato Running o attendere 180 secondi
echo "Controllando lo stato dei pod di ArgoCD..."
for i in {1..18}; do
    if check_pods_running; then
        echo "Tutti i pod sono in stato Running!"
        break
    else
        echo "Attesa che i pod siano in stato Running... (tentativo $i di 18)"
        sleep 10
    fi
done

# STEP 6: Esporre il servizio ArgoCD
echo "Esponendo il servizio ArgoCD su localhost:8081..."
sudo kubectl port-forward svc/argocd-server -n argocd 8081:443 &

# Ottenere le credenziali di accesso
echo "Collegati a https://localhost:8081"
echo "Per l'accesso:"
echo "username = admin"
echo -n "password = "
sudo kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
echo
