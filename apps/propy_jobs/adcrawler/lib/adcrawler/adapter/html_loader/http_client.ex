defmodule Adcrawler.Adapter.HtmlLoader.HttpClient do
  @moduledoc """
    HTTPoison implementation of ILoadHtml with http client
  """
  alias Adcrawler.Domain.ILoadHtml
  @behaviour ILoadHtml

  @impl ILoadHtml
  def load(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 404}} -> {:error, "HTTPoison: 404 for url: " <> url}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
    end
  end
end
