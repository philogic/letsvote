defmodule Letsvote.Votes do
  import Ecto.Query
  alias Letsvote.Repo
  alias Letsvote.Votes.Poll
  alias Letsvote.Votes.Option
  alias Letsvote.Votes.Image
  alias Letsvote.Votes.VoteRecord

  def list_polls do
    Repo.all(Poll) |> Repo.preload([:options, :image, :vote_records])
  end

  def new_poll do
    Poll.changeset(%Poll{}, %{})
  end

  def create_polls_and_options(poll_attrs, options, image_data) do
    Repo.transaction(fn  ->
      with {:ok, poll} <- create_poll(poll_attrs),
           {:ok, _options} <- create_options(options, poll),
           {:ok, filename} <- upload_image(poll_attrs, poll),
           {:ok, _image} <- save_image(poll, image_data, filename)
      do
        poll
      else
        _ -> Repo.rollback("Failed")
      end
    end)
  end

  def get_poll(id) do
    Repo.get!(Poll, id) |> Repo.preload([:options, :image, :vote_records])
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

  def choose_option(option_id, voter_ip) do
    with option <- Repo.get!(Option, option_id),
         false <- voted?(option.poll_id, voter_ip),
         votes <- option.votes + 1,
    {:ok, option} <- update_option(option, %{votes: votes}),
    {:ok, _vote_record} <- record_vote(%{poll_id: option.poll_id, ip_address: voter_ip})
    do
      {:ok, option}
    else
      _ -> {:error, "You can not vote. Sorry"}
    end
  end

  def update_option(option, attrs) do
    option
    |> Option.changeset(attrs)
    |> Repo.update()
  end

  defp upload_image(%{"image" => image}, poll ) do
    file_extension = Path.extname(image.filename)
    filename = "#{poll.id}_image#{file_extension}"
    File.cp(image.path, "/uploads/#{filename}")
    {:ok, filename}
  end
  defp upload_image(_, _) do
    {:ok, nil}
  end

  defp save_image(poll, %{"caption" => caption, "alt" => alt}, filename) do
    attrs = %{
      url: "/uploads/#{filename}",
      alt: alt,
      caption: caption,
      poll_id: poll.id,
      user_id: poll.user.id
    }
    %Image{}
    |> Image.changeset(attrs)
    |> Repo.insert()
  end
  defp save_image(_poll, _image_data, nil) do
    {:ok, nil}
  end

  def record_vote(attrs) do
    %VoteRecord{}
    |> VoteRecord.changeset(attrs)
    |> Repo.insert()
  end

  def voted?(poll_id, ip_address) do
    votes = (from v in VoteRecord, where: v.poll_id == ^poll_id and v.ip_address == ^ip_address)
    |> Repo.aggregate(:count, :id)
    votes > 0
  end
end