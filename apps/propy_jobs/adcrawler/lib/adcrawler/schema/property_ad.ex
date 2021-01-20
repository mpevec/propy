defmodule Adcrawler.Schema.PropertyAd do
  @moduledoc """
    property_ad schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Adcrawler.Repo
  alias Adcrawler.Schema.ZipCode

  @primary_key {:id_property_ad, :id, autogenerate: true}
  schema "property_ad" do
    field :uid, :string
    field :title, :string
    field :href, :string
    field :description, :string
    field :price, :decimal
    field :price_before, :decimal
    field :size, :decimal
    field :agency, :string
    field :year_builded, :integer
    field :etage, :string
    field :last_date_checked, :date
    field :zip_code, :string, virtual: true
    timestamps()

    belongs_to :zipcode, Adcrawler.Schema.ZipCode,
      references: :id_zip_code,
      foreign_key: :id_zip_code
  end

  @fields ~w(uid title href price year_builded)a
  @create_fields @fields ++ ~w(description price_before size agency etage zip_code)a
  @required_fields @fields ++ ~w(id_zip_code last_date_checked)a

  def create_changeset(%{} = params) do
    %__MODULE__{}
    |> cast(params, @create_fields)
    |> put_zip_code()
    |> put_change(:last_date_checked, NaiveDateTime.utc_now |> NaiveDateTime.to_date)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:id_zip_code)
    |> unique_constraint(:uid)
  end

  def update_changeset(%__MODULE__{} = property_ad, params) do
    property_ad
    |> change(params)
    |> put_change(:last_date_checked, NaiveDateTime.utc_now |> NaiveDateTime.to_date)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:id_zip_code)
  end

  defp put_zip_code(%Ecto.Changeset{valid?: true} = changeset) do
    code = fetch_change!(changeset, :zip_code)
    zip_code = Repo.get_by(ZipCode, code: code)
    if zip_code do
      put_change(changeset, :id_zip_code, zip_code.id_zip_code)
    else
      changeset
    end
  end

  defp put_zip_code(changeset), do: changeset
end
