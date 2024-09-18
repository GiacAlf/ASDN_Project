# Usa l'immagine ufficiale di Jenkins LTS come base
FROM jenkins/jenkins:lts

# Passa a utente root per installare pacchetti
USER root

# Aggiorna i pacchetti e installa strumenti utili
RUN apt update && apt install -y \
    sudo \
    iputils-ping \
    curl \
    wget \
    git \
    snapd \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

# Avvia il demone snapd
#RUN snap install core && \
    #snap refresh core

# Installa kubectl tramite snap
#RUN snap install kubectl --classic

# install kubernetes via curl
RUN curl -LO https://dl.k8s.io/release/v1.31.0/bin/linux/arm64/kubectl

# sposto cartella
RUN sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Aggiungi l'utente Jenkins al gruppo sudo
RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Passa di nuovo all'utente Jenkins
USER jenkins

# Espone la porta 8080 per Jenkins
EXPOSE 8080
