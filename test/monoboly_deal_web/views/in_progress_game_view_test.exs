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
  end
end
