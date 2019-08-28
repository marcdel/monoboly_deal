defmodule MonobolyDealWeb.InProgressGameViewTest do
  use MonobolyDealWeb.ConnCase, async: true
  import Phoenix.LiveViewTest, only: [mount: 3, render_click: 2, render_click: 3]

  alias MonobolyDeal.Game.{NameGenerator, Player, Server, Supervisor}
  alias MonobolyDealWeb.{Endpoint, InProgressGameView}

  setup do
    game_name = NameGenerator.generate()
    Supervisor.start_game(game_name, "player1")
    %{game_name: game_name}
  end

  describe "mount/2" do
    test "displays the game name, a Deal button, and the player's name", %{game_name: game_name} do
      session = %{game_name: game_name, current_player: %{name: "player1"}}
      {:ok, _view, html} = mount(Endpoint, InProgressGameView, session: session)
      assert html =~ game_name
      assert html =~ "player1"
      assert html =~ "Deal"
    end

    test "joins the game if not already playing", %{game_name: game_name} do
      player2 = Player.new("player2")
      player2_session = %{game_name: game_name, current_player: player2}
      {:ok, _view, html} = mount(Endpoint, InProgressGameView, session: player2_session)
      assert html =~ game_name
      assert html =~ "player1"
      assert html =~ player2.name
    end

    test "redirects if not joined and game has already started", %{game_name: game_name} do
      Server.deal_hand(game_name)
      player2_session = %{game_name: game_name, current_player: %{name: "player2"}}

      {:error, %{redirect: "/games/new"}} =
        mount(Endpoint, InProgressGameView, session: player2_session)
    end
  end

  describe "deal-hand" do
    test "deals a hand to each player and updates player and game state", %{game_name: game_name} do
      player2 = Player.new("player2")
      player2_session = %{game_name: game_name, current_player: player2}
      {:ok, view, _html} = mount(Endpoint, InProgressGameView, session: player2_session)

      html = render_click(view, "deal-hand")
      assert html =~ "<section class=\"hand\">"
      assert html =~ "hand-card1"
      assert html =~ "hand-card2"
      assert html =~ "hand-card3"
      assert html =~ "hand-card4"
      assert html =~ "hand-card5"
      assert html =~ "Your turn!" || "player1's turn!"

      player1_session = %{game_name: game_name, current_player: %{name: "player1"}}
      {:ok, _view, html} = mount(Endpoint, InProgressGameView, session: player1_session)
      assert html =~ "<section class=\"hand\">"
    end
  end

  describe "draw-cards" do
    test "puts a card from the deck into your hand", %{game_name: game_name} do
      session = %{game_name: game_name, current_player: %{name: "player1"}}
      {:ok, view, _html} = mount(Endpoint, InProgressGameView, session: session)
      render_click(view, "deal-hand")

      html = render_click(view, "draw-cards")

      assert html =~ "hand-card6"
      assert html =~ "hand-card7"
    end
  end

  describe "playing cards" do
    test "shows an error when player hasn't drawn cards yet", %{game_name: game_name} do
      session = %{game_name: game_name, current_player: %{name: "player1"}}
      {:ok, view, _html} = mount(Endpoint, InProgressGameView, session: session)
      render_click(view, "deal-hand")

      [card | _] = Server.get_hand(game_name, "player1")
      html = render_click(view, "choose-card", card.id)

      assert html =~ "You need to draw 2 cards from the deck"
    end

    test "can place cards in the bank, or properties section", %{game_name: game_name} do
      session = %{game_name: game_name, current_player: %{name: "player1"}}
      {:ok, view, _html} = mount(Endpoint, InProgressGameView, session: session)
      render_click(view, "deal-hand")
      [card | _] = Server.get_hand(game_name, "player1")

      assert render_click(view, "choose-card", card.id) =~
               "You need to draw 2 cards from the deck"

      render_click(view, "draw-cards")

      assert render_click(view, "choose-card", card.id) =~ "chosen-card"
      html = render_click(view, "place-card-bank")
      assert html =~ "bank-card1"
      assert html =~ "Bank (#{card.value}M)"
    end
  end
end
