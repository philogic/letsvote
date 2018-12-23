defmodule Letsvote.Votes.Poll do
  use Ecto.Schema
  import Ecto.Changeset
  alias Letsvote.Votes.Poll
  alias Letsvote.Votes.Option
  alias Letsvote.Accounts.User
  alias Letsvote.Votes.Image
  alias Letsvote.Votes.VoteRecord

  schema "polls" do
    field(:question, :string)
    has_many(:options, Option)
    has_one(:image, Image)
    has_many(:vote_records, VoteRecord)
    belongs_to(:user, User)
    timestamps()
  end

  def changeset(%Poll{} = poll, attrs) do
    poll
    |> cast(attrs, [:question, :user_id])
    |> validate_required([:question, :user_id])
  end
end