defmodule MonobolyDealWeb.PageControllerTest do
  use MonobolyDealWeb.ConnCase, async: true

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert redirected_to(conn) == Routes.session_path(conn, :new)
  end
end
