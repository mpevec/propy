defmodule Adcrawler.Adapter.AdPersister.Db do
  @moduledoc """
    DB implementation of IPersistAd
  """
  alias Adcrawler.Domain.IPersistAd
  alias Adcrawler.Repo
  alias Adcrawler.Schema.PropertyAd
  @behaviour IPersistAd

  @impl IPersistAd
  def persist(%{uid: _} = params) do
    if existing_ad = get_ad_by_uid(params) do
      update_prices(existing_ad, %{price: params.price, price_before: params.price_before})
    else
      insert(params)
    end
  end

  @impl IPersistAd
  def persist(%{} = _params), do: {:ok, :skip}

  defp update_prices(%PropertyAd{} = existing_ad, %{price: _, price_before: _} = params) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_prices, PropertyAd.update_changeset(existing_ad, params))
    |> Repo.transaction()
  end

  defp insert(%{} = params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:insert_ad, PropertyAd.create_changeset(params))
    |> Repo.transaction()
  end

  defp get_ad_by_uid(%{uid: uid} = _ad) do
    Repo.get_by(PropertyAd, uid: uid)
  end
end
