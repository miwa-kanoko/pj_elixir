alias TaskApp.Repo
alias TaskApp.Tasks.Task

tasks = [
  {3,"タスク1", ~D[2024-07-26]},
  {3, "タスク2", ~D[2024-07-26]},
  {3, "タスク3", ~D[2024-07-26]}
]

Enum.each(tasks, fn {user_id, title, date} ->
  Repo.insert!(
    %Task{
      user_id: user_id,
      title: title,
      date: date
     }
  )
end)
