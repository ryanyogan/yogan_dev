defmodule YoganDevWeb.Router do
  use YoganDevWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {YoganDevWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", YoganDevWeb do
    pipe_through :browser

    live "/", PageLive
    live "/blog", ArticlesLive
    live "/blog/:id/:slug", ShowArticleLive
  end
end
