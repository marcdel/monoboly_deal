defmodule MonobolyDealWeb.PageController do
  use MonobolyDealWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
