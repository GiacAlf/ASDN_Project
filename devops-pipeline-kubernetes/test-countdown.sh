#!/bin/bash

# Verifica che l'utente abbia fornito un argomento
if [ -z "$1" ]; then
  echo "Usage: $0 <time_in_seconds>"
  exit 1
fi

# Imposta il tempo di partenza dal primo argomento
total_time=$1
time_left=$total_time
bar_length=50  # Lunghezza della barra di progresso

# Ciclo che esegue il conto alla rovescia
for ((i=time_left; i>=0; i--)); do
  # Calcola la percentuale completata
  percent=$(( (100 * (total_time - i)) / total_time ))
  # Calcola quanti caratteri della barra devono essere riempiti
  filled_length=$(( (bar_length * (total_time - i)) / total_time ))

  # Crea la barra di progresso
  bar=$(printf "%-${bar_length}s" "#" | cut -c1-$filled_length)

  # Stampa la barra di progresso, la percentuale e il tempo rimanente
  echo -ne "[${bar// /-}] $percent%% | Tempo rimanente: $i secondi\033[0K\r"
  sleep 1
done
