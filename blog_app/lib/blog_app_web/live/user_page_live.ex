# ユーザーのプロフィールページ
  defmodule BlogAppWeb.UserPageLive do
  use BlogAppWeb, :live_view
  alias BlogApp.Accounts
  alias BlogApp.Articles

  # テンプレート
  def render(assigns) do
    ~H"""
    <div class="border-2 rounded-lg px-2 py-4"> <!-- プロフィール部分 -->
      <div class="font-bold text-lg"><%= @user.name %></div>
      <div class="text-gray-600 text-sm"><%= @user.email %></div>
      <div class="whitespace-pre-wrap border-b my-2 pb-2"><%= @user.introduction %></div>
      <div>Articles count : <%= @articles_count %></div>
      <div :if={@user.id == @current_user_id}>
        <.link
          href={~p"/users/settings"}
          class="bg-gray-200 hover:bg-gray-400 py-1 px-4 text-center block w-1/5 mt-2 rounded-lg"
        >
        Edit profile
        </.link>
      </div>
    </div>

    <div> <!-- 記事取得部分 -->
      <div class="flex gap-2 items-center border-b-2 my-2">
        <%
          base_tab_class = ~w(block rounded-t-lg px-2 py-2 text-xl)
          tab_class = fn
            action when @live_action == action -> ~w(bg-gray-400)
            _action -> ~w(bg-gray-200 hover:bg-gray-400)
          end
        %>
        <.link
          href={~p"/users/profile/#{@user}"}
          class={[base_tab_class, tab_class.(:info)]}
        ><!-- 投稿済み記事表示 -->
          Articles
        </.link>

        <.link
          href={~p"/users/profile/#{@user}/draft"}
          class={[base_tab_class, tab_class.(:draft)]}
            :if={@user.id == @ current_user_id}
        > <!-- 下書き記事表示 -->
          Draft
        </.link>
      </div>

      <div> <!-- 投稿済み記事 -->
        <%= if length(@articles) > 0 do %>
          <div :for={article <- @articles}
                class="flex justify-between pb-2 border-b last:border-none cursor-pointer">
            <div :if={@live_action == :info}>
              <.link href={~p"/users/profile/#{article.user_id}"}>
                <!-- userに飛ぶ -->
                <%= article.user.name %>
              </.link>

              <!-- 記事一覧に飛ぶ -->
              <.link href={~p"/articles/show/#{article}"}>
                <div><%= article.submit_date %></div>
                <h2><%= article.title %></h2>
              </.link>
            </div>

            <!-- 記事編集ページに飛ぶ -->
            <.link href={~p"/articles/#{article}/edit"}
            :if={@live_action == :draft}>
              <div><%= article.title %></div>
              <div class="truncate" :if={article.body}>
                <%= article.body %>
              </div>
            </.link>

          <%= if @live_action in [:info, :draft] do %>
            <div
              phx-click="set_article_id"
              phx-value-article_id={article.id}
              :if={@user.id == @current_user_id}
              > <!-- ユーザーID -->
              ...
            </div>

            <div :if={article.id == @ set_article_id}>
              <.link href={~p"/articles/#{article}/edit"}>Edit</.link>
              <span
                phx-click="delete_article"
                phx-value-article_id={article.id}
                >
                Delete
                </span>
            </div>
          <% end %>
          </div>
        <% else %> <!-- 記事がないとき -->
          <div>
            <%=
              case @live_action do
                :info -> "No articles" #投稿済み記事
                :draft -> "No draft articles" #下書き記事
              end
            %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  # socketの中身更新
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"user_id" => user_id}, _uri, socket) do
    socket =
      socket
      |> assign(:user, Accounts.get_user!(user_id))
      |> apply_action(socket.assigns.live_action)
      |> assign(:set_article_id, nil)
    {:noreply, socket}
  end

  defp apply_action(socket, :info) do
    user = socket.assigns.user
    current_user =socket.assigns.current_user
    current_user_id = get_current_user_id(current_user)

    articles =
      Articles.list_articles_for_user(user.id, current_user_id)

    socket
    |> assign(:articles, articles)
    |> assign(:articles_count, Enum.count(articles))
    |> assign(:current_user_id, current_user_id)
    |> assign(:page_title, user.name)
  end

  defp apply_action(socket, :draft) do # 閲覧者とログイン者が同じなら、下書きが見れる（条件分岐）
    user = socket.assigns.user
    current_user =socket.assigns.current_user
    current_user_id = get_current_user_id(current_user)

    if user.id == current_user_id do
      articles_count =
        user.id
        |> Articles.list_articles_for_user(current_user_id)
        |> Enum.count()

        socket
        |> assign(:articles,
        Articles.list_draft_articles_for_user(current_user_id))
        |> assign(:articles_count, articles_count)
        |> assign(:current_user_id, current_user_id)
        |> assign(:page_title, user.name <> "-draft")
    else
      redirect(socket, to: ~p"/users/profile/#{user}")
    end
  end

  def handle_event("set_article_id", %{"article_id" => article_id}, socket) do
    # 3点リーダー
    #開くとき
    # socket.assigns.set_article_id = article_id (同じものが入る)
    # unlessの働きでnil => "1"（1はarticle_id）

    #閉じるとき
    # socket.assigns.set_article_id = article_idがすでにある
    #　unlessがtrueとなり、set_article_id => nil
    id =
      unless article_id == "#{socket.assigns.set_article_id}" do
        String.to_integer(article_id)
      end

      {:noreply, assign(socket, :set_article_id, id)}
  end

  # 3点リーダーからdeleteを押したときの動作
  def handle_event("delete_article", %{"article_id" => article_id}, socket) do
    socket =
    case Articles.delete_article(Articles.get_article!(article_id)) do
      {:ok, _article} ->
        assign_article_when_deleted(socket, socket.assigns.live_action)
      {:error, _cs} ->
        put_flash(socket, :error, "Could not article.")
    end
    {:noreply, socket}
  end

  # 公開記事の削除機能
  defp assign_article_when_deleted(socket, :info) do
    articles =
      Articles.list_articles_for_user(
        socket.assigns.user.id,
        socket.assigns.current_user.id
      )

    socket
    |> assign(:articles, articles)
    |> assign(:articles_count, Enum.count(articles))
    |> put_flash(:info, "Article deleted successfully.")
  end

  # 下書き削除機能
  defp assign_article_when_deleted(socket, :draft) do
    socket
    |> assign(:articles,
    Articles.list_draft_articles_for_user(socket.assigns.current_user.id))
    |> put_flash(:info, "Draft article deleted successfuliy.")
  end

  defp get_current_user_id(current_user) do #current_user_idの取得
    Map.get(current_user || %{}, :id)
    # getでとってくることもできるが、非ログインユーザーがnilで返されてしまうためMap.getを使う
    # 構造体または空の構造体（マップ）を返す
  end
end
