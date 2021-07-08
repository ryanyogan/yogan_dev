defmodule YoganDevWeb.ShowArticleLive do
  use YoganDevWeb, :live_view

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok, assign_socket(socket, id)}
  end

  defp assign_socket(socket, id) do
    case YoganDev.get_article(id) do
      {:ok, article} ->
        socket
        |> assign(:page_title, article.title)
        |> assign(:article, article)
        |> put_flash(:error, nil)

      {:error, _} ->
        socket
        |> assign(:page_title, "Blog")
        |> assign(:article, nil)
        |> put_flash(:error, "Error fetching article")
    end
  end
end
