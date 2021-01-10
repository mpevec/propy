defmodule Propy.Domain.ITrackLogin do
  @moduledoc """
    Tracking every authentication (login) mainly for silent refresh
  """
  alias Propy.Model.Token
  alias Propy.Schema.AppUser

  @callback track(Token.t()) :: {:ok, Token.t()} | {:error, any}
  @callback get_logged_user(String.t(), DateTime.t()) :: {:ok, AppUser.t()} | {:error, any}
end
