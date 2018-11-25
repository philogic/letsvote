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
end
