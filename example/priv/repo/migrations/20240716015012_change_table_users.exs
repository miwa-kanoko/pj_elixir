defmodule Example.Repo.Migrations.ChangeTableUsers do
  use Ecto.Migration

  def change do
    rename table(:users), to: table(:peoples)
    end
  end
