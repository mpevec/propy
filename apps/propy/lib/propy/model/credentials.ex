defmodule Propy.Model.Credentials do
  @moduledoc """
    User credentials model
  """
  @typedoc """
      Type that represents Credentials struct with :username as string and :password as string.
  """
  @type t :: %__MODULE__{username: String.t, password: String.t}

  # Ecto schemaless changeset
  @fields ~w(username password)a
  @required @fields

  # Different ways:
  # defstruct username: "", password: ""
  # or this defstruct [username: "", password: ""]
  # or this:
  defstruct @fields

  @spec to_struct!(map(), list(atom)) :: t()
  def to_struct!(params, required \\ @required) do
    types = %{username: :string, password: :string}

    {%__MODULE__{}, types}
    |> Ecto.Changeset.cast(params, Map.keys(types))
    |> Ecto.Changeset.validate_required(required)
    |> Ecto.Changeset.apply_action!(:insert)
  end
end
