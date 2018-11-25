defmodule Letsvote.Votes do
  import Ecto.Query
  alias Letsvote.Repo
  alias Letsvote.Votes.Poll
  alias Letsvote.Votes.Option

  def list_polls do
    Repo.all(Poll) |> Repo.preload(:options)
  end
end