defmodule Letsvote.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :url, :string
      add :alt, :string
      add :caption, :string
      add :poll_id, references(:polls, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:images, [:poll_id])
    create index(:images, [:user_id])
  end
end
