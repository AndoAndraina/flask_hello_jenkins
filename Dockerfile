FROM python:3.7

# Ne pas lancer l'application en root dans Docker
RUN useradd flask

WORKDIR /home/flask

# Copier tout le contexte sauf ce qui est dans .dockerignore
ADD . .

# Installer les dépendances Python
RUN pip install -r requirements.txt

# Donner les droits d'exécution et changer le propriétaire
RUN chmod a+x app.py test.py && \
    chown -R flask:flask ./

# Déclarer la variable d'environnement pour Flask
ENV FLASK_APP app.py

# Exposer le port 5000 (port par défaut de Flask)
EXPOSE 5000

# Changer d'utilisateur pour ne pas lancer en root
USER flask

# Lancer l'application Flask (le script app.py)
CMD ["./app.py"]
