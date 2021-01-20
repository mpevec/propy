defmodule Adcrawler.Domain.CrawlingAds do
  @moduledoc """
    Process of crawling (parsing) html page for ads and persisting them
  """
  use OkJose
  require Logger

  @ad_crawler Application.compile_env!(:adcrawler, :ad_crawler)
  @ad_persister Application.compile_env!(:adcrawler, :ad_persister)

  @spec crawl_for_ads(term(), String.t()) :: {:ok, list(String.t())} | {:error, term()}
  def crawl_for_ads(html, zip_code) do
    {:ok, html}
    |> @ad_crawler.prepare_html
    |> @ad_crawler.identify_ad_ids
    |> (fn(%{document: document, ad_ids: ad_ids}) ->

        # We persist ad by ad, one by one. In case of error, take_while will stop taking.
        passed_trough_ad_ids = Enum.take_while(ad_ids, fn id ->

            result_of_operations =
              {:ok, id}
              |> @ad_crawler.crawl_for_ad(document, [zip_code: zip_code])
              |> @ad_persister.persist
              |> Pipe.ok

            # take_while requires true/false in order to continue/stop
            case result_of_operations do
              {:ok, _} -> true
              _ = faulty_operation ->
                Logger.error("#{inspect(faulty_operation)}")
                false
            end

        end)

        if Enum.count(passed_trough_ad_ids) == Enum.count(ad_ids) do
          {:ok, passed_trough_ad_ids}
        else
          # we return ones, that did not pass trough
          {:error, %{message: "Web crawling failed, list of unprocessed ad ids is known.", ids: ad_ids -- passed_trough_ad_ids}}
        end

      end).()
    |> Pipe.ok
  end
end
