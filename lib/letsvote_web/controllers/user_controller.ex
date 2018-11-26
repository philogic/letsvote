defmodule LetsvoteWeb.UserController do
  use LetsvoteWeb, :controller

  def show(conn, %{"id" => id}) do
    user = Letsvote.Accounts.get_user(id)
    conn
    |> put_layout(:custom)
    |> render("show.html", user: user)
  end
end