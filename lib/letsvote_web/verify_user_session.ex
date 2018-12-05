defmodule LetsvoteWeb.VerifyUserSession do
  import Plug.Conn, only: [get_session: 2, halt: 1]
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    case get_session(conn, :user) do
      nil ->
        conn
        |> put_flash(:error, "You have to login first!")
        |> redirect(to: "/")
        |> halt()
      _ -> conn
    end
  end
end