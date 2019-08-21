defmodule MonobolyDeal.Game do
  defstruct [
    :name,
    :players,
    :hands,
    :discard_pile,
    :deck,
    :started,
    :current_turn
  ]

  alias MonobolyDeal.Deck
  alias MonobolyDeal.Game
  alias MonobolyDeal.Game.Turn

  def new(name, player) do
    %Game{
      name: name,
      players: [player],
      hands: %{player.name => []},
      discard_pile: [],
      deck: Deck.shuffle(),
      started: false,
      current_turn: nil
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

  def draw_cards(
        %{current_turn: %{player: %{name: name}, drawn_cards: []}} = game,
        %{name: name} = player
      ) do
    {cards, updated_deck} = Enum.split(game.deck, 2)
    player_hand = get_hand(game, player)
    updated_hands = %{game.hands | player.name => player_hand ++ cards}

    %{
      game
      | hands: updated_hands,
        deck: updated_deck,
        current_turn: %{game.current_turn | drawn_cards: cards}
    }
  end

  def draw_cards(game, _), do: game

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

    %{game | started: true, current_turn: Turn.new(Enum.random(game.players))}
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
      started: game.started,
      current_turn: game.current_turn
    }
  end

  def player_state(game, player) do
    game
    |> find_player(player)
    |> build_player_state(game)
  end

  def get_hand(game, player) do
    Map.fetch!(game.hands, player.name)
  end

  def find_player(game, player) do
    Enum.find(game.players, fn p -> p.name == player.name end)
  end

  defp build_player_state(nil, _), do: nil

  defp build_player_state(player, %{current_turn: nil} = game) do
    %{
      name: player.name,
      hand: get_hand(game, player),
      my_turn: false
    }
  end

  defp build_player_state(player, game) do
    %{
      name: player.name,
      hand: get_hand(game, player),
      my_turn: game.current_turn.player == player
    }
  end
end
