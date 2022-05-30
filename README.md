# wordpress-docker

#### Build une nouvelle image
```
docker build nom_du_dossier -t 'nom:tag'
```
``
docker build . -t 'numendo/php:8.0.13-apache-buster'
``

#### Push l'image
```
docker push 'nom/tag'
```
``
docker push 'numendo/php:8.0.13-apache-buster'
``
