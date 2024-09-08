#!/bin/bash
# README: questo script installa jenkins sul cluster kubernetes

# varialbili
JENKINS_DEPLOYMENT="Jenkins/jenkins_deployment.yaml"
JENKINS_SERVICE="Jenkins/jenkins_service.yaml"
JENKINS_SA_BINDING="Jenkins/jenkins_sa_binding.yaml"

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

# stampe utili
echo "Recupero IP e porta dell'applicazione e IP di Jenkins..."
# Recupera l'IP del control plane
CONTROL_PLANE_IP=$(sudo kubectl get nodes -o wide | grep control-plane | awk '{print $6}')

# Recupera la porta del servizio clusterdeplo
CLUSTERDEPLO_PORT=$(sudo kubectl get svc clusterdeplo -o wide | awk '{if(NR>1) print $5}' | cut -d':' -f2 | cut -d'/' -f1)

# Combina IP e porta
APP_IP_PORT="${CONTROL_PLANE_IP}:${CLUSTERDEPLO_PORT}"

# Stampa l'IP e la porta dell'applicazione
echo "The application IP and port: $APP_IP_PORT"
echo "The Jenkins IP is: 172.18.0.2:30000"

# Recupera la password di Jenkins
echo "Recupero password Jenkins..."
sleep 30
JENKINS_PASSWORD=$(sudo kubectl logs $(sudo kubectl get pods -o wide | grep jenkins | awk '{print $1}') | awk '/proceed to installation:/{getline; getline; print}')
echo "Jenkins password: $JENKINS_PASSWORD"
echo "(if not displayed run this:
sudo kubectl logs $(sudo kubectl get pods -o wide | grep jenkins | awk '{print $1}') | awk '/proceed to installation:/{getline; getline; print}')"
# Recupera il token per il service account jenkins-sa
echo "Creazione token jenkins per kubectl..."
JENKINS_SA_TOKEN=$(sudo kubectl create token jenkins-sa)
echo "Jenkins service account token for Kubectl: $JENKINS_SA_TOKEN"
