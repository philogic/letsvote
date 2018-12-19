defmodule LetsvoteWeb.PollsChannel do
  use LetsvoteWeb, :channel

  def join("polls:main", _payload, socket) do
    {:ok, socket}
  end


  def handle_in("vote", %{"option_id" => option_id}, socket) do
    with {:ok, option} <- Letsvote.Votes.choose_option(option_id) do
      broadcast socket, "new_vote", %{"option_id" => option.id, "votes" => option.votes}
      {:reply, {:ok, %{"option_id" => option_id, "votes" => option.votes}}, socket}
    else
      {:error, _} ->
        {:reply, {:error,%{message: "Failed to vote"}}}
    end
  end
end