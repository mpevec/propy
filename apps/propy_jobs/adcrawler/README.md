# Adcrawler

Propy job for crawling ad pages for properties.

## How to run app locally (with iex)

You run starting functions inside of the iex console with the following command:

```Elixir
Adcrawler.crawl("2000")
```

and/or:

```Elixir
Adcrawler.crawl("1000")
```

## How to run app as a release

First create the release of the app:

```Elixir
MIX_ENV=prod mix release
```

and then run it with *iex* support:

```Elixir
export PROPY_DB_URL="ecto://propy_user:pr272@localhost:5432/propy"

_build/prod/rel/adcrawler/bin/adcrawler start_iex
```

At this moment we can trigger starting function as shown above.

## Dockerization using localhost (docker host) DB

We trigger building of an image:

```Elixir
docker build -t adcrawler .
```

and then we can run the container with the entrypoint:

```Elixir
docker run --name c_adcrawler -it --entrypoint=/bin/bash --net=host -e PROPY_DB_URL="ecto://propy_user:pr272@192.168.1.22:5432/propy" adcrawler:latest
```

Inside of the container we run the app with *iex*:

```Elixir
./prod/rel/adcrawler/bin/adcrawler start_iex
```

Once the container is created, you can always start it (daily), log into it, and repeat the commands.

## Accessing host DB from inside of docker container

You need to listen to all addresses (*postgresql.conf*):

```Elixir
listen_addresses = '*'
```

and you need to authorize requests coming from container (*pg_hba.conf*):

```Elixir
host    all             all             192.168.1.1/16          md5
host    all             all             172.17.0.1/16           md5
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

We need to send locally building docker image form before to the hub (*hub.docker.com*):

```Elixir
docker login
docker tag adcrawler:latest matthieulabs/matthieulabs-repo:adcrawler
docker push matthieulabs/matthieulabs-repo:adcrawler
```

On the server itself (docker host must be installed) we pull the image:

```Elixir
docker pull matthieulabs/matthieulabs-repo:adcrawler
```

and then we run the container:

```Elixir
docker run --name c_adcrawler -it --entrypoint=/bin/bash --net=host -e PROPY_DB_URL="ecto://username:password@localhost:5432/propy" matthieulabs/matthieulabs-repo:adcrawler
```

wehere *username/password* are replaced with the real credentials.

After we are logged into container we can run *iex* console

```Elixir
./prod/rel/adcrawler/bin/adcrawler start_iex
```

and if needed we can run the migrations from it:

```Elixir
path = Application.app_dir(:adcrawler, "priv/repo/migrations")
Ecto.Migrator.run(Adcrawler.Repo, path, :up, all: true)
```

After that we can use our starting function as shown above.
