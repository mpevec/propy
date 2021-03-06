import Config

config :logger, :console,
  format: "\n##### $time $metadata[$level] $levelpad$message\n",
  metadata: :all

config :propy,
  cowboy_port: 4001,
  jwt_issuer: "Matthieu Labs SRL",
  jwt_expiration_in_minutes: 30,
  jwt_secret_hs256_signature: "asdwf12!weWEFWEWEFdfw123fweWEF!!Dcwcw?"

config :propy, Propy.Repo,
  url: "ecto://propy_user:pr272@localhost/propy"  

config :propy,
  ecto_repos: [Propy.Repo]  

import_config "#{Mix.env()}.exs"
