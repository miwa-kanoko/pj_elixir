defmodule Example.People do
  use Ecto.Schema #schemaを作成するためのモジュールをインポート
    import Ecto.Changeset

  schema "peoples" do
    field :first_name, :string
    field :last_name, :string
    field :sns_address, :string
    field :tel, :string

    timestamps() #レコードがデータベースに挿⼊された時刻inserted_atと最後に変更された時刻updated_at
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:first_name, :last_name, :sns_address, :tel])
    |> validate_required([:first_name, :last_name])
    |> validate_sns_address()
  end

  defp validate_sns_address(cs) do
    cs
    |> validate_required(:sns_address, message: "Please enter your sns_address.")
    |> unique_constraint(:sns_address, message: "sns_address has already has been retrieved.")
    |> unsafe_validate_unique(:sns_address, Example.Repo, message: "sns_address has already been retrieved.")
    |> validate_format(:sns_address, ~r/^[^\s]+@[^\s+$]/, message: "Must include the @ symbol, do not include spaces.")
  end

  def sample_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:first_name, :last_name, :age])
    |> validate_required(:first_name, message: "Please enter your first_name.")
    |> validate_required(:last_name, message: "Please enter your last_name.")
  end

end
