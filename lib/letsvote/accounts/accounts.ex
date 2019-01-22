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

  def get_user_by_username(username) do
    Repo.get_by(User, username: username)
  end

  def get_user_by_oauth(oauth_provider, oauth_id) do
    Repo.get_by(User, oauth_provider: oauth_provider, oauth_id: oauth_id)
  end
end