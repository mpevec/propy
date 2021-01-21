import Config

config :adcrawler, Adcrawler.Repo,
  url: System.fetch_env!("PROPY_DB_URL")  