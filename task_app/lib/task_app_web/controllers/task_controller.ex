defmodule TaskAppWeb.TaskController do
  use TaskAppWeb, :controller
  alias TaskApp.Tasks

  # http://localhost:4000/tasksというルートにアクセス時、呼び出される
  def index(conn, _params) do
    tasks = Tasks.list_tasks()
    render(conn, :index, tasks: tasks)
  end
end
