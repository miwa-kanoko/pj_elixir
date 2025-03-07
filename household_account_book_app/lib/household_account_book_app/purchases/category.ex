defmodule HouseholdAccountBookApp.Purchases.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :category_name, :string
    field :color_code, :string, default: "#b0e0e6"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:category_name, :color_code])
    |> validate_required([:category_name, :color_code])
  end
end
