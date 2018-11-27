defmodule LetsvoteWeb.UserController do
  use LetsvoteWeb, :controller
  alias Letsvote.Accounts

  def new(conn, _) do
    user = Accounts.new_user()
    render(conn, "new.html", user: user)
  end


  def show(conn, %{"id" => id}) do
    user = Accounts.get_user(id)
    render(conn, "show.html", user: user)
  end
end