alias EctoAssocQuery.{Repo, Artist, MusicList, Music, User, PlayList, PlayListMusic, ActiveUser, DeleteUser}

csv =
  "day12_music.csv"
|> File.stream!()
|> CSV.decode!(headers: true)
|> Enum.to_list()

#アーティストの登録
csv
|> Enum.map(fn %{"artist_name" => artist} -> artist end)
|> Enum.uniq()
|> Enum.each(fn artist -> Repo.insert!(%Artist{name: artist}) end)

#楽曲リストの登録
csv
|> Enum.map(fn data ->
  {
    %MusicList{name: data["music_list_name"], category: data["category"], music_category: data["music_category"]}, data["artist_name"]
  }
end)
|> Enum.uniq()
|> Enum.each(fn {music_list, artist_name} ->
  artist = Repo.get_by(Artist, name: artist_name)
  Repo.insert!(%{music_list | artist_id: artist.id})
end)

#楽曲の登録
Enum.each(csv, fn data ->
  music_list = Repo.get_by(MusicList, name: data["music_list_name"])
  Repo.insert!(%Music{name: data["music_name"], music_list_id: music_list.id})
end)

#ユーザー登録
user = Repo.insert!(%User{name: "taro", email: "taro@example.com"})
Repo.insert!(%ActiveUser{user_id: user.id}) #active_userにも登録

#ユーザー（taro）のプレイリスト登録
Enum.each(1..2, fn index ->
  play_list = Repo.insert!(%PlayList{name: "play list #{index}", user_id: user.id})

  "day12_play_list#{index}.csv"
  |> File.stream!()
  |> CSV.decode!(headers: true)
  |> Enum.each(fn %{"music_name" => music_name} ->
    music = Repo.get_by(Music, name: music_name)
    Repo.insert!(%PlayListMusic{play_list_id: play_list.id, music_id: music.id})
  end)
end)

user = Repo.insert!(%User{name: "hanako", email: "hanako@example.com"})
Repo.insert!(%DeleteUser{user_id: user.id})
