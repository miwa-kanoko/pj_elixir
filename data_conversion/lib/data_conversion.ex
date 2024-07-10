defmodule DataConversion do
 def api_request(end_point_api \\
 "https://api.data.metro.tokyo.lg.jp/v1/PublicFacility") do
 end_point_api
 |> HTTPoison.get!()
 |> Map.get(:body)
 |> Jason.decode!() #JSON形式の文字列をマップに変換
 |> hd() #headだけ使う
 end

 def json_encode!(list) do
   Jason.encode!(list) #jsonへ変換する
 end

 def get_geographic_coordinate(map) do #地理座標を取得する
   %{
    name: map["名称"]["表記"],
    lat: map["地理座標"]["緯度"],
    lon: map["地理座標"]["経度"]
   }
 end

 def get_geographic_coordinates(list) do #座標データをマップに変換
   Enum.map(list, & get_geographic_coordinate/1)
 end

 def create_csv(list, path \\ "new.csv") do
   list
   |> CSV.encode(headers: true)
   |> Enum.to_list()
   |> Enum.join()
   |> then(fn csv -> File.write!(path, csv) end)
 end

 def read_csv(path) do
   path
   |> File.stream!()
   |> CSV.decode!(headers: true)
   |> Enum.to_list()
 end


end
