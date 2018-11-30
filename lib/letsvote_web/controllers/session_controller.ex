defmodule LetsvoteWeb.SessionController do
  use LetsvoteWeb, :controller
  alias Letsvote.Accounts

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"username" => username, "password" => password}) do
    with user <- Accounts.get_user_by_username(username),
         {:ok, logged_in_user} <- login(user, password)
    do
      conn
      |> put_flash(:info, "You have logged in!")
      |> put_session(:user, %{id: logged_in_user.id, username: logged_in_user.username,
      password: logged_in_user.password})
      |> redirect(to: "/")
    else
      {:error, _} ->
        conn
        |> put_flash(:error, "Invalid username/password")
        |> render("new.html")
    end
  end

  defp login(user, password) do
    Comeonin.Bcrypt.check_pass(user, password)
  end

  def delete(conn, _) do
    conn
    |> delete_session(:user)
    |> put_flash(:info, "You are logged out now")
    |> redirect(to: "/")
  end
end