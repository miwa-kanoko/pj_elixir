defmodule EctoAssocQuery.Artist do
  use Ecto.Schema

  schema "artists" do
    field :name, :string
    has_many :music_lists, EctoAssocQuery.MusicList
    has_many :musics, through: [:music_lists, :musics]
  end
end
