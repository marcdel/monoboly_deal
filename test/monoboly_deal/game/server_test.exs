defmodule MonobolyDeal.Game.ServerTest do
  use ExUnit.Case, async: true

  alias MonobolyDeal.Game
  alias MonobolyDeal.Game.{NameGenerator, Server}

  test "spawning a game server process" do
    game_name = NameGenerator.generate()

    assert {:ok, pid} = Server.start_link(game_name, "player1")

    game = :sys.get_state(pid)
    assert game.name == game_name
    assert Game.find_player(game, "player1")
    assert game.discard_pile == []
    assert Enum.count(game.deck) == 106
  end

  test "a game process is registered under a unique name" do
    game_name = NameGenerator.generate()

    assert {:ok, _pid} = Server.start_link(game_name, "player1")
    assert {:error, _reason} = Server.start_link(game_name, "player1")
  end

  describe "game_pid" do
    test "returns a PID if it has been registered" do
      game_name = NameGenerator.generate()

      {:ok, pid} = Server.start_link(game_name, %{name: "player1"})

      assert ^pid = Server.game_pid(game_name)
    end

    test "returns nil if the game does not exist" do
      refute Server.game_pid("nonexistent-game")
    end
  end

  describe "join" do
    test "adds the player to the specified game" do
      game_name = NameGenerator.generate()
      {:ok, _pid} = Server.start_link(game_name, "player1")

      {:ok, game} = Server.join(game_name, "player2")

      assert %{"player1" => %{name: "player1"}, "player2" => %{name: "player2"}} = game.players
    end

    test "does nothing when player has already been added" do
      game_name = NameGenerator.generate()
      {:ok, _pid} = Server.start_link(game_name, "player1")

      {:ok, game} = Server.join(game_name, "player1")

      assert %{"player1" => %{name: "player1"}} = game.players
    end

    test "returns an error when the game has already started" do
      game_name = NameGenerator.generate()
      {:ok, _pid} = Server.start_link(game_name, "player1")
      {:ok, _} = Server.deal(game_name)

      {:error, error} = Server.join(game_name, "player2")

      game = Server.game(game_name)
      assert %{"player1" => %{name: "player1"}} = game.players
      assert error == %{error: :game_started, message: "Oops! This game has already started."}
    end
  end

  describe "playing?" do
    test "returns true when player found" do
      game_name = NameGenerator.generate()
      {:ok, _pid} = Server.start_link(game_name, "player1")

      assert Server.playing?(game_name, "player1") == {:ok, true}
    end

    test "returns false when player not found" do
      game_name = NameGenerator.generate()
      {:ok, _pid} = Server.start_link(game_name, "player1")
      assert Server.playing?(game_name, "player2") == {:ok, false}
    end
  end

  describe "deal_hand" do
    test "deals a hand to each player and returns the updated game" do
      game_name = NameGenerator.generate()
      {:ok, _pid} = Server.start_link(game_name, "player1")

      Server.deal(game_name)

      game = Server.game(game_name)

      Enum.each(
        Map.values(game.players),
        fn player ->
          hand = Server.get_hand(game_name, player.name)
          assert Enum.count(hand) == 5
        end
      )
    end
  end

  describe "player_state" do
    test "returns the player state for the specified player" do
      game_name = NameGenerator.generate()
      {:ok, _pid} = Server.start_link(game_name, "player1")
      Server.deal(game_name)

      player_state = Server.player_state(game_name, "player1")

      assert player_state.name == "player1"
      assert Enum.count(player_state.hand) == 5
    end
  end

  describe "get_hand" do
    test "returns the hand of the specified player" do
      game_name = NameGenerator.generate()
      {:ok, _pid} = Server.start_link(game_name, "player1")
      Server.deal(game_name)

      hand = Server.get_hand(game_name, "player1")

      assert Enum.count(hand) == 5
    end
  end

  describe "choose_card" do
    test "sets the chosen card in the current turn" do
      game_name = NameGenerator.generate()
      {:ok, _pid} = Server.start_link(game_name, "player1")
      Server.deal(game_name)
      Server.draw_cards(game_name, "player1")
      [card | _] = Server.get_hand(game_name, "player1")

      {:ok, game} = Server.choose_card(game_name, "player1", card.id)

      assert game.current_turn.chosen_card == card
    end
  end

  describe "place_card_bank" do
    test "places the chosen card in the player's bank" do
      game_name = NameGenerator.generate()
      {:ok, _pid} = Server.start_link(game_name, "player1")
      Server.deal(game_name)
      Server.draw_cards(game_name, "player1")
      [card | _] = Server.get_hand(game_name, "player1")

      {:ok, _} = Server.choose_card(game_name, "player1", card.id)
      {:ok, game} = Server.place_card_bank(game_name, "player1")

      assert game.current_turn.chosen_card == nil
      assert Server.player_state(game_name, "player1").bank == [card]
    end
  end
end
