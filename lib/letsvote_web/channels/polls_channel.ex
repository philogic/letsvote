defmodule LetsvoteWeb.PollsChannel do
  use LetsvoteWeb, :channel

  def join("polls:" <> _poll_id, %{"remote_ip" => remote_ip}, socket) do
    {:ok, assign(socket, :remote_ip, remote_ip)}
  end


  def handle_in("vote", %{"option_id" => option_id}, %{assigns: %{remote_ip: remote_ip}} = socket) do
    with {:ok, option} <- Letsvote.Votes.choose_option(option_id, remote_ip) do
      broadcast socket, "new_vote", %{"option_id" => option.id, "votes" => option.votes}
      {:reply, {:ok, %{"option_id" => option_id, "votes" => option.votes}}, socket}
    else
      {:error, _} ->
        {:reply, {:error,%{message: "Failed to vote"}}}
    end
  end
end