defmodule Identicon do
 def hash_input(input) do
   hash =
    :md5
    |> :crypto.hash(input)
    |> :binary.bin_to_list()

    %Identicon.Image{hex: hash}
 end

 def pick_color(image) do #ハッシュ化したリストからカラー作成
   %Identicon.Image{hex: [r, g, b | _]} = image
   %Identicon.Image{image | color: [r, g, b]}
 end

 def build_grid(image) do #グリッドの構築
   list =
    image.hex
    |>Enum.chunk_every(3) #リストの分割
    |>List.delete_at(-1) #余りの要素を削除
    |>Enum.map(&Identicon.mirror_row(&1)) #mirror_row/1の処理をを5回繰り返し、グリッドを作成
    |>List.flatten() #リスト内要素にリストが含まれないようにする
    |>Enum.with_index() #インデックス付きタプルリストに変換

    %Identicon.Image{image | grid: list} #image構造体にgridフィールドを追加
 end

 def mirror_row(row) do #グリッドの左右対称化
   [data1, data2, _tail] = row
   row ++ [data2, data1]
 end

 def filter_add_cells(image) do #色を付ける場所をフィルターする
   grid =
    Enum.filter(image.grid, fn {value, _index} -> rem(value, 2) == 0 end)

    %Identicon.Image{image | grid: grid}
   end

   def build_pixel_map(%Identicon.Image{grid: grid} = image) do #ピクセルマップを作製
    pixel_map =
      Enum.map(grid, fn { _value, index} ->
        top_left = {rem(index, 5) * 50, div(index, 5) * 50} #セルの左上ポイント
        bottom_right = {rem(index, 5) * 50 + 50, div(index, 5) * 50 +50} #セルの右上ポイント
        {top_left, bottom_right}
      end)

      %Identicon.Image{image | pixel_map: pixel_map}
   end

   def build_image(%Identicon.Image{color: color, pixel_map: pixel_map}, name) do #画像の生成
     img = :egd.create(250, 250)
     fill = :egd.color({Enum.at(color, 0), Enum.at(color, 1),
     Enum.at(color, 2)})
     Enum.each(pixel_map, fn {start, stop} ->
      :egd.filledRectangle(img, start, stop, fill)
     end)
     :egd.save(:egd.render(img), "#{name}.png")
   end

   def create_image() do
     name =
      IO.gets("")
      |>to_string()
      |>String.trim()

      name
      |>hash_input()
      |>pick_color()
      |>build_grid()
      |>filter_add_cells()
      |>build_pixel_map()
      |>build_image(name)
   end
end
