defmodule LetsvoteWeb.PollController do
  use LetsvoteWeb, :controller
  alias Letsvote.Votes
  plug LetsvoteWeb.VerifyUserSession when action in [:new, :create]

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
    with user <- get_session(conn, :user),
      poll_params <- Map.put(poll_params, "user_id", user.id),
      {:ok, _poll} <- Votes.create_polls_and_options(poll_params, split_options)
    do
      conn
      |> put_flash(:info, "Poll added!")
      |> redirect(to: poll_path(conn, :index))
    end
  end

  def show(conn, %{"id" => id}) do
    with poll <- Votes.get_poll(id) do
      render(conn, "show.html", %{poll: poll})
    end
  end

  def vote(conn, %{"id" => id}) do
    with {:ok, option} <- Votes.choose_option(id) do
      conn
      |> put_flash(:info, "You have voted on #{option.answer}")
      |> redirect(to: poll_path(conn, :index))
    end
  end

end
