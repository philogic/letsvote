defmodule Letsvote.Votes do
  alias Letsvote.Repo
  alias Letsvote.Votes.Poll
  alias Letsvote.Votes.Option

  def list_polls do
    Repo.all(Poll) |> Repo.preload(:options)
  end

  def new_poll do
    Poll.changeset(%Poll{}, %{})
  end

  def create_polls_and_options(poll_attrs, options) do
    Repo.transaction(fn  ->
      with {:ok, poll} <- create_poll(poll_attrs),
           {:ok, _options} <- create_options(options, poll)
      do
        poll
      else
        _ -> Repo.rollback("Failed")
      end
    end)
  end

  def create_options(options, poll) do
    results = Enum.map(options, fn option ->
      create_option(%{answer: option, poll_id: poll.id})
    end)
    if Enum.any?(results, fn {status, _} -> status == :error  end) do
      {:error, "Failed"}
    else
      {:ok, results}
    end
  end

  def create_poll(attrs)do
    %Poll{}
    |> Poll.changeset(attrs)
    |> Repo.insert()
  end

  def create_option(attrs)do
    %Option{}
    |> Option.changeset(attrs)
    |> Repo.insert()
  end

  def choose_option(option_id) do
    with option <- Repo.get!(Option, option_id),
         votes <- option.votes + 1
      do
        update_option(option, %{votes: votes})
    end
  end

  def update_option(option, attrs) do
    option
    |> Option.changeset(attrs)
    |> Repo.update()
  end
end