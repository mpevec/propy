defmodule Adcrawler.Domain.ICrawlAds do
  @moduledoc """
    Behaviour for crawling ads on html page
  """
  @callback prepare_html(String.t()) ::
    {:ok, String.t()} |
    {:error, String.t()}

  @callback identify_ad_ids(String.t()) ::
    {:ok, %{document: String.t(), ad_ids: list(String.t())}} |
    {:error, String.t()}

  @callback crawl_for_ad(String.t(), String.t(), keyword(atom())) ::
    {:ok, %{uid: String.t()}} |
    {:ok, %{}} |
    {:error, String.t()}
end
