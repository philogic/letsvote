defmodule LetsvoteWeb.SessionController do
  use LetsvoteWeb, :controller
  alias Letsvote.Accounts
  plug Ueberauth

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

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Cannot authenticate. Sorry")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case find_or_create_user(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Logged in successfully!")
        |> redirect(to: "/")
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end

  defp find_or_create_user(auth) do
    user = build_user_from_auth(auth)
    case Accounts.get_user_by_oauth(user.oauth_provider, user.oauth_id) do
      nil ->
        case Accounts.get_user_by_username(user.username) do
          nil -> Accounts.create_user(user)
          _ -> Accounts.create_user(%{user | username: "#{user.username}#{user.oauth_id}"})
        end
      user -> {:ok, user}
    end
  end

  defp build_user_from_auth(%{provider: :google} = auth) do
    password = random_string(64)
    %{
      username: auth.info.email,
      email: auth.info.email,
      oauth_id: auth.uid,
      oauth_provider: "google",
      password: password,
      password_confirmation: password
    }
  end

  def random_string(length) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64
    |> binary_part(0, length)
  end
end