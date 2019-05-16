defmodule MonobolyDealWeb.PageControllerTest do
  use MonobolyDealWeb.ConnCase, async: true

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Monoboly Deal"
  end
end
