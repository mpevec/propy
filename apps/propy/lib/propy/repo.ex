defmodule Propy.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :propy,
    adapter: Ecto.Adapters.Postgres
end
