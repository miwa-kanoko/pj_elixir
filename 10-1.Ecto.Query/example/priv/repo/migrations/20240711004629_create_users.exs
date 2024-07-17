defmodule Example.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do #テーブル作成だけのsqlみたいなもん
    create table(:users) do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :age, :integer
      add :email, :string, null: false
      timestamps()
    end

    create unique_index(:users, [:email])
  end
end

# create/2 :データベースに何かを作成するマクロ(テーブル名は複数形)
# add/3     :データ名と型でカラムを追加
# timestamps/1 :inserted_atとupdate_atの2つの⽇時データのカラムを追加する関数
