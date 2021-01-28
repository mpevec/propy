#!/bin/bash
echo -e 'Removing existing docker images..\n'
docker rmi matthieulabs/matthieulabs-repo:propy_web
docker rmi propy_web
echo -e 'Calling mix task..\n'
mix prepare_static --s ../propy_frontend/propy/dist/propy
echo -e 'Building docker image propy_web..\n'
docker build -t propy_web .
echo -e 'Taging and pushing docker image matthieulabs/matthieulabs-repo:propy_web..\n'
docker login
docker tag propy_web:latest matthieulabs/matthieulabs-repo:propy_web
docker push matthieulabs/matthieulabs-repo:propy_web
echo 'Done.'