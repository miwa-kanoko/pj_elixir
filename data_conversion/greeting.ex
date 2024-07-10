defmodule Greeting do
  defmacro __using__(_opts) do
    quote do
      def greeting(name), do: "Hi, #{name}"
    end
  end
end
