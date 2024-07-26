defmodule EctoTransaction.Point do
  use Ecto.Schema
  import Ecto.Changeset

  schema "points" do
    field :point_balance, :integer, default: 0
    belongs_to :user, EctoTransaction.User
  end

  def changeset(points, params) do
    points
    |> cast(params, [:point_balance, :user_id])
    |> validate_required(:point_balance, message: "Please enter your point_balance.")
  end
end
