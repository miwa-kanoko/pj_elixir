import Config

# データベース接続に必要な構成を生成
config :example, Example.Repo,
  database: "example_repo", # データベースを指定
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

  config :example, ecto_repos: [Example.Repo]

  #DBのデータをElixirで使用する上での形式を設定　みたいな。
