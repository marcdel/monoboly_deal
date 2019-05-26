defmodule MonobolyDealWeb.InProgressGameView do
  use Phoenix.LiveView
  alias MonobolyDealWeb.GameView
  alias MonobolyDeal.Game.Server

  def render(assigns) do
    GameView.render("game.html", assigns)
  end

  def mount(%{game_name: game_name, current_player: current_player}, socket) do
    socket =
      socket
      |> assign(game_name: game_name)
      |> assign(current_player: current_player)
      |> assign(game_state: Server.game_state(game_name))
      |> assign(player_state: Server.player_state(game_name, current_player))

    {:ok, socket}
  end

  def handle_event("deal-hand", _value, socket) do
    Server.deal_hand(socket.assigns.game_name)
    player_state = Server.player_state(socket.assigns.game_name, socket.assigns.current_player)
    game_state = Server.game_state(socket.assigns.game_name)
    {:noreply, assign(socket, player_state: player_state, game_state: game_state)}
  end
end
