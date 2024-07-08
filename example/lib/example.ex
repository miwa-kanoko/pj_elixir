defmodule Example do
def hello_world do
  IO.inspect("Hello, World")
end

def matching(num) do
  case num do
    1 -> "Not Found!"
    2 -> "Matched!"
    3 -> "Not Found"
    4 -> "Not Found"
    5 -> "Matched!"
    6 -> "Not Found"
    7 -> "Not Found"
  end
end

def matching(num) do
  case num do
    n when n in [1, 3, 4, 6, 7] ->"Not Found"
    n when n in [2, 5] -> "Matched!"
  end
end

def func(n) when is_integer(n) do
  n + 1
end


end
