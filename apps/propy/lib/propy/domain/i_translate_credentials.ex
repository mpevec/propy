# mudel je rekel da je to del domain, ni to technical detail
defmodule Propy.Domain.ITranslateCredentials do
  @moduledoc """
    Translating credentials into application user
  """
  alias Propy.Model.Credentials
  alias Propy.Schema.AppUser

  @callback translate(Credentials.t()) :: {:ok, AppUser.t()} | {:error, any}
end
