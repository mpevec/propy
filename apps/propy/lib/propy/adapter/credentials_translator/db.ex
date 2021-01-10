#adapter
defmodule Propy.Adapter.CredentialsTranslator.Db do
  @moduledoc """
    Implementation of ITranslateCredentials with DB
  """
  import Ecto.Query
  alias Propy.Domain.ITranslateCredentials
  alias Propy.Model.Credentials
  alias Propy.Repo
  alias Propy.Schema.AppUser
  @behaviour ITranslateCredentials

  @impl ITranslateCredentials
  def translate(%Credentials{username: username, password: password}) do
    q = from u in AppUser,
    where: fragment("md5(?)", ^password) == u.passhash and u.username == ^username

    # it raises in case of more results
    app_user = Repo.one(q)
    if app_user do
      {:ok, app_user}
    else
      {:error, "No result found!"}
    end
  end
end
