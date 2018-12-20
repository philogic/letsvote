defmodule Letsvote.Votes.Image do
  use Ecto.Schema
  import Ecto.Changeset


  schema "images" do
    field :alt, :string
    field :caption, :string
    field :url, :string
    field :poll_id, :id
    field :user_id, :id

    timestamps()
  end

  def changeset(image, attrs) do
    image
    |> cast(attrs, [:url, :alt, :caption, :poll_id, :user_id])
    |> validate_required([:url, :alt, :poll_id, :user_id])
  end
end
