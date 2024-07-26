defmodule EctoAssocQuery.Music do
  use Ecto.Schema

  schema "musics" do
    field :name, :string
    belongs_to :music_list, EctoAssocQuery.MusicList
    many_to_many :play_lists, EctoAssocQuery.PlayList, join_through: "play_list_musics"
  end
end
