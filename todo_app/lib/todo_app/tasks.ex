defmodule TodoApp.Tasks do
  alias TodoApp.Repo
  alias TodoApp.Tasks.Task

  #DBのタスクを全取得する関数
  def list_tasks(), do: Repo.all(Task)

  #新しいタスクをDB登録する関数
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  #tasksスキーマのEcto.Changesetを返す関数
  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

end
