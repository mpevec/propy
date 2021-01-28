# Devops

## Dockerization

Some useful and common commands used across applications.

Listing all images:

```Elixir
docker images -a
```

Removing all the docker images:

```Elixir
docker rmi $(docker images -a -q)
```

Check the running containers:

```Elixir
docker ps -a
```

Removing the running containers (by its container id):

```Elixir
docker rm 0bb2bdcf548f
```

Connecting to the running container with name YYY:

```Elixir
docker exec -it YYY bash
```

Checking what was on stdout of container with ID YYY:

```Elixir
docker logs 4f6e05e642d0
```

(you could add --follow to tail it)

## Postgresql system queries

```Elixir
SHOW data_directory;

# /Library/PostgreSQL/9.6/data
```

```Elixir
SHOW hba_file;

# /Library/PostgreSQL/9.6/data/pg_hba.conf
```

## Postgresql thingies

Switching to postgres user to change postgres settings or logging into server as superuser:

```Elixir
sudo -u postgres bash
```

Reloading the config (on OSX):

```Elixir
PGDATA=/Library/PostgreSQL/9.6/data ./pg_ctl reload
```
