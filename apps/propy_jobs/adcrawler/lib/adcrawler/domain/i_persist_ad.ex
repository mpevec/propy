# mudel je rekel da je to del domain, ni to technical detail
defmodule Adcrawler.Domain.IPersistAd do
  @moduledoc """
    Behaviour for persisting ads (usually with db)
  """
  @callback persist(%{uid: String.t()}) :: {:ok, term()} | {:error, term()}
  @callback persist(%{}) :: {:ok, :skip}
end
