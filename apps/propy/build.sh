#!/bin/bash
echo -e 'Removing existing docker images..\n'
docker rmi matthieulabs/matthieulabs-repo:propy
docker rmi propy
echo -e 'Building docker image propy..\n'
docker build -t propy .
echo -e 'Taging and pushing docker image matthieulabs/matthieulabs-repo:propy..\n'
docker login
docker tag propy:latest matthieulabs/matthieulabs-repo:propy
docker push matthieulabs/matthieulabs-repo:propy
echo 'Done.'