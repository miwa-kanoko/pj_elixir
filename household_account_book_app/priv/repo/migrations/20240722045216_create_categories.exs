defmodule HouseholdAccountBookApp.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :category_name, :string
      add :color_code, :string, default: "#b0e0e6"

      timestamps(type: :utc_datetime)
    end
  end
end
