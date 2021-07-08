defmodule YoganDevWeb.PageLive do
  use YoganDevWeb, :live_view

  alias YoganDevWeb.LiveEncoder

  @topic "contents"

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      YoganDevWeb.Endpoint.subscribe(@topic)
    end

    {:ok, assign_socket(socket)}
  end

  def render_section(%{type: "hero"} = content) do
    Phoenix.View.render(YoganDevWeb.PageView, "hero.html", content: content)
  end

  def render_section(%{type: "text_and_image"} = content) do
    Phoenix.View.render(YoganDevWeb.PageView, "text_and_image.html", content: content)
  end

  def render_section(%{features: content}) do
    Phoenix.View.render(YoganDevWeb.PageView, "features.html", content: content)
  end

  @impl true
  def handle_info(%{event: "update"}, socket) do
    {:noreply, assign_socket(socket)}
  end

  defp assign_socket(socket) do
    case fetch_contents() do
      {:ok, contents} ->
        socket
        |> assign(:page_title, "Home")
        |> assign(:contents, contents)
        |> put_flash(:error, nil)

      _ ->
        socket
        |> assign(:page_title, "Home")
        |> assign(:contents, nil)
        |> put_flash(:error, "Error fetching data")
    end
  end

  defp fetch_contents do
    with {:ok, contents} <- YoganDev.contents() do
      contents =
        contents
        |> Enum.sort_by(& &1.position)
        |> LiveEncoder.contents()

      {:ok, contents}
    end
  end
end
