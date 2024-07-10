defmodule ExUnit2 do
  def increment(n), do: n + 1
  def decrement(n), do: n - 1
  end
  ExUnit. start()
  defmodule ExUnit2Test do
  use ExUnit.Case
  describe "整数に1を加えるグループ" do
  test "100を渡すと101が返される" do
  assert ExUnit2.increment(100) == 101
  end
  test "99を渡すと100が返される" do
  assert ExUnit2.increment(99) == 100
  end
  test "0を渡すと1が返される" do
  assert ExUnit2.increment(0) == 1
  end
  end
  describe "整数から1を引くグループ" do
  test "100を渡すと99が返される" do
  assert ExUnit2.decrement(100) == 99
  end
  end
  end
