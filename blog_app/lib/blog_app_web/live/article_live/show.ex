defmodule BlogAppWeb.ArticleLive.Show do
  use BlogAppWeb, :live_view

  alias BlogApp.Articles

  # 記事一覧
  def render(assigns) do
    ~H"""
    <div :if={@article.status == 2}>
      This is a limited article.
    </div>

    <div>
      <.link href={~p"/users/profile/#{@article.user}"}
      class="hover:underline"> <!-- プロフィールに飛ぶ -->
        <%= @article.user.name %>
      </.link>
      <div class="text-xs text-gray-600"><%= @article.submit_date %></div>
      <h2 class="my-2 font-bold text-2xl"><%= @article.title %></h2>
      <div class="whitespace-pre-wrap my-2"><%= @article.body %></div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"article_id" => article_id}, _uri, socket) do
    article = Articles.get_article!(article_id)

    socket =
      if article.status in [1, 2] do
        socket
        |> assign(:article, article)
        |> assign(:page_title, article.title)
      else
        redirect(socket, to: ~p"/")
      end

      {:noreply, socket}
  end

end
