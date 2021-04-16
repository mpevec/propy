defmodule PropyCore.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :propy_core,
    adapter: Ecto.Adapters.Postgres
end
