defmodule LetsvoteWeb.PollController do
  use LetsvoteWeb, :controller

  def index(conn, _params) do
    polls = Letsvote.Votes.list_polls()
    conn
    |> put_layout(:custom)
    |> render("index.html", polls: polls)
  end
end
