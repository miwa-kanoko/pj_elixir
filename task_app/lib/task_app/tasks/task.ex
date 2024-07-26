defmodule TaskApp.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :date, :date
    field :title, :string
    field :user_id, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:user_id, :title, :date])
    |> validate_required([:user_id, :title, :date])
  end
end
