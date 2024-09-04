#da eseguire dentro /DevOps-Pipeline_Kubernetes
sudo kind delete cluster #rimuove tutti i nodi del cluster
sudo kind create cluster --config Cluster/kind-config.yaml
sudo kind export kubeconfig --name kind
sudo kubectl config use-context kind-kind
sudo kubectl apply -f Cluster/cluster_deployment.yaml
sudo kubectl expose deployment clusterdeplo --type=NodePort --port=80
#cluster completato

#inizio jenkins
sudo kubectl apply -f Jenkins/jenkins_deployment.yaml
sudo kubectl apply -f Jenkins/jenkins_service.yaml
sudo kubectl create serviceaccount jenkins-sa
sudo kubectl apply -f Jenkins/jenkins_sa_binding.yaml
