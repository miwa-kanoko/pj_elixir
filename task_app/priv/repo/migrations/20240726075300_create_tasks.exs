defmodule TaskApp.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :user_id, :integer
      add :title, :string
      add :date, :date

      timestamps(type: :utc_datetime)
    end
  end
end
