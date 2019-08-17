defmodule MonobolyDealWeb.InProgressGameViewTest do
  use MonobolyDealWeb.ConnCase, async: true
  import Phoenix.LiveViewTest, only: [mount: 3, render_click: 2]

  alias MonobolyDeal.Game.{NameGenerator, Server, Supervisor}
  alias MonobolyDealWeb.{Endpoint, InProgressGameView}

  setup do
    game_name = NameGenerator.generate()
    player = %{name: "player1"}

    Supervisor.start_game(game_name, player)

    %{game_name: game_name, player: player}
  end

  describe "mount/2" do
    test "displays the game name, a Deal button, and the player's name", %{
      game_name: game_name,
      player: player
    } do
      session = %{game_name: game_name, current_player: player}
      {:ok, _view, html} = mount(Endpoint, InProgressGameView, session: session)
      assert html =~ game_name
      assert html =~ player.name
      assert html =~ "Deal"
    end

    test "joins the game if not already playing", %{game_name: game_name, player: player1} do
      player2 = %{name: "player2"}
      player2_session = %{game_name: game_name, current_player: player2}
      {:ok, _view, html} = mount(Endpoint, InProgressGameView, session: player2_session)
      assert html =~ game_name
      assert html =~ player1.name
      assert html =~ player2.name
    end

    test "redirects if not joined and game has already started", %{game_name: game_name} do
      Server.deal_hand(game_name)
      player2_session = %{game_name: game_name, current_player: %{name: "player2"}}
      {:error, %{redirect: "/games/new"}} = mount(Endpoint, InProgressGameView, session: player2_session)
    end
  end

  describe "deal-hand" do
    test "deals a hand to each player and updates player and game state", %{game_name: game_name, player: player1} do
      player2 = %{name: "player2"}
      player2_session = %{game_name: game_name, current_player: player2}
      {:ok, view, _html} = mount(Endpoint, InProgressGameView, session: player2_session)

      assert render_click(view, "deal-hand") =~ "<section class=\"hand\">"

      player1_session = %{game_name: game_name, current_player: player1}
      {:ok, _view, html} = mount(Endpoint, InProgressGameView, session: player1_session)
      assert html =~ "<section class=\"hand\">"
    end
  end
end
