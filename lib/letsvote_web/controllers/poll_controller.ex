defmodule LetsvoteWeb.PollController do
  use LetsvoteWeb, :controller
  alias Letsvote.Votes

  def index(conn, _params) do
    polls = Votes.list_polls()
    render(conn, "index.html", polls: polls)
  end

  def new(conn, _params) do
    poll = Votes.new_poll()
    render(conn, "new.html", poll: poll)
  end

  def create(conn, %{"poll" => poll_params, "options" => options}) do
    split_options = String.split(options, ",")
    with {:ok, poll} <- Votes.create_polls_and_options(poll_params, split_options) do
      conn
      |> put_flash(:info, "Poll added!")
      |> redirect(to: poll_path(conn, :index))
    end
  end
end
