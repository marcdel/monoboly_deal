defmodule MonobolyDeal.Repo do
  use Ecto.Repo,
    otp_app: :monoboly_deal,
    adapter: Ecto.Adapters.Postgres
end
