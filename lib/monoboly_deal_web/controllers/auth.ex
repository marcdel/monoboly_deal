defmodule MonobolyDealWeb.Auth do
  import Plug.Conn

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
end
