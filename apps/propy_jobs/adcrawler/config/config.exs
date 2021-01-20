import Config

config :logger, :console,
  format: "\n\n----- LOGGER OUTPUT, at: $time\n$metadata[$level] $levelpad\n----- MESSAGE: $message\n",
  metadata: :all

config :adcrawler, Adcrawler.Repo,
  url: "ecto://propy_user:pr272@localhost/propy"  

config :adcrawler,
  ecto_repos: [Adcrawler.Repo]  

config :adcrawler,
  ad_crawler: Adcrawler.Adapter.AdCrawler.Floki,
  ad_persister: Adcrawler.Adapter.AdPersister.Db,
  html_loader: Adcrawler.Adapter.HtmlLoader.HttpClient


import_config "#{Mix.env()}.exs"
