defmodule MonobolyDeal.Game.Server do
  use GenServer

  alias MonobolyDeal.Game
  alias MonobolyDealWeb.Endpoint

  @timeout :timer.hours(2)

  def start_link(game_name, player_name) do
    GenServer.start_link(__MODULE__, {game_name, player_name}, name: via_tuple(game_name))
  end

  def join(game_name, player_name) do
    GenServer.call(via_tuple(game_name), {:join, player_name})
  end

  def playing?(game_name, player_name) do
    GenServer.call(via_tuple(game_name), {:playing?, player_name})
  end

  def deal_hand(game_name) do
    GenServer.call(via_tuple(game_name), :deal_hand)
  end

  def draw_cards(game_name, player_name) do
    GenServer.call(via_tuple(game_name), {:draw_cards, player_name})
  end

  def choose_card(game_name, player_name, card_id) do
    GenServer.call(via_tuple(game_name), {:choose_card, player_name, card_id})
  end

  def place_card_bank(game_name, player_name) do
    GenServer.call(via_tuple(game_name), {:place_card_bank, player_name})
  end

  def game_state(game_name) do
    GenServer.call(via_tuple(game_name), :game_state)
  end

  def player_state(game_name, player_name) do
    GenServer.call(via_tuple(game_name), {:player_state, player_name})
  end

  def get_hand(game_name, player_name) do
    GenServer.call(via_tuple(game_name), {:get_hand, player_name})
  end

  def game_pid(game_name) do
    game_name
    |> via_tuple()
    |> GenServer.whereis()
  end

  def via_tuple(game_name) do
    {:via, Registry, {MonobolyDeal.GameRegistry, game_name}}
  end

  def init({game_name, player_name}) do
    game =
      case :ets.lookup(:games_table, game_name) do
        [] ->
          game = Game.new(game_name, player_name)
          :ets.insert(:games_table, {game_name, game})
          game

        [{^game_name, game}] ->
          game
      end

    {:ok, game, @timeout}
  end

  def handle_call(:deal_hand, _from, game) do
    updated_game = Game.deal(game)
    {:reply, {:ok, updated_game}, updated_game, @timeout}
  end

  def handle_call({:draw_cards, player_name}, _from, game) do
    updated_game = Game.draw_cards(game, player_name)
    {:reply, {:ok, updated_game}, updated_game, @timeout}
  end

  def handle_call({:choose_card, player_name, card_id}, _from, game) do
    case Game.choose_card(game, player_name, card_id) do
      {:ok, updated_game} ->
        {:reply, {:ok, updated_game}, updated_game, @timeout}

      {:error, error} ->
        {:reply, {:error, error}, game, @timeout}
    end
  end

  def handle_call({:place_card_bank, player_name}, _from, game) do
    case Game.place_card_bank(game, player_name) do
      {:ok, updated_game} ->
        {:reply, {:ok, updated_game}, updated_game, @timeout}

      {:error, error} ->
        {:reply, {:error, error}, game, @timeout}
    end
  end

  def handle_call({:join, player_name}, _from, game) do
    case Game.join(game, player_name) do
      {:ok, updated_game} ->
        {:reply, {:ok, Game.game_state(updated_game)}, updated_game, @timeout}

      {:error, error} ->
        {:reply, {:error, error}, game, @timeout}
    end
  end

  def handle_call({:playing?, player_name}, _from, game) do
    case Game.find_player(game, player_name) do
      nil -> {:reply, {:ok, false}, game, @timeout}
      _ -> {:reply, {:ok, true}, game, @timeout}
    end
  end

  def handle_call(:game_state, _from, game) do
    {:reply, Game.game_state(game), game, @timeout}
  end

  def handle_call({:player_state, player_name}, _from, game) do
    {:reply, Game.player_state(game, player_name), game, @timeout}
  end

  def handle_call({:get_hand, player_name}, _from, game) do
    {:reply, Game.get_hand(game, player_name), game, @timeout}
  end
end
