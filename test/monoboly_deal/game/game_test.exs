defmodule MonobolyDeal.GameTest do
  use ExUnit.Case, async: true

  alias MonobolyDeal.Deck
  alias MonobolyDeal.Game
  alias MonobolyDeal.Game.{NameGenerator, Player}

  describe "creating a game" do
    test "sets the game name and adds the creator to the list of players" do
      game_name = NameGenerator.generate()
      game = Game.new(game_name, "player1")
      assert game.name == game_name
      assert game.players == [Game.find_player(game, "player1")]
    end

    test "starts with an empty discard pile and a shuffled deck" do
      game_name = NameGenerator.generate()
      game = Game.new(game_name, "player1")

      assert game.discard_pile == []
      assert Enum.count(game.deck) == Enum.count(Deck.new())
    end

    test "starts with empty hands" do
      game_name = NameGenerator.generate()
      game = Game.new(game_name, "player1")
      assert Game.player_state(game, %{name: "player1"}).hand == []
    end
  end

  describe "join/2" do
    setup do
      game = Game.new(NameGenerator.generate(), "player1")
      %{game: game}
    end

    test "adds the player to the game", %{game: game} do
      {:ok, game} = Game.join(game, "player2")
      assert [%{name: "player1"}, %{name: "player2"}] = game.players
    end

    test "does not re-add a player that has already joined", %{game: game} do
      {:ok, game} = Game.join(game, "player1")

      assert Enum.count(game.players) == 1
      assert [%{name: "player1"}] = game.players
    end

    test "player can rejoin a game that has already started", %{game: game} do
      game = Game.deal(game)

      {:ok, game} = Game.join(game, "player1")

      assert Enum.count(game.players) == 1
      assert [%{name: "player1"}] = game.players
    end

    test "returns an error when new player joins an in progress game", %{game: game} do
      game = Game.deal(game)

      {:error, error} = Game.join(game, "player2")

      assert error == %{error: :game_started, message: "Oops! This game has already started."}

      game_state = Game.game_state(game)
      assert Enum.count(game_state.players) == 1
      assert [%{name: "player1"}] = game_state.players
    end
  end

  describe "dealing a hand" do
    setup do
      {:ok, game} =
        NameGenerator.generate()
        |> Game.new("player1")
        |> Game.join("player2")

      %{game: game}
    end

    test "the game is not started until a hand is dealt", %{game: game} do
      assert game.started == false

      game = Game.deal(game)

      assert game.started == true
    end

    test "each player is dealt a hand of 5 cards", %{game: game} do
      game = Game.deal(game)
      assert Enum.count(Game.find_player(game, "player1").hand) == 5
      assert Enum.count(Game.find_player(game, "player2").hand) == 5
    end

    test "dealt cards are removed from the deck", %{game: game} do
      assert Enum.count(game.deck) == 106
      game = Game.deal(game)
      assert Enum.count(game.deck) == 96
    end

    test "chooses a player to have the first turn", %{game: game} do
      game = Game.deal(game)
      assert Game.game_state(game).current_turn != nil
    end
  end

  describe "drawing cards" do
    setup do
      game =
        NameGenerator.generate()
        |> Game.new("player1")
        |> Game.join("player2")
        |> (fn {:ok, game} -> Game.deal(game) end).()

      %{game: game}
    end

    test "draws two cards into the player's hand", %{game: game} do
      game = Game.draw_cards(game, game.current_turn.player.name)
      assert Enum.count(Game.player_state(game, game.current_turn.player).hand) == 7
      assert Enum.count(Game.game_state(game).current_turn.drawn_cards) == 2
    end

    test "does nothing when not your turn", %{game: game} do
      wrong_player =
        if Game.compare_players(game.current_turn.player, %{name: "player1"}),
          do: "player2",
          else: "player1"

      game = Game.draw_cards(game, wrong_player)
      assert Enum.count(Game.player_state(game, %{name: wrong_player}).hand) == 5
    end

    test "does nothing if you've already drawn 2 cards", %{game: game} do
      game = Game.draw_cards(game, game.current_turn.player.name)
      game = Game.draw_cards(game, game.current_turn.player.name)

      assert Enum.count(Game.player_state(game, game.current_turn.player).hand) == 7
      assert Enum.count(Game.game_state(game).current_turn.drawn_cards) == 2
    end
  end

  describe "choosing a card" do
    setup do
      game_name = NameGenerator.generate()

      game =
        game_name
        |> Game.new("player1")
        |> Game.deal()
        |> Game.draw_cards("player1")

      %{game: game, player1: Game.find_player(game, "player1")}
    end

    test "must be player's turn", %{game: game} do
      player2 = Player.new("player2")
      {:error, :not_your_turn} = Game.choose_card(game, player2, "the card id")
    end

    test "must draw 2 cards before playing cards from your hand", %{game: game, player1: player1} do
      game = %{game | current_turn: %{game.current_turn | drawn_cards: []}}
      {:error, :draw_cards} = Game.choose_card(game, player1, "the card id")
    end

    test "sets the chosen card in the current turn", %{game: game, player1: player1} do
      [card | _] = Game.get_hand(game, player1)

      {:ok, game} = Game.choose_card(game, player1, card.id)

      assert game.current_turn.player.name == player1.name
      assert game.current_turn.chosen_card == card
      assert [_, _] = game.current_turn.drawn_cards
    end
  end

  describe "placing a card in your bank" do
    setup do
      game_name = NameGenerator.generate()
      player1 = Player.new("player1")

      {game, card} =
        game_name
        |> Game.new("player1")
        |> Game.deal()
        |> Game.draw_cards("player1")
        |> (fn game ->
              [card | _] = Game.get_hand(game, player1)
              {:ok, game} = Game.choose_card(game, player1, card.id)
              {game, card}
            end).()

      %{
        game: game,
        card: card,
        player1: player1
      }
    end

    test "must be player's turn", %{game: game} do
      player2 = Player.new("player2")
      {:error, :not_your_turn} = Game.place_card_bank(game, player2)
    end

    test "must have chosen a card", %{game: game, player1: player1} do
      game = %{game | current_turn: %{game.current_turn | chosen_card: nil}}
      {:error, :choose_card} = Game.place_card_bank(game, player1)
    end

    test "moves the chosen card to your bank", %{game: game, card: card, player1: player1} do
      {:ok, game} = Game.place_card_bank(game, player1)
      player_state = Game.player_state(game, player1)

      assert player_state.bank == [card]
      assert player_state.bank_total == card.value
      assert Game.find_card(game, player1, card.id) == nil
      assert game.current_turn.chosen_card == nil
    end
  end

  describe "getting the game state" do
    test "returns the game state for all players" do
      game_state =
        create_started_game()
        |> Game.game_state()

      assert %{
               game_name: game_name,
               players: [%{name: "player1"}, %{name: "player2"}],
               started: true
             } = game_state
    end
  end

  describe "getting the player state" do
    test "returns the player state for the current player" do
      player_state =
        create_started_game()
        |> Game.player_state(%{name: "player2"})

      assert player_state.name == "player2"
      assert Enum.count(player_state.hand) == 5
    end

    test "returns nil for unknown player" do
      player_state =
        create_started_game()
        |> Game.player_state(%{name: "player3"})

      assert player_state == nil
    end
  end

  describe "getting a players hand" do
    test "returns the hand of the specified player" do
      hand =
        create_started_game()
        |> Game.get_hand(%{name: "player2"})

      assert Enum.count(hand) == 5
    end
  end

  defp create_started_game do
    NameGenerator.generate()
    |> Game.new("player1")
    |> Game.join("player2")
    |> (fn {:ok, game} -> game end).()
    |> Game.deal()
  end
end
