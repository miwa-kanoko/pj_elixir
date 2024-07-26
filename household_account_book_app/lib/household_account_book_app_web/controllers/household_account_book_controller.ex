defmodule HouseholdAccountBookAppWeb.HouseholdAccountBookController do
  use HouseholdAccountBookAppWeb, :controller
  alias HouseholdAccountBookApp.Purchases
  alias HouseholdAccountBookApp.Incomes

  def summary(conn, %{"date" => date}) do
    #date = "2024-03 => %Date{year: 2024, month: 3, day: 1}にしたい
    [year, month] =
    date
    |> String.split("-") #  ["2024", "03"]に分けた
    |> Enum.map(& String.to_integer/1) # [2024, 3] というリスト化

    date = Date.new!(year, month, 1)


    sum_incomes = Incomes.sum_incomes_by_month(date)
    money_by_categories = date |> Purchases.get_money_by_categories() |> set_balance(sum_incomes)

    render(
      conn,
       :summary,
        money_by_categories: money_by_categories,
        date: date,
        pie_chart_data: create_pie_chart_data(money_by_categories),
        bar_chart_data: create_bar_chart_data(date)
    )
  end

  def summary(conn, _params) do
    date = Date.utc_today()

    sum_incomes = Incomes.sum_incomes_by_month(date)
    money_by_categories = date |> Purchases.get_money_by_categories() |> set_balance(sum_incomes)

    render(
      conn,
       :summary,
        money_by_categories: money_by_categories,
        date: date,
        pie_chart_data: create_pie_chart_data(money_by_categories),
        bar_chart_data: create_bar_chart_data(date)
    )
  end

  defp set_balance(money_by_categories, sum_incomes) do
    sum_purchases = money_by_categories |> Enum.map(fn{_category, money} -> money end) |> Enum.sum()
    balance =
      then(sum_incomes - sum_purchases, fn balance -> if balance > 0, do: balance, else: 0 end)
      List.insert_at(money_by_categories, -1, {%{category_name: "残高", color_code: "#d3d3d3"}, balance})
  end

  #円グラフ用データ変換（Jason）
  defp create_pie_chart_data(money_by_categories) do
    categories = Enum.map(money_by_categories, fn{category, _money} -> category.category_name end)
    color_code = Enum.map(money_by_categories, fn{category, _money} -> category.color_code end)
    money = Enum.map(money_by_categories, fn{_category, money} -> money end)
    Jason.encode!(%{categories: categories, color_code: color_code, money: money})
  end

  #棒グラフ用データ変換（Jason）
  defp create_bar_chart_data(date) do
    money_by_date = Purchases.get_money_by_date(date)
    date = Enum.map(money_by_date, fn{date, _money} -> date end)
    money = Enum.map(money_by_date, fn{_date, money} -> money end)
    Jason.encode!(%{date: date, money: money})
  end

end
