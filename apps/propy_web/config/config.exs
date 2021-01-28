import Config

config :logger, :console,
  format: "\n##### $time $metadata[$level] $levelpad$message\n",
  metadata: :all

config :propy_web,
  cowboy_port: 8080,
  upstream: "//127.0.0.1:4001/api"
  
import_config "#{Mix.env()}.exs"
