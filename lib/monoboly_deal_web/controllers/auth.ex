defmodule MonobolyDealWeb.Auth do
  import Plug.Conn
  import Phoenix.Controller
  alias MonobolyDealWeb.Router.Helpers, as: Routes

  def login(conn, player) do
    conn
    |> put_current_player(player)
    |> put_session(:current_player, player)
    |> configure_session(renew: true)
  end

  def put_current_player(conn, player) do
    token = Phoenix.Token.sign(conn, "user socket", player)

    conn
    |> assign(:current_player, player)
    |> assign(:user_token, token)
  end

  def authenticate_user(conn) do
    case get_session(conn, :current_player) do
      nil ->
        conn
        |> put_session(:return_to, conn.request_path)
        |> redirect(to: Routes.session_path(conn, :new))
        |> halt()

      player ->
        conn
        |> put_current_player(player)
    end
  end
end
