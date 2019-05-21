defmodule MonobolyDeal.Game do
  defstruct [:name, :players, :discard_pile, :deck, :started]

  alias MonobolyDeal.Deck
  alias MonobolyDeal.Game

  def new(name, player) do
    %Game{
      name: name,
      players: [player],
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
      false -> {:ok, %{game | players: game.players ++ [player]}}
      true -> {:ok, game}
    end
  end

  defp playing?(game, player) do
    Enum.any?(game.players, fn p -> p.name == player.name end)
  end

  def deal(game) do
    {players, deck} =
      Enum.map_reduce(
        game.players,
        game.deck,
        fn player, deck ->
          {hand, updated_deck} = Enum.split(deck, 5)
          updated_player = %{player | hand: hand}

          {updated_player, updated_deck}
        end
      )

    %{game | players: players, deck: deck, started: true}
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
      hand: found_player.hand
    }
  end

  def get_hand(game, player) do
    found_player = find_player(game, player)
    found_player.hand
  end

  defp find_player(game, player) do
    Enum.find(game.players, fn p -> p.name == player.name end)
  end
end
