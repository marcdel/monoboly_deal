global_settings = "~/.iex.exs"
if File.exists?(global_settings), do: Code.require_file(global_settings)

import Ecto.{Changeset, Query}

alias MonobolyDeal.Repo
alias MonobolyDealWeb.Router.Helpers, as: Routes

alias MonobolyDeal.Deck
alias MonobolyDeal.Game
alias MonobolyDeal.Game.{Player, Server, Supervisor}

alias MonobolyDeal.Deck.{
  Money,
  Action,
  Rent,
  Property,
  DualProperty,
  WildProperty
}

alias MonobolyDeal.Game.NameGenerator
