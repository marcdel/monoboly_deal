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
  end

  describe "deal-hand" do
    test "deals a hand and rdisplays the player's cards", %{
      game_name: game_name,
      player: player
    } do
      session = %{game_name: game_name, current_player: player}
      {:ok, view, _html} = mount(Endpoint, InProgressGameView, session: session)

      html_after_click = render_click(view, "deal-hand")

      player_state = Server.player_state(game_name, player)

      Enum.each(player_state.hand, fn card ->
        assert html_after_click =~ Atom.to_string(card.name)
        assert html_after_click =~ card.image_url
      end)
    end
  end
end
