defmodule Propy.Adapter.LoginTracker.Db do
  @moduledoc """
    Implementation of ITrackLogin with DB  
  """
  import Ecto.Query
  alias Propy.Domain.ITrackLogin
  alias Propy.Model.Token
  alias Propy.Repo
  alias Propy.Schema.AppUserLogin
  @behaviour ITrackLogin

  @impl ITrackLogin
  def track(%Token{expired_in: expired_in, sub: sub} = token) do
    uuid = Ecto.UUID.generate()

    params = %{
      id_app_user: sub,
      time_expired: DateTime.from_unix!(expired_in),
      uuid: uuid
    }
    changeset = AppUserLogin.create_changeset(%AppUserLogin{}, params)

    Ecto.Multi.new()
      |> Ecto.Multi.insert(:insert_user_login, changeset)
      |> Repo.transaction()
      |> case do
        {:ok, _} -> {:ok, %Token{token | uuid: uuid}}
        _ = error ->
          # TODO: log error
          error
      end
  end

  @impl ITrackLogin
  def get_logged_user(refresh_token, at_time \\ DateTime.utc_now()) do
    q = from ul in AppUserLogin,
    join: u in assoc(ul, :appuser),
    where: ul.uuid == ^refresh_token and
      ul.time_expired > type(^at_time, :utc_datetime),
    preload: [appuser: u]

    app_user_login = Repo.one(q)
    if app_user_login do
      {:ok, Map.get(app_user_login, :appuser)}
    else
      {:error, "No result found for refresh token: #{refresh_token}"}
    end
  end
end
