import Config

config :propy_core, PropyCore.Repo,
  url: "ecto://propy_user:pr272@localhost:5432/propy",
  show_sensitive_data_on_connection_error: true  

config :propy_core,
  ecto_repos: [PropyCore.Repo]  

import_config "#{Mix.env()}.exs"
