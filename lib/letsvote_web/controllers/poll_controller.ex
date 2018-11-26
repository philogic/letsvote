defmodule LetsvoteWeb.PollController do
  use LetsvoteWeb, :controller

  def index(conn, _params) do
    polls = Letsvote.Votes.list_polls()
    conn
    |> put_layout(:custom)
    |> render("index.html", polls: polls)
  end

  def new(conn, _params) do
    poll = Letsvote.Votes.new_poll()
    conn
    |> put_layout(:custom)
    |> render("new.html", poll: poll)
  end

  def create(conn, %{"poll" => poll_params, "options" => options}) do
    split_options = String.split(options, ",")
    with {:ok, poll} <- Letsvote.Votes.create_polls_and_options(poll_params, split_options) do
      conn
      |> put_flash(:info, "Poll added!")
      |> redirect(to: poll_path(conn, :index))
    end
  end
end
