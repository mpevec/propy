# Adcrawler

Propy job for crawling ad pages for properties.

## How to run app locally

You run it with following command:
**mix run --no-halt -e "Adcrawler.crawl()"**

Following the example on the mix help page:
*mix run -e "DbUtils.delete_old_records()" -- arg1 arg2 arg3*

## Hot to run app as a release

MIX_ENV=prod mix release

export PROPY_DB_URL="ecto://propy_user:pr272@localhost:5432/propy"

_build/prod/rel/adcrawler/bin/adcrawler start_iex

At this moment we need to trigger manually starting function - seperatly for "1000" and "2000" zip codes, hence we need to run above the command start_iex:

Adcrawler.crawl("1000")

and

Adcrawler.crawl("2000")

## Dockerization using local (host) DB

Building an image:

**docker build -t adcrawler .**

Run the container with entrypoint:

**docker run --name c_adcrawler10 -it --entrypoint=/bin/bash --net=host -e PROPY_DB_URL="ecto://propy_user:pr272@192.168.1.22:5432/propy" adcrawler:latest**

Where we can call then (inside of container) the following:

**./prod/rel/adcrawler/bin/adcrawler start_iex**

Once container is crated, you can always start it (daily), log into it, and repeat the commands.

### Accessing host DB from inside of docker container

You need to listen to all addresses (postgresql.conf):

listen_addresses = '*'

You need to authorize requests coming from container (pg_hba.conf):

host    all             all             192.168.1.1/16          md5
host    all             all             172.17.0.1/16           md5
