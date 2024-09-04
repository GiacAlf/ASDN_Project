# Usa l'immagine ufficiale di Jenkins LTS come base
FROM jenkins/jenkins:lts

# Passa a utente root per installare pacchetti
USER root

# Aggiorna i pacchetti e installa strumenti utili
RUN apt-get update && apt-get install -y \
    sudo \
    iputils-ping \
    curl \
    wget \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Aggiungi l'utente Jenkins al gruppo sudo
RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Installazione di kubectl con metodo alternativo
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# Passa di nuovo all'utente Jenkins
USER jenkins
