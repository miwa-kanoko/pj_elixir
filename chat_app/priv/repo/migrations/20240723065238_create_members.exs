defmodule ChatApp.Repo.Migrations.CreateMembers do
  use Ecto.Migration

  def change do
    create table(:members) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :room_id, references(:rooms, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime, updated_at: false)
      # inserted_at
      # updated_at -> 不要
    end

    create index(:members, [:user_id])
    create index(:members, [:room_id])
  end
end
