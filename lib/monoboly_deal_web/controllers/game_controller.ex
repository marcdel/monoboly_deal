defmodule MonobolyDealWeb.GameController do
  use MonobolyDealWeb, :controller

  alias Phoenix.LiveView
  alias MonobolyDeal.Game.{NameGenerator, Server, Supervisor}
  alias MonobolyDealWeb.Auth

  plug :require_player

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, _opts) do
    game_name = NameGenerator.generate()
    player = get_session(conn, :current_player)

    case Supervisor.start_game(game_name, player) do
      {:ok, _game_pid} ->
        redirect(conn, to: Routes.game_path(conn, :show, game_name))

      {:error, _error} ->
        conn
        |> put_flash(:error, "Oops! We were unable to start your game. Please try again.")
        |> redirect(to: Routes.game_path(conn, :new))
    end
  end

  def show(conn, %{"id" => game_name}) do
    case Server.game_pid(game_name) do
      pid when is_pid(pid) ->
        LiveView.Controller.live_render(
          conn,
          MonobolyDealWeb.InProgressGameView,
          session: %{
            game_name: game_name,
            current_player: get_session(conn, :current_player),
            pid: pid
          }
        )

      nil ->
        conn
        |> put_flash(:error, "Oops! We couldn't find that game.")
        |> redirect(to: Routes.game_path(conn, :new))
        |> halt()
    end
  end

  defp require_player(conn, _opts), do: Auth.authenticate_user(conn)
end
