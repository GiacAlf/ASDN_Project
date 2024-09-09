
# README: questo script installa jenkins sul cluster kubernetes

# disinstallazione di jenkins
sudo kubectl delete -f jenkins/jenkins-sa-binding.yaml
sudo kubectl delete serviceaccount jenkins-sa
sudo kubectl delete -f jenkins/jenkins-service.yaml
sudo kubectl delete -f jenkins/jenkins-deployment.yaml 

# Passaggi per l'installazione di Jenkins
echo "Installazione di Jenkins..."
sudo kubectl apply -f jenkins/jenkins-deployment.yaml

echo "Creazione jenkins service..."
sudo kubectl apply -f jenkins/jenkins-service.yaml

echo "Creazione service account di Jenkins..."
sudo kubectl create serviceaccount jenkins-sa

echo "Applicazione del binding per il service account di Jenkins..."
sudo kubectl apply -f jenkins/jenkins-sa-binding.yaml

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
echo
echo "The application IP and port is: $APP_IP_PORT"
echo
echo "The Jenkins IP is: 172.18.0.2:30000"
echo
# Recupera la password di Jenkins
echo "Recupero password Jenkins..."
sleep 30
echo "Jenkins password:" $(sudo kubectl get pods | awk '/jenkins/{print $1}')

# Recupera il token per il service account jenkins-sa
echo "Creazione token jenkins per kubectl..."
echo "Jenkins service account token per Kubectl: " && sudo kubectl -n devops-tools create token jenkins-admin


# passi successivi

# entrare nel pod jenkins
# sudo kubectl exec -it <JENKINS POD NAME> -- /bin/bash
# sudo su

