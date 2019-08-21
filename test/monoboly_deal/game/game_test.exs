defmodule MonobolyDeal.GameTest do
  use ExUnit.Case, async: true

  alias MonobolyDeal.Deck
  alias MonobolyDeal.Game
  alias MonobolyDeal.Game.{NameGenerator, Player}

  describe "creating a game" do
    test "sets the game name and adds the creator to the list of players" do
      game_name = NameGenerator.generate()
      player = %{name: "player1"}

      game = Game.new(game_name, player)

      assert game.name == game_name
      assert game.players == [player]
    end

    test "starts with an empty discard pile and a shuffled deck" do
      game_name = NameGenerator.generate()
      player = %{name: "player1"}

      game = Game.new(game_name, player)

      assert game.discard_pile == []

      assert game.deck -- Deck.cards() == []
      refute game.deck == Deck.cards()
    end

    test "starts with empty hands" do
      game_name = NameGenerator.generate()
      player = %{name: "player1"}

      game = Game.new(game_name, player)

      assert game.hands == %{"player1" => []}
    end
  end

  describe "join/2" do
    setup do
      game_name = NameGenerator.generate()
      player1 = %Player{name: "player1"}
      player2 = %Player{name: "player2"}

      game = Game.new(game_name, player1)

      %{
        game_name: game_name,
        game: game,
        player1: player1,
        player2: player2
      }
    end

    test "adds the player to the game", %{game: game, player1: player1, player2: player2} do
      {:ok, game} = Game.join(game, player2)

      assert game.players == [player1, player2]
    end

    test "does not re-add a player that has already joined", %{game: game, player1: player1} do
      {:ok, game} = Game.join(game, player1)

      assert Enum.count(game.players) == 1
      assert [%{name: "player1"}] = game.players
    end

    test "player can rejoin a game that has already started", %{game: game, player1: player1} do
      game = Game.deal(game)

      {:ok, game} = Game.join(game, player1)

      assert Enum.count(game.players) == 1
      assert [%{name: "player1"}] = game.players
    end

    test "returns an error when new player joins an in progress game", %{
      game: game,
      player2: player2
    } do
      game = Game.deal(game)

      {:error, error} = Game.join(game, player2)

      assert error == %{error: :game_started, message: "Oops! This game has already started."}

      game_state = Game.game_state(game)
      assert Enum.count(game_state.players) == 1
      assert [%{name: "player1"}] = game_state.players
    end
  end

  describe "dealing a hand" do
    setup do
      game_name = NameGenerator.generate()
      player1 = %Player{name: "player1"}
      player2 = %Player{name: "player2"}

      game = Game.new(game_name, player1)
      {:ok, game} = Game.join(game, player2)

      %{
        game_name: game_name,
        game: game,
        player1: player1,
        player2: player2
      }
    end

    test "the game is not started until a hand is dealt", %{game: game} do
      assert game.started == false

      game = Game.deal(game)

      assert game.started == true
    end

    test "each player is dealt a hand of 5 cards", %{game: game} do
      game = Game.deal(game)
      assert Enum.count(game.hands["player1"]) == 5
      assert Enum.count(game.hands["player2"]) == 5
    end

    test "dealt cards are removed from the deck", %{game: game} do
      assert Enum.count(game.deck) == 106
      game = Game.deal(game)
      assert Enum.count(game.deck) == 96
    end

    test "chooses a player to have the first turn", %{
      game: game,
      player1: player1,
      player2: player2
    } do
      game = Game.deal(game)
      %{current_turn: current_turn} = Game.game_state(game)

      case current_turn.player do
        ^player1 ->
          assert Game.player_state(game, player1).my_turn == true

        ^player2 ->
          assert Game.player_state(game, player2).my_turn == true

        _ ->
          flunk(
            "Expected player1 or player2 to be the current turn, but was #{
              inspect(current_turn.player)
            }"
          )
      end
    end
  end

  describe "drawing cards" do
    setup do
      game_name = NameGenerator.generate()
      player1 = %Player{name: "player1"}
      player2 = %Player{name: "player2"}

      game =
        game_name
        |> Game.new(player1)
        |> Game.join(player2)
        |> (fn {:ok, game} -> Game.deal(game) end).()

      %{
        game_name: game_name,
        game: game,
        player1: player1,
        player2: player2
      }
    end

    test "draws two cards into the player's hand", %{game: game} do
      game = Game.draw_cards(game, game.current_turn.player)
      assert Enum.count(Game.player_state(game, game.current_turn.player).hand) == 7
      assert Enum.count(Game.game_state(game).current_turn.drawn_cards) == 2
    end

    test "does nothing when not your turn", %{game: game, player1: player1, player2: player2} do
      wrong_player = if game.current_turn.player == player1, do: player2, else: player1
      game = Game.draw_cards(game, wrong_player)
      assert Enum.count(Game.player_state(game, wrong_player).hand) == 5
    end

    test "does nothing if you've already drawn 2 cards", %{game: game} do
      game = Game.draw_cards(game, game.current_turn.player)
      game = Game.draw_cards(game, game.current_turn.player)

      assert Enum.count(Game.player_state(game, game.current_turn.player).hand) == 7
      assert Enum.count(Game.game_state(game).current_turn.drawn_cards) == 2
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
    game_name = NameGenerator.generate()
    player1 = %Player{name: "player1"}
    player2 = %Player{name: "player2"}

    game_name
    |> Game.new(player1)
    |> Game.join(player2)
    |> (fn {:ok, game} -> game end).()
    |> Game.deal()
  end
end
