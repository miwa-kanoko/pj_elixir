defmodule EctoAssoc.Post do
  use Ecto.Schema

  schema "posts" do
    field :header, :string
    field :body, :string
    belongs_to :user, EctoAssoc.User
    many_to_many :users, EctoAssoc.User, join_through: "likes"
  end
end
