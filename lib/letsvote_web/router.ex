defmodule LetsvoteWeb.Router do
  use LetsvoteWeb, :router

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

  scope "/", LetsvoteWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/polls", PollController, :index
    post "/polls", PollController, :create
    get "/polls/new", PollController, :new
  end

  # Other scopes may use custom stacks.
  # scope "/api", LetsvoteWeb do
  #   pipe_through :api
  # end
end
