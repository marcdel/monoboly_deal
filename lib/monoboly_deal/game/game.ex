defmodule MonobolyDeal.Game do
  defstruct [:name, :players, :hands, :discard_pile, :deck, :started]

  alias MonobolyDeal.Deck
  alias MonobolyDeal.Game

  def new(name, player) do
    %Game{
      name: name,
      players: [player],
      hands: %{player.name => []},
      discard_pile: [],
      deck: Deck.shuffle(),
      started: false
    }
  end

  def join(%{started: true} = game, player) do
    case playing?(game, player) do
      false -> {:error, %{error: :game_started, message: "Oops! This game has already started."}}
      true -> {:ok, game}
    end
  end

  def join(game, player) do
    case playing?(game, player) do
      false ->
        {:ok,
         %{game | players: game.players ++ [player], hands: Map.put(game.hands, player.name, [])}}

      true ->
        {:ok, game}
    end
  end

  defp playing?(game, player) do
    Enum.any?(game.players, fn p -> p.name == player.name end)
  end

  def deal(game) do
    game =
      Enum.reduce(
        game.players,
        game,
        fn player, game ->
          {hand, updated_deck} = Enum.split(game.deck, 5)
          updated_hands = %{game.hands | player.name => hand}

          %{game | hands: updated_hands, deck: updated_deck, started: true}
        end
      )

    %{game | started: true}
  end

  def game_state(game) do
    %{
      game_name: game.name,
      players:
        Enum.map(
          game.players,
          fn player ->
            %{name: player.name}
          end
        ),
      started: game.started
    }
  end

  def player_state(game, player) do
    found_player = find_player(game, player)

    %{
      name: found_player.name,
      hand: get_hand(game, found_player)
    }
  end

  def get_hand(game, player) do
    Map.fetch!(game.hands, player.name)
  end

  defp find_player(game, player) do
    Enum.find(game.players, fn p -> p.name == player.name end)
  end
end
