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
    pipe_through :browser

    get "/", PageController, :index

    resources "/polls", PollController, only: [:index, :new, :create, :show]
    get "/options/:id/vote", PollController, :vote

    resources "/users", UserController, only: [:show, :new, :create]

    resources "/sessions", SessionController, only: [:create]

    get "/login", SessionController, :new
    get "/logout", SessionController, :delete


  end

  scope "/auth", LetsvoteWeb do
    get "/:provider/callback", SessionController, :callback
  end
end
