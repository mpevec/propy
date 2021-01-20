defmodule Adcrawler.Adapter.AdCrawler.Floki do
  @moduledoc """
    Implementation of ICrawlAds with Floki
  """
  require Logger

  alias Adcrawler.Domain.ICrawlAds
  @behaviour ICrawlAds

  # We are converting html to Elixir data structure ready to be analysed
  @impl ICrawlAds
  def prepare_html(html) do
    Floki.parse_document(html)
  end

  @impl ICrawlAds
  def identify_ad_ids(document) do
    ad_ids = document |> Floki.find("div.seznam div.oglas_container")
    if length(ad_ids) > 0 do
      {:ok, %{document: document, ad_ids: ad_ids |> Floki.attribute("id")}}
    else
      {:error, "No ads in the document."}
    end
  end

  @impl ICrawlAds
  def crawl_for_ad(id, document, opts) do
    zip_code = Keyword.get(opts, :zip_code)

    ad_as_dom = get_ad(document, id)
    href = get_ad_href(ad_as_dom)

    if (byte_size(href) > 0) do
        {:ok, %{
          uid: id,
          title: get_ad_title(ad_as_dom),
          href: href,
          description: get_ad_description(ad_as_dom),
          price: get_ad_price(ad_as_dom),
          price_before: get_ad_price_before(ad_as_dom),
          size: get_ad_size(ad_as_dom),
          agency: get_ad_agency(ad_as_dom),
          year_builded: get_ad_year(ad_as_dom),
          etage: get_ad_etage(ad_as_dom),
          zip_code: zip_code,
        }}
    else
      {:ok, %{}}
    end
  end

  defp get_ad(document, id) do
    document |> Floki.find("div.seznam div.oglas_container[id=#{id}] div[itemprop=item]")
  end

  defp get_ad_href(document) do
    document |> Floki.find("h2 a[itemprop=url]") |> Floki.attribute("href") |> Floki.text
  end

  defp get_ad_title(document) do
    document |> Floki.find("h2 a[itemprop=url] span[class=title]") |> Floki.text
  end

  defp get_ad_description(document) do
    document |> Floki.find("div[class=kratek_container] div[itemprop=description]") |> Floki.text
  end

  defp get_ad_price(document) do
    {price, _} = document |> Floki.find("div[class=main-data] meta[itemprop=price]") |> Floki.attribute("content") |> Floki.text |> Float.parse
    price
  end

  defp get_ad_price_before(document) do
    tmp = document |> Floki.find("span[class=cena] span[class=cena-old]") |> Floki.text
    if String.length(tmp) > 0 do
      {price, _} = String.slice(tmp, 0, String.length(tmp) - 2) |> String.replace(".", "") |> String.replace(",", ".") |> Float.parse
      price
    end
  end

  # "64,50 m2"
  defp get_ad_size(document) do
    size = document |> Floki.find("div[class=main-data] span[class=velikost]") |> Floki.text
    if String.length(size) > 0 do
      {size, _} = String.slice(size, 0, String.length(size) - 3) |> String.replace(",", ".") |> Float.parse
      size
    end
  end

  defp get_ad_agency(document) do
    document |> Floki.find("div[class=main-data] .agencija") |> Floki.text
  end

  defp get_ad_year(document) do
    case document |> Floki.find("div[class=atributi] span[class='atribut leto'] strong") |> Floki.text |> Integer.parse do
      {year, _} -> year
      _ ->
        Logger.debug(" *** Can not crawl for 'ad_year'. ***")
        0
    end
  end

  defp get_ad_etage(document) do
    # It can be also a letter P as 'Pritlicje'
    document |> Floki.find("div[class=atributi] span[class=atribut] strong") |> Floki.text
  end
end
