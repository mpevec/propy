FROM bitwalker/alpine-elixir:latest AS release_stage

COPY mix.exs .
COPY mix.lock .
RUN mix deps.get
RUN mix deps.compile

COPY config ./config
COPY lib ./lib
COPY test ./test
COPY priv ./priv

ENV MIX_ENV=prod
RUN mix release

FROM bitwalker/alpine-elixir:latest AS run_stage

RUN apk --no-cache add curl
COPY --from=release_stage $HOME/_build .
RUN chown -R default: ./prod
USER default
CMD ["./prod/rel/propy_web/bin/propy_web", "start"]