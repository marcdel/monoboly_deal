defmodule MonobolyDealWeb.InProgressGameView do
  use Phoenix.LiveView
  alias MonobolyDealWeb.GameView
  alias MonobolyDeal.Game.Server
  alias MonobolyDealWeb.Router.Helpers, as: Routes

  def render(assigns) do
    GameView.render("game.html", assigns)
  end

  def mount(%{game_name: game_name, current_player: current_player}, socket) do
    if connected?(socket), do: :timer.send_interval(100, self(), :tick)

    case Server.join(game_name, current_player) do
      {:ok, _} ->
        socket =
          socket
          |> assign(error_message: "")
          |> assign(info_message: "You've joined the game!")
          |> assign(game_name: game_name)
          |> assign(current_player: current_player)
          |> assign(game_state: Server.game_state(game_name))
          |> assign(player_state: Server.player_state(game_name, current_player))

        {:ok, socket}

      {:error, _error_message} ->
        {:stop, redirect(socket, to: Routes.game_path(socket, :new))}
    end
  end

  def handle_event("deal-hand", _value, socket) do
    %{game_name: game_name, current_player: current_player} = socket.assigns

    Server.deal_hand(game_name)
    player_state = Server.player_state(game_name, current_player)
    game_state = Server.game_state(game_name)

    socket = assign(socket, player_state: player_state, game_state: game_state)

    {:noreply, socket}
  end

  def handle_event("draw-cards", _value, socket) do
    %{game_name: game_name, current_player: current_player} = socket.assigns

    Server.draw_cards(game_name, current_player)

    player_state = Server.player_state(game_name, current_player)
    game_state = Server.game_state(game_name)

    socket = assign(socket, player_state: player_state, game_state: game_state)

    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    game_state = Server.game_state(socket.assigns.game_name)
    player_state = Server.player_state(socket.assigns.game_name, socket.assigns.current_player)

    socket =
      socket
      |> assign(player_state: player_state, game_state: game_state)
      |> set_player_turn_message(player_state, game_state)

    {:noreply, socket}
  end

  defp set_player_turn_message(socket, _, %{current_turn: nil}), do: socket

  defp set_player_turn_message(socket, %{my_turn: true}, _) do
    socket
    |> assign(error_message: "")
    |> assign(info_message: "Your turn!")
  end

  defp set_player_turn_message(socket, %{my_turn: false}, %{currrent_turn: %{player: whose_turn}}) do
    socket
    |> assign(error_message: "")
    |> assign(info_message: "#{whose_turn.name}'s turn!")
  end
end
