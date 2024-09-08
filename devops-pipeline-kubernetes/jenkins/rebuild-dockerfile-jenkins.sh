# README: questo file rebuilda il dockerfile e lo push su dockerhub

# rebuild del dockerfile
sudo docker build -t giacomoalfani/jenkins_custom .

# deve essere attivo il login con dockerhub con "docker login"

# push su dockerhub
sudo docker push giacomoalfani/jenkins_custom:latest