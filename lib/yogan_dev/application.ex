defmodule YoganDev.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      YoganDevWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: YoganDev.PubSub},
      # Start the Endpoint (http/https)
      YoganDevWeb.Endpoint
      # Start a worker by calling: YoganDev.Worker.start_link(arg)
      # {YoganDev.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: YoganDev.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    YoganDevWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
