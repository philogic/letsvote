defmodule Letsvote.Votes.Poll do
  use Ecto.Schema
  import Ecto.Changeset
  alias Letsvote.Votes.Poll

  schema "polls" do
    field(:question, :string)
    timestamps()
  end

  def changeset(%Poll{} = poll, attrs) do
    poll
    |> cast(attrs, [:question])
    |> validate_required([:question])
  end
end