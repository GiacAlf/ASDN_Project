#!/bin/bash
# README: questo script distrugge e ricostruisce il cluster kubernetes

# per renderlo eseguibile: 
# chmod +x setup_cluster_and_jenkins.sh
# per lanciarlo:
# ./setup_cluster_and_jenkins.sh

# variabili
CLUSTER_CONFIG="cluster/kind-config.yaml"
CLUSTER_DEPLOYMENT="cluster/cluster-deployment.yaml"

# Funzione per verificare se un comando è andato a buon fine
check_command() {
    if [ $? -ne 0 ]; then
        echo "Errore durante l'esecuzione del comando: $1"
        exit 1
    fi
}

# Passaggi per il cluster Kubernetes
echo "Eliminazione del cluster esistente..."
sudo kind delete cluster
check_command "kind delete cluster"

echo "Creazione del cluster con la configurazione specificata..."
sudo kind create cluster --config $CLUSTER_CONFIG
check_command "kind create cluster"

echo "Esportazione del kubeconfig per il cluster..."
sudo kind export kubeconfig --name kind
check_command "kind export kubeconfig"

echo "Selezione del contesto Kubernetes per il cluster..."
sudo kubectl config use-context kind-kind
check_command "kubectl config use-context kind-kind"

echo "Applicazione del file di deployment per il cluster..."
sudo kubectl apply -f $CLUSTER_DEPLOYMENT
check_command "kubectl apply -f $CLUSTER_DEPLOYMENT"

echo "Esposizione del deployment del cluster..."
sudo kubectl expose deployment clusterdeplo --type=NodePort --port=80
check_command "kubectl expose deployment clusterdeplo"

echo "Cluster completato con successo!"
