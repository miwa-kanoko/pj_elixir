defmodule Parallel do
  def pmap(collection, fun) do
    me = self()
    collection
    |> Enum.map(fn elem ->
      spawn_link(fn -> send(me, {self(), fun.(elem)}) end)
   end)
    |> Enum.map(fn pid ->
  :timer.sleep(round(:rand.uniform * 50))
  receive do
   {^pid, result} -> result
    end
    end)
  end
end
