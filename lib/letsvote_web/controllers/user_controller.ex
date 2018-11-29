defmodule LetsvoteWeb.UserController do
  use LetsvoteWeb, :controller
  alias Letsvote.Accounts

  def new(conn, _) do
    user = Accounts.new_user()
    render(conn, "new.html", user: user)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.create_user(user_params) do
      conn
      |> put_flash(:info, "User created!")
      |> redirect(to: user_path(conn, :show, user))
    else
      {:error, user} ->
        conn
        |> put_flash(:error, "Something has gone wrong. Sorry.")
        |> render("new.html", user: user)
    end
  end


  def show(conn, %{"id" => id}) do
    user = Accounts.get_user(id)
    render(conn, "show.html", user: user)
  end
end