defmodule Letsvote.Repo.Migrations.AddPollsTable do
  use Ecto.Migration

  def change do
    create table("polls") do
      add(:question, :string)
      timestamps()
    end
  end
end
