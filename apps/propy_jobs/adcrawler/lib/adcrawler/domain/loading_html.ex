defmodule Adcrawler.Domain.LoadingHtml do
  @moduledoc """
    Process of loading html page containg ads
  """
  use OkJose

  @html_loader Application.compile_env!(:adcrawler, :html_loader)

  @spec load(integer(), String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def load(page_num, zip_code) do
    {:ok, {page_num, zip_code}}
    |> get_page_url
    |> @html_loader.load
    |> Pipe.ok
  end

  defp get_page_url({page_num, zip_code}) do
    case zip_code do
      "2000" -> {:ok, "https://www.nepremicnine.net/oglasi-prodaja/podravska/maribor/stanovanje/#{page_num}/?s=16"}
      "1000" -> {:ok, "https://www.nepremicnine.net/oglasi-prodaja/ljubljana-mesto/stanovanje/#{page_num}/?s=16"}
      _ -> {:error, "Unknown zip_code #{zip_code}"}
    end
  end
end
