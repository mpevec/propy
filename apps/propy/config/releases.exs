import Config

config :propy, Propy.Repo,
  url: System.fetch_env!("PROPY_DB_URL")

config :propy,
  cowboy_port: String.to_integer(System.fetch_env!("PROPY_COWBOY_PORT"))
