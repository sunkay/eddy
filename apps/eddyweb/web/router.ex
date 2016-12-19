defmodule Eddyweb.Router do
  use Eddyweb.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Eddyweb.Authentication
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Eddyweb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/register", SessionController, :new
    post "/register", SessionController, :create
    get "/signin", SessionController, :signin_new
    post "/signin", SessionController, :signin_create
    get "/signout", SessionController, :signout

  end

  # Other scopes may use custom stacks.
  # scope "/api", Eddyweb do
  #   pipe_through :api
  # end
end
