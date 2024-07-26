defmodule EctoAssocQuery.MusicList do
  use Ecto.Schema

  schema "music_lists" do
    field :name, :string
    field :category, :string
    field :music_category, :string
    belongs_to :artist, EctoAssocQuery.Artist
    has_many :musics, EctoAssocQuery.Music
  end
end
