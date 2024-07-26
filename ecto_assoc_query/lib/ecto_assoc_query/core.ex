defmodule EctoAssocQuery.Core do
  alias EctoAssocQuery.{Repo, User, Artist, Music}
  import Ecto.Query

  def get_active_user() do
    User
    |> join(:inner, [u], au in assoc(u, :active_user))
    |> Repo.all()
  end

  def example_get_active_user() do
    User
    |> join(:inner, [u], au in EctoAssocQuery.ActiveUser, on: u.id == au.user_id)
    |> Repo.all()
  end

  def get_artist_list(user_id) do
    query =
      from(a in Artist,
      join: m in assoc(a, :musics),
      join: pl in assoc(m, :play_lists),
      join: u in assoc(pl, :user),
      where: u.id == ^user_id
      )

      query
      |> Repo.all()
      |> Enum.sort() #順に並べ替え
      |> Enum.uniq() #重複をなくす
  end

  def get_users() do
    User
    |> join(:left, [u], du in assoc(u, :delete_user))
    |> Repo.all()
  end

  def get_user(user_id) do
    query =
      from(u in User,
      join: au in assoc(u, :active_user),
      where: u.id == ^user_id,
      preload: :musics)

      Repo.one(query)
  end

  def search_musics(music_list_id, value) do
    pattern = "%#{value}%"

    sub_query = from(m in Music, where: like(m.name, ^pattern))

    query =
      from(m in Music,
      join: ms in subquery(sub_query),
      on: m.id == ms.id,
      where: m.music_list_id == ^music_list_id
      )

      Repo.all(query)
  end




end
