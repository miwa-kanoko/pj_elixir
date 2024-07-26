defmodule EctoAssocQuery.User do
  use Ecto.Schema

  schema "users" do
    field :name, :string
    field :email, :string
    has_many :play_lists, EctoAssocQuery.PlayList
    has_many :musics, through: [:play_lists, :musics]
    has_one :active_user, EctoAssocQuery.ActiveUser
    has_one :delete_user, EctoAssocQuery.DeleteUser
  end
end
