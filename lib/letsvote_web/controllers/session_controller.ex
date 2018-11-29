defmodule LetsvoteWeb.SessionController do
  use LetsvoteWeb, :controller

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, _) do
    conn
  end

  def delete(conn, _) do
    conn
    |> delete_session(:user)
    |> put_flash(:info, "You are logged out now")
    |> redirect(to: "/")
  end
end