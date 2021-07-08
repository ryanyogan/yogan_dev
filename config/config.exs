use Mix.Config

config :yogan_dev, YoganDevWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "AM/hjW2jtkD473LtPxZa12gtAbS/hP532KnPD939liXqatNkbZWiQFe3O9gBCMlJ",
  render_errors: [view: YoganDevWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: YoganDev.PubSub,
  live_view: [signing_salt: "YFUz5Hvn"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :tesla, adapter: Tesla.Adapter.Hackney

config :yogan_dev, YoganDev.Repo, adapter: YoganDev.Repo.Http

import_config "#{Mix.env()}.exs"
