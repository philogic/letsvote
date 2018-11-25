defmodule Letsvote.Votes.Option do
  use Ecto.Schema
  import Ecto.Changeset
  alias Letsvote.Votes.Option
  alias Letsvote.Votes.Poll

  schema "options" do
    field(:answer, :string)
    field(:votes, :integer, default: 0)
    belongs_to(:poll, Poll)
    timestamps()
  end

  def changeset(%Option{} = option, attrs) do
    option
    |> cast(attrs, [:answer, :votes, :poll_id])
    |> validate_required([:answer, :votes, :poll_id])
  end
end