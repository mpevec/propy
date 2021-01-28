# Propy

Backend application for propy - property management.

## How to run app as a release

First create the release of the app:

```Elixir
MIX_ENV=prod mix release
```

and then run it with the custom command, which triggers migrations and afterwards starts the app:

```Elixir
export PROPY_DB_URL="ecto://propy_user:pr272@localhost:5432/propy"
export PROPY_COWBOY_PORT="4001"

_build/prod/rel/propy/bin/propy eval "Propy.Release.migrate_and_start"
```

## Dockerization using localhost (docker host) DB

We trigger building of an image:

```Elixir
docker build -t propy .
```

and then we can run the container (switch --net must be used because we are accessing local DB)

```Elixir
docker run --name c_propy -d --net=host -e PROPY_COWBOY_PORT="4001" -e PROPY_DB_URL="ecto://propy_user:pr272@192.168.1.21:5432/propy" propy:latest
```

## Using remote server and docker and installed DB inside of the host

We make sure that the DB is created, like this:

```Elixir
CREATE DATABASE propy WITH OWNER = 'propy' ENCODING = 'UTF8' CONNECTION LIMIT = -1;
```

and we need to allow access (*pg_hba.conf*) from the docker network:

```Elixir
host    all             all             172.17.0.1/16           md5
```

We need to send locally builded docker image from above to the hub (*hub.docker.com*):

```Elixir
docker login
docker tag propy:latest matthieulabs/matthieulabs-repo:propy
docker push matthieulabs/matthieulabs-repo:propy
```

On the server itself (docker host must be installed) we pull the image:

```Elixir
docker pull matthieulabs/matthieulabs-repo:propy
```

and then we run the container:

```Elixir
docker run --name c_propy -d --add-host=docker:208.87.129.71 --publish 4001:4001 -e PROPY_COWBOY_PORT="4001" -e PROPY_DB_URL="ecto://username:password@docker:5432/propy" matthieulabs/matthieulabs-repo:propy
```

where *username/password* are replaced with the real credentials.
