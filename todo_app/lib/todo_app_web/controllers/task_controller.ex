defmodule TodoAppWeb.TaskController do
  use TodoAppWeb, :controller

  alias TodoApp.Tasks

  def index(conn, _params) do
    tasks = Tasks.list_tasks()

    render(conn, :index, tasks: tasks)

  end

  def new(conn, params) do
    cs = Tasks.changeset_task(%Tasks.Task{})

    render(conn, :new, changeset :cs)
  end

  def create(conn, params) do
  end
end
