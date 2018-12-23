defmodule Letsvote.Votes.VoteRecord do
  use Ecto.Schema
  import Ecto.Changeset
  alias Letsvote.Votes.VoteRecord
  alias Letsvote.Votes.Poll


  schema "vote_records" do
    field :ip_address, :string
    belongs_to(:poll, Poll)

    timestamps()
  end

  def changeset(vote_record, attrs) do
    vote_record
    |> cast(attrs, [:ip_address, :poll_id])
    |> validate_required([:ip_address, :poll_id])
  end
end
