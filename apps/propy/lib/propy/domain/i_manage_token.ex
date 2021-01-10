# mudel je rekel da je to del domain, ni to technical detail
defmodule Propy.Domain.IManageToken do
  @moduledoc """
    Authentication token manager
  """
  alias Propy.Model.Token
  alias Propy.Schema.AppUser

  @callback create(AppUser.t(), keyword(atom())) :: {:ok, Token.t()}
end
