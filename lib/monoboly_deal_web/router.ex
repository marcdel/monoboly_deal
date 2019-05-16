defmodule MonobolyDealWeb.Router do
  use MonobolyDealWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MonobolyDealWeb do
    pipe_through :browser

    get "/", PageController, :index
    # don't take an id parameter for delete
    delete "/sessions", SessionController, :delete
    resources "/sessions", SessionController, only: [:new, :create]
    resources "/games", GameController, only: [:new, :create, :show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", MonobolyDealWeb do
  #   pipe_through :api
  # end
end
