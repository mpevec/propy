defmodule Adcrawler.Schema.ZipCode do
  @moduledoc """
    zip_code schema
  """
  use Ecto.Schema

  @primary_key {:id_zip_code, :id, autogenerate: true}
  schema "zip_code" do
    field :code, :string
    field :name, :string

    has_one :property, Adcrawler.Schema.PropertyAd,
      references: :id_zip_code,
      foreign_key: :id_zip_code

    timestamps()
  end
end
