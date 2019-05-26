defmodule MonobolyDealWeb.SessionControllerTest do
  use MonobolyDealWeb.ConnCase, async: true

  describe "new session" do
    test "renders a form", %{conn: conn} do
      conn = get(conn, Routes.session_path(conn, :new))
      assert html_response(conn, 200)
    end
  end

  describe "create session" do
    test "creates a session for the current player", %{conn: conn} do
      attrs = %{"name" => "player1"}
      conn = post(conn, Routes.session_path(conn, :create), player: attrs)

      assert %{name: "player1"} = get_session(conn, :current_player)
      assert redirected_to(conn) == Routes.game_path(conn, :new)
    end

    test "redirects to the previous page if return_to is set", %{conn: conn} do
      conn =
        conn
        |> put_test_session(:return_to, Routes.game_path(conn, :new))
        |> post(Routes.session_path(conn, :create), player: %{"name" => "player"})

      assert redirected_to(conn) == Routes.game_path(conn, :new)
    end
  end

  describe "delete session" do
    test "deletes the current player from the session", %{conn: conn} do
      conn = create_session(conn, "player1")

      conn = delete(conn, Routes.session_path(conn, :delete))

      assert redirected_to(conn) == Routes.session_path(conn, :new)
      assert get_session(conn, :current_player) == nil
    end
  end

  def put_test_session(conn, key, value) do
    conn
    |> bypass_through(MonobolyDealWeb.Router, :browser)
    |> get("/")
    |> put_session(key, value)
    |> send_resp(:ok, "")
    |> recycle()
  end
end
