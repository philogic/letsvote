defmodule Letsvote.Repo.Migrations.CreateVoteRecords do
  use Ecto.Migration

  def change do
    create table(:vote_records) do
      add :ip_address, :string
      add :poll_id, references(:polls, on_delete: :nothing)

      timestamps()
    end

    create index(:vote_records, [:poll_id])
  end
end
