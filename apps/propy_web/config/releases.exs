import Config

config :propy_web,
  cowboy_port: String.to_integer(System.fetch_env!("PROPY_WEB_COWBOY_PORT")),
  upstream: System.fetch_env!("PROPY_WEB_UPSTREAM")
  