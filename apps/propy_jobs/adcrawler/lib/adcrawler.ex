defmodule Adcrawler do
  @moduledoc """
  Entry point for web crawling
  """
  alias Adcrawler.Adapter.HtmlLoader.Worker

  def crawl(zip_code) do
    Worker.load(1, zip_code)
  end
end
