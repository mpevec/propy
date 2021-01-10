defmodule Propy.Model.Token do
  @moduledoc """
    JWT token model
  """
  @typedoc """
      Type that represents Credentials struct with :username as string and :password as string.
  """
  @type t :: %__MODULE__{jwt: String.t(), expired_in: number(), sub: integer(), uuid: String.t()}

  defstruct jwt: "", expired_in: nil, sub: nil, uuid: ""
end
