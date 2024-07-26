defmodule TaskApp.Tasks do
  alias TaskApp.Repo
  alias TaskApp.Tasks.Task

  # タスクをすべて取得する関数
  def list_tasks(), do: Repo.all(Task)
end
