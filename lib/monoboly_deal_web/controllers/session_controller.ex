defmodule MonobolyDealWeb.SessionController do
  use MonobolyDealWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"player" => %{"name" => name}}) do
    player = %MonobolyDeal.Player{name: name}

    conn
    |> put_session(:current_player, player)
    |> redirect_back_or_to_new_game()
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:current_player)
    |> redirect(to: Routes.session_path(conn, :new))
  end

  defp redirect_back_or_to_new_game(conn) do
    path = get_session(conn, :return_to) || Routes.game_path(conn, :new)

    conn
    |> put_session(:return_to, nil)
    |> redirect(to: path)
  end
end
