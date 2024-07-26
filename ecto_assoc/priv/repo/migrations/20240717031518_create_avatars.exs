defmodule EctoAssoc.Repo.Migrations.CreateAvatars do
  use Ecto.Migration

  def change do
    create table(:avatars) do
      add :nick_name, :string
      add :pic_url, :string
    end
  end
end
