defmodule MonobolyDeal.Game do
  # Most of the time I don't want to see the entire deck in the output
  @derive {Inspect, except: [:deck]}

  defstruct [
    :name,
    :players,
    :discard_pile,
    :deck,
    :started,
    :current_turn
  ]

  alias MonobolyDeal.Deck
  alias MonobolyDeal.Game
  alias MonobolyDeal.Game.{Player, Turn}

  def new(game_name, player_name) do
    player = Player.new(player_name)

    %Game{
      name: game_name,
      players: %{player.name => player},
      discard_pile: [],
      deck: Deck.new() |> Deck.shuffle(),
      started: false,
      current_turn: Turn.new(nil)
    }
  end

  def join(%{started: true} = game, player_name) do
    case playing?(game, player_name) do
      false -> {:error, %{error: :game_started, message: "Oops! This game has already started."}}
      true -> {:ok, game}
    end
  end

  def join(game, player_name) do
    case playing?(game, player_name) do
      false ->
        {:ok, %{game | players: Map.put_new(game.players, player_name, Player.new(player_name))}}

      true ->
        {:ok, game}
    end
  end

  def deal(game) do
    game =
      game.players
      |> Map.values()
      |> Enum.reduce(game, fn player, game ->
        {hand, updated_deck} = Enum.split(game.deck, 5)
        game = add_cards_to_player_hand(game, player.name, hand)

        %{game | deck: updated_deck, started: true}
      end)

    next_turn = game.players |> Map.values() |> Enum.random() |> Turn.new()

    %{game | started: true, current_turn: next_turn}
  end

  def draw_cards(%{current_turn: %{player: %{name: p1}}} = game, p2) when p1 != p2 do
    # IO.inspect({:error, :not_your_turn})
    game
  end

  def draw_cards(%{current_turn: %{drawn_cards: [_, _]}} = game, _) do
    # IO.inspect({:error, :already_drawn_cards})
    game
  end

  def draw_cards(game, player_name) do
    {cards, updated_deck} = Enum.split(game.deck, 2)
    game = add_cards_to_player_hand(game, player_name, cards)
    %{game | deck: updated_deck, current_turn: %{game.current_turn | drawn_cards: cards}}
  end

  def choose_card(%{current_turn: %{player: %{name: p1}}}, p2, _) when p1 != p2 do
    {:error, :not_your_turn}
  end

  def choose_card(%{current_turn: %{drawn_cards: []}}, _, _), do: {:error, :draw_cards}

  def choose_card(game, player_name, card_id) do
    card = Game.find_card(game, player_name, card_id)
    {:ok, %{game | current_turn: %{game.current_turn | chosen_card: card}}}
  end

  def place_card_bank(%{current_turn: %{chosen_card: nil}}, _) do
    {:error, :choose_card}
  end

  def place_card_bank(%{current_turn: %{player: %{name: p1}}}, p2) when p1 != p2 do
    {:error, :not_your_turn}
  end

  def place_card_bank(game, player_name) do
    card = game.current_turn.chosen_card
    player = find_player(game, player_name)
    updated_players = Map.put(game.players, player_name, Player.add_to_bank(player, card))

    {:ok,
     %{
       game
       | players: updated_players,
         current_turn: %{game.current_turn | chosen_card: nil}
     }}
  end

  def find_card(game, player_name, card_id) do
    hand = get_hand(game, player_name)
    Enum.find(hand, fn card -> card.id == card_id end)
  end

  def player_state(game, player_name) do
    player = find_player(game, player_name)
    build_player_state(game, player)
  end

  def get_hand(game, player_name) do
    find_player(game, player_name).hand
  end

  def find_player(game, player_name) do
    Map.get(game.players, player_name)
  end

  def whose_turn(%{current_turn: %{player: nil}}), do: ""

  def whose_turn(game) do
    game.current_turn.player.name
  end

  defp add_cards_to_player_hand(game, player_name, cards) do
    player = find_player(game, player_name)
    updated_players = Map.put(game.players, player_name, Player.add_to_hand(player, cards))

    %{game | players: updated_players}
  end

  defp playing?(game, player_name) do
    Map.has_key?(game.players, player_name)
  end

  defp build_player_state(_, nil), do: nil

  defp build_player_state(%{current_turn: %{player: nil}} = game, player) do
    %{
      name: player.name,
      bank: player.bank,
      bank_total: player.bank_total,
      hand: get_hand(game, player.name),
      my_turn: false
    }
  end

  defp build_player_state(game, player) do
    %{
      name: player.name,
      bank: player.bank,
      bank_total: player.bank_total,
      hand: get_hand(game, player.name),
      my_turn: game.current_turn.player == player
    }
  end
end
