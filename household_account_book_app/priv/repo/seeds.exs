# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     HouseholdAccountBookApp.Repo.insert!(%HouseholdAccountBookApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias HouseholdAccountBookApp.Repo
alias HouseholdAccountBookApp.Purchases.Category
categories = [
  {"住宅費", "#dc143c"},
  {"⽔道光熱費", "#00bfff"},
  {"通信費", "#f0e68c"},
  {"交通費", "#ee82ee"},
  {"⾷費", "#008000"},
  {"⽇⽤品", "#00fa9a"},
  {"医療費", "#ff7f50"},
  {"交際費", "#ff69b4"},
  {"娯楽費", "#4169e1"},
  {"雑費", "#9acd32"},
]

Enum.each(categories, fn {category_name, color_code} ->
  Repo.insert!(
  %Category{
    category_name: category_name,
    color_code: color_code
    }
  )
end)
