defmodule Day3Work do
  def question01(s \\"stressed") do
    String.reverse(s)
    |> IO.puts()
  end

    def question02() do
      s = "パタトクカシー"
      String.codepoints(s) #["パ", "タ", "ト", "ク", "カ", "シ", "ー", "ー"]
      |> Enum.with_index() #[{"パ", 0}, {"タ", 1}, {"ト", 2}, {"ク", 3}, {"カ", 4}, {"シ", 5}, {"ー", 6}, {"ー", 7}]
      |>Enum.filter(fn {_char, index} -> rem(index, 2) == 0 end) #[{"パ", 0}, {"ト", 2}, {"カ", 4}, {"ー", 6}]
      |>Enum.map(fn {char, _index} -> char end)#["パ", "ト",　"カ", "ー"]
      |>Enum.join() #"パトカー"
      |>IO.puts() #出力
      end

      def question03 do
        s1 = "パトカー"
        s2 = "タクシー"
        s1 = String.graphemes(s1)#[]"パ", "ト",　"カ", "ー"]
        s2 = String.graphemes(s2)#[]"タ", "ク",　"シ", "ー"]
        Enum.zip(s1, s2) #[{"パ", "タ"}{"ト", "ク"}{"カ", "シ"}{"ー", "ー"}]
        |>Enum.map(fn {char1, char2} -> char1 <> char2 end)
        |>Enum.join()
        |>IO.puts()
      end

      def question04() do
        s = "Now I need a drink, alcoholic of course, after the heavy lectures involving quantum mechanics."
        String.replace(s, [",", "."], "") #カンマ、ピリオドを""に置き換え
        |>String.split(" ") #単語ごとに""で区切る
        |>Enum.map(fn word -> String.length(word) end) #単語を文字数に変換
        |>IO.inspect() #出力
        :ok
      end


  end
