defmodule YoganDev.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      YoganDevWeb.Telemetry,
      {Phoenix.PubSub, name: YoganDev.PubSub},
      YoganDev.Article.Cache,
      YoganDev.Content.Cache,
      YoganDevWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: YoganDev.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    YoganDevWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
