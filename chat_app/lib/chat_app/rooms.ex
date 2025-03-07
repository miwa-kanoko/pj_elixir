defmodule ChatApp.Rooms do
  @moduledoc """
  The Rooms context.
  """

  import Ecto.Query, warn: false
  alias ChatApp.Repo
  alias Ecto.Multi

  alias ChatApp.Rooms.Room
  alias ChatApp.Rooms.Member
  alias ChatApp.Rooms.Message

  @doc """
  Returns the list of rooms.

  ## Examples

      iex> list_rooms()
      [%Room{}, ...]

  """
  def list_rooms do
    Room
    |> preload(:users)
    |> Repo.all()
  end

  def list_messages(room_id) do
    Message
    |> where([m], m.room_id == ^room_id)
    |> preload(:user)
    |> Repo.all()
  end

  @doc """
  Gets a single room.

  Raises `Ecto.NoResultsError` if the Room does not exist.

  ## Examples

      iex> get_room!(123)
      %Room{}

      iex> get_room!(456)
      ** (Ecto.NoResultsError)

  """
  def get_room!(id), do: Repo.get!(Room, id)

  def get_room(room_id, user_id) do
    Room
    |> join(:inner, [r], u in assoc(r, :users))
    |> where([r, u], r.id == ^room_id and u.id== ^user_id)
    |> Repo.one()
  end

  @doc """
  Creates a room.

  ## Examples

      iex> create_room(%{field: value})
      {:ok, %Room{}}

      iex> create_room(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_room(user_id, attrs \\ %{}) do
    Multi.new()
    |> Multi.insert(:room, Room.changeset(%Room{}, attrs))
    |> Multi.insert(:member, fn%{room: %Room{id: room_id}} ->
      %Member{user_id: user_id, room_id: room_id}
    end)
    |> Repo.transaction()
  end

  def create_member(user_id, room_id) do
    %Member{}
    |> Member.changeset(%{user_id: user_id, room_id: room_id})
    |> Repo.insert()
  end

  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert() # ==> {:ok, message} or {:error, ~~}
    |> case do
      {:ok, message} ->{:ok, Repo.preload(message, :user)}
      result -> result
    end
    end

  @doc """
  Updates a room.

  ## Examples

      iex> update_room(room, %{field: new_value})
      {:ok, %Room{}}

      iex> update_room(room, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_room(%Room{} = room, attrs) do
    room
    |> Room.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a room.

  ## Examples

      iex> delete_room(room)
      {:ok, %Room{}}

      iex> delete_room(room)
      {:error, %Ecto.Changeset{}}

  """
  def delete_room(%Room{} = room) do
    Repo.delete(room)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking room changes.

  ## Examples

      iex> change_room(room)
      %Ecto.Changeset{data: %Room{}}

  """
  def change_room(%Room{} = room, attrs \\ %{}) do
    Room.changeset(room, attrs)
  end

  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end


end
