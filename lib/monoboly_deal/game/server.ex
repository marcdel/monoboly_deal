defmodule MonobolyDeal.Game.Server do
  use GenServer

  alias MonobolyDeal.Game

  @timeout :timer.hours(2)

  def start_link(game_name, player) do
    GenServer.start_link(__MODULE__, {game_name, player}, name: via_tuple(game_name))
  end

  def game_pid(game_name) do
    game_name
    |> via_tuple()
    |> GenServer.whereis()
  end

  def via_tuple(game_name) do
    {:via, Registry, {MonobolyDeal.GameRegistry, game_name}}
  end

  def init({game_name, player}) do
    game =
      case :ets.lookup(:games_table, game_name) do
        [] ->
          game = Game.new(game_name, player)
          :ets.insert(:games_table, {game_name, game})
          game

        [{^game_name, game}] ->
          game
      end

    {:ok, game, @timeout}
  end
end