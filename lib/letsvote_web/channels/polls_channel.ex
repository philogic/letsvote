defmodule LetsvoteWeb.PollsChannel do
  use LetsvoteWeb, :channel

  def join("polls:main", _payload, socket) do
    {:ok, socket}
  end

  def handle_in("hello", _payload, socket) do
    broadcast socket, "world", %{message: "world"}
    {:reply, {:ok, %{message: "world"}}, socket}
  end
end