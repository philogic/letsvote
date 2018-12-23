defmodule Letsvote.Votes.Image do
  use Ecto.Schema
  import Ecto.Changeset
  alias Letsvote.Votes.Poll
  alias Letsvote.Accounts.User


  schema "images" do
    field :alt, :string
    field :caption, :string
    field :url, :string
    belongs_to(:poll, Poll)
    belongs_to(:user, User)

    timestamps()
  end

  def changeset(image, attrs) do
    image
    |> cast(attrs, [:url, :alt, :caption, :poll_id, :user_id])
    |> validate_required([:url, :alt, :poll_id, :user_id])
  end
end
