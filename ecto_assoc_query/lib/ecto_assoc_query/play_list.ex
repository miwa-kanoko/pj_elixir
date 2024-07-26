defmodule EctoAssocQuery.PlayList do
  use Ecto.Schema

  schema "play_lists" do
    field :name, :string
    belongs_to :user, EctoAssocQuery.User
    many_to_many :musics, EctoAssocQuery.Music, join_through: "play_list_musics"
  end
end
