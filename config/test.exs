use Mix.Config

# Configure your database
config :monoboly_deal, MonobolyDeal.Repo,
  username: "postgres",
  password: "postgres",
  database: "monoboly_deal_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :monoboly_deal, MonobolyDealWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
