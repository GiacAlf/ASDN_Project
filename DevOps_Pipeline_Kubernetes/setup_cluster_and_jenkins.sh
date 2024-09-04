#!/bin/bash

# per renderlo eseguibile: 
# chmod +x setup_cluster_and_jenkins.sh
# per lanciarlo:
# ./setup_cluster_and_jenkins.sh

# Variabili
CLUSTER_CONFIG="Cluster/kind-config.yaml"
CLUSTER_DEPLOYMENT="Cluster/cluster_deployment.yaml"
JENKINS_DEPLOYMENT="Jenkins/jenkins_deployment.yaml"
JENKINS_SERVICE="Jenkins/jenkins_service.yaml"
JENKINS_SA_BINDING="Jenkins/jenkins_sa_binding.yaml"

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

# Passaggi per l'installazione di Jenkins
echo "Installazione di Jenkins..."
sudo kubectl apply -f $JENKINS_DEPLOYMENT
check_command "kubectl apply -f $JENKINS_DEPLOYMENT"

sudo kubectl apply -f $JENKINS_SERVICE
check_command "kubectl apply -f $JENKINS_SERVICE"

echo "Creazione del service account per Jenkins..."
sudo kubectl create serviceaccount jenkins-sa
check_command "kubectl create serviceaccount jenkins-sa"

echo "Applicazione del binding per il service account di Jenkins..."
sudo kubectl apply -f $JENKINS_SA_BINDING
check_command "kubectl apply -f $JENKINS_SA_BINDING"

echo "Installazione di Jenkins completata con successo!"
