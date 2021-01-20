defmodule Adcrawler.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :adcrawler,
    adapter: Ecto.Adapters.Postgres
end
