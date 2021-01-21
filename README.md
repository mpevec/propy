# Propy

Propy project contains many subprojects.

Frontend is done with **Angular** (/apps/propy_frontend) whith using **Bulma customization** (/bulma-customization).

The build is then served by **Elixir** (/apps/propy_web).

Backend is developed in **Elixir** (/apps/propy).

Backend jobs, like ad crawling, are developed in **Elixir** (/apps/propy_jobs)

Please check README.md file of a specific app in its main directory.

## Dockerization

Some useful and common commands used across applications.

Listing all images:
**docker images -a**

Removing all images:
**docker rmi $(docker images -a -q)**

Check running containers:
**docker ps -a**

Removing running containers (by its container id):
**docker rm 0bb2bdcf548f**

Connecting to the running container with name YYY:
**docker exec -it YYY bash**

## Postgresql system queries

SHOW data_directory;
/Library/PostgreSQL/9.6/data

SHOW hba_file;
/Library/PostgreSQL/9.6/data/pg_hba.conf

## Postgresql thingies

First work as another user:
**sudo -u postgres bash**

Reloading the config:
**PGDATA=/Library/PostgreSQL/9.6/data ./pg_ctl reload**
