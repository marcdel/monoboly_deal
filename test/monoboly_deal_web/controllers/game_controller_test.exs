defmodule MonobolyDealWeb.GameControllerTest do
  use MonobolyDealWeb.ConnCase, async: true

  describe "new game" do
    test "redirects to new session if not authenticated", %{conn: conn} do
      conn = get(conn, Routes.game_path(conn, :new))
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "renders a change player link", %{conn: conn} do
      conn = create_session(conn, "player1")
      conn = get(conn, Routes.game_path(conn, :new))
      assert html_response(conn, 200) =~ "Change Player"
    end
  end

  describe "create game" do
    test "redirects to new session page if not authenticated", %{conn: conn} do
      conn = post(conn, Routes.game_path(conn, :create))
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "creates a new game and redirects to show the game", %{conn: conn} do
      conn = create_session(conn, "player1")

      conn = post(conn, Routes.game_path(conn, :create))

      assert %{id: game_name} = redirected_params(conn)
      assert redirected_to(conn) == Routes.game_path(conn, :show, game_name)

      conn = get(conn, Routes.game_path(conn, :show, game_name))
      assert html_response(conn, 200) =~ game_name
    end
  end

  describe "show game" do
    test "redirects to new session page if not authenticated", %{conn: conn} do
      conn = get(conn, Routes.game_path(conn, :show, "new_game_path"))
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    @tag :skip
    test "redirects to new game page if game does not exist", %{conn: conn} do
      conn = create_session(conn, "player1")
      conn = get(conn, Routes.game_path(conn, :show, "non-existent-game"))
      assert redirected_to(conn) == Routes.game_path(conn, :new)
    end

    test "shows game if it exists", %{conn: conn} do
      conn = create_session(conn, "player1")
      conn = post(conn, Routes.game_path(conn, :create))
      %{id: game_name} = redirected_params(conn)

      conn = get(conn, Routes.game_path(conn, :show, game_name))

      assert html_response(conn, 200) =~ game_name
    end
  end
end
