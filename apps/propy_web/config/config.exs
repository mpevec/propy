import Config

config :logger, :console,
  format: "\n##### $time $metadata[$level] $levelpad$message\n",
  metadata: :all

config :propy_web,
  cowboy_port: 4002
  
import_config "#{Mix.env()}.exs"
