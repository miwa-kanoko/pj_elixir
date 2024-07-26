defmodule TaskAppWeb.TaskHTML do
  use TaskAppWeb, :html

  # TaskControllerに対するビュー
  embed_templates "task_html/*"
end
