defmodule Letsvote.Accounts do
  import Ecto.Query
  alias Letsvote.Repo
  alias Letsvote.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def new_user do
    User.changeset(%User{}, %{})
  end

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_user(id) do
    Repo.get(User, id)
  end
end