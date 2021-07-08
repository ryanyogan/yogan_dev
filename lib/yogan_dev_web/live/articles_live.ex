defmodule YoganDevWeb.ArticlesLive do
  use YoganDevWeb, :live_view

  alias YoganDevWeb.LiveEncoder

  @topic "articles"

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      YoganDevWeb.Endpoint.subscribe(@topic)
    end

    {:ok, assign_socket(socket)}
  end

  def render_article(socket, %{id: _id, slug: _slug} = article) do
    Phoenix.View.render(YoganDevWeb.PageView, "article.html", socket: socket, article: article)
  end

  @impl true
  def handle_info(%{event: "update"}, socket) do
    {:noreply, assign_socket(socket)}
  end

  defp assign_socket(socket) do
    case fetch_articles() do
      {:ok, articles} ->
        socket
        |> assign(:page_title, "Blog")
        |> assign(:articles, articles)
        |> put_flash(:error, nil)

      _ ->
        socket
        |> assign(:page_title, "Blog")
        |> assign(:articles, nil)
        |> put_flash(:error, "Error fetching articles")
    end
  end

  defp fetch_articles do
    with {:ok, articles} <- YoganDev.articles() do
      articles
      |> Enum.sort_by(& &1.published_at)
      |> LiveEncoder.articles()

      {:ok, articles}
    end
  end
end
