defmodule LetsvoteWeb.PollController do
  use LetsvoteWeb, :controller

  def index(conn, _params) do
    conn
    |> put_layout(:custom)
    |> render("index.html")
  end
end
