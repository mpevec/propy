import Config

config :propy_core, Adcrawler.Repo,
  url: System.fetch_env!("PROPY_DB_URL")  