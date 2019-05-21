defmodule MonobolyDeal.Game.Server do
  use GenServer

  alias MonobolyDeal.Game
  alias MonobolyDealWeb.Endpoint

  @timeout :timer.hours(2)

  def start_link(game_name, player) do
    GenServer.start_link(__MODULE__, {game_name, player}, name: via_tuple(game_name))
  end

  def join(game_name, player) do
    GenServer.call(via_tuple(game_name), {:join, player})
  end

  def deal_hand(game_name) do
    GenServer.cast(via_tuple(game_name), :deal_hand)
  end

  def game_state(game_name) do
    GenServer.call(via_tuple(game_name), :game_state)
  end

  def player_state(game_name, player) do
    GenServer.call(via_tuple(game_name), {:player_state, player})
  end

  def get_hand(game_name, player) do
    GenServer.call(via_tuple(game_name), {:get_hand, player})
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

  def handle_call({:join, player}, _from, game) do
    case Game.join(game, player) do
      {:ok, updated_game} ->
        {:reply, {:ok, Game.game_state(updated_game)}, updated_game, @timeout}

      {:error, error} ->
        {:reply, {:error, error}, game, @timeout}
    end
  end

  def handle_cast(:deal_hand, game) do
    updated_game = Game.deal(game)
    broadcast_hands(updated_game)
    {:noreply, updated_game, @timeout}
  end

  def handle_call(:game_state, _from, game) do
    {:reply, Game.game_state(game), game, @timeout}
  end

  def handle_call({:player_state, player}, _from, game) do
    {:reply, Game.player_state(game, player), game, @timeout}
  end

  def handle_call({:get_hand, player}, _from, game) do
    {:reply, Game.get_hand(game, player), game, @timeout}
  end

  defp broadcast_hands(game) do
    Enum.each(
      game.players,
      fn player ->
        Endpoint.broadcast!("players:" <> player.name, "player_hand", %{hand: player.hand})
      end
    )
  end
end
