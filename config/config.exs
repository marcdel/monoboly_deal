# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :monoboly_deal,
  ecto_repos: [MonobolyDeal.Repo]

# Configures the endpoint
config :monoboly_deal, MonobolyDealWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "G8sLnh/DXsCkTYkGPDFTLeb3ghWHu0uEEorSWsiRU9GzKZbLprlhVv7FpY22tGI1",
  render_errors: [view: MonobolyDealWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MonobolyDeal.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "EQu3hXRq7cU+pNqZBpAeMivAlPURE1nuWwzMMKROInKG6He4s5C8oGqWEvQPbX3A"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Use LiveView engine for leex files
config :phoenix, template_engines: [leex: Phoenix.LiveView.Engine]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
