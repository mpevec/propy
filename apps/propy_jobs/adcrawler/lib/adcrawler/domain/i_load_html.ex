# mudel je rekel da je to del domain, ni to technical detail
defmodule Adcrawler.Domain.ILoadHtml do
  @moduledoc """
    Behaviour for loading the HTML page
  """
  @callback load(String.t()) :: {:ok, String.t()} | {:error, String.t()}
end
