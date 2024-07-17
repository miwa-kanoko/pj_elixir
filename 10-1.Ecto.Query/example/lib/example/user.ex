defmodule Example.User do
  use Ecto.Schema #schemaを作成するためのモジュールをインポート
    import Ecto.Changeset

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :age, :integer
    field :email, :string

    timestamps() #レコードがデータベースに挿⼊された時刻inserted_atと最後に変更された時刻updated_at
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:first_name, :last_name, :age, :email])
    |> validate_required([:first_name, :last_name])
    |> validate_email()
    |> validate_last_name()
  end

  defp validate_email(cs) do
    cs
    |> validate_required(:email, message: "Please enter your email.")
    |> unique_constraint(:email, message: "Email has already has been retrieved.")
    |> unsafe_validate_unique(:email, Example.Repo, message: "Email has already been retrieved.")
    |> validate_format(:email, ~r/^[^\s]+@[^\s+$]/, message: "Must include the @ symbol, do not include spaces.")
  end

  defp validate_last_name(cs) do
    last_name = get_field(cs, :last_name)

    if last_name in ~w(Sato Suzuki Takahashi Tanaka Ito) do # ~Wはスペースで区切られた単語リスト
      cs
    else
      add_error(cs, :last_name, "Please use the last name specified.")
    end
  end

  def sample_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:first_name, :last_name, :age])
    |> validate_required(:first_name, message: "Please enter your first_name.")
    |> validate_required(:last_name, message: "Please enter your last_name.")
  end

end
