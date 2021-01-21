defmodule Adcrawler do
  @moduledoc """
  Entry point for web crawling
  """
  alias Adcrawler.Adapter.HtmlLoader.Worker

  def crawl(zip_code) do
    Worker.load(1, zip_code)
  end

  def test_db do
    result = Ecto.Adapters.SQL.query(Adcrawler.Repo, "SELECT 1")
    IO.inspect(result, label: "Test db")
  end
end
