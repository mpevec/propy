defmodule Propy.Domain.UserAuthentication do
  @moduledoc """
    User authentication process with predefined adapters (not configured yet)
  """
  use OkJose
  alias Propy.Model.Credentials
  alias Propy.Model.Token

  @credentials_translator Propy.Adapter.CredentialsTranslator.Db
  @token_manager Propy.Adapter.TokenManager.Jwt
  @login_tracker Propy.Adapter.LoginTracker.Db

  @spec authenticate(Credentials.t()) :: {:ok, Token.t()} | {:error, any}
  def authenticate(%Credentials{} = credentials) do
    {:ok, credentials}
    |> @credentials_translator.translate
    |> @token_manager.create
    |> @login_tracker.track
    |> Pipe.ok
  end

  @spec refresh(String.t()) :: {:ok, Token.t()} | {:error, any}
  def refresh(refresh_token) do
    {:ok, refresh_token}
    |> @login_tracker.get_logged_user(DateTime.utc_now())
    |> @token_manager.create
    |> @login_tracker.track
    |> Pipe.ok
  end
end
