# Usa l'immagine ufficiale di Jenkins LTS come base
FROM jenkins/jenkins:lts

# Passa a utente root per installare pacchetti
USER root

# Aggiorna i pacchetti e installa strumenti utili
RUN apt update && apt install -y \
    sudo \
    iputils-ping \
    curl \
    git \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release && \
    rm -rf /var/lib/apt/lists/*

# Aggiungi l'utente Jenkins al gruppo sudo
RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Passa di nuovo all'utente Jenkins
USER jenkins

# Espone la porta 8080 per Jenkins
EXPOSE 8080
