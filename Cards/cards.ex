defmodule Cards do
   def create_deck do
     numbers = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King"]
     suits = ["Spade", "Clover", "Diamond", "Heart"]

    list = for numbers <- numbers do
       for suit <- suits do
         "#{numbers}_of_#{suit}"
         #num <> "_of_" <> suit でもよい
       end
     end
    List.flatten(list)
  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  def deal(deck, deal_size) do
    Enum.split(deck, deal_size)
  end

  def save(deck, file_name) do
    binary = :erlang.term_to_binary(deck)
    File.write(file_name, binary)
  end

  def load(file_name) do
    {status, binary} = File.read(file_name)

    case status do
      :ok -> :erlang.binary_to_term(binary)

      :error -> "Does not exists such a file"
    end
  end



end
