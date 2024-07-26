defmodule TodoAppWeb.HelloController do
  # コントローラー作成に便利なモジュールをインポート
  use TodoAppWeb, :controller

  def hello(conn, _params) do
    render(conn, :hello)
  end
end
