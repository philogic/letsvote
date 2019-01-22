defmodule Letsvote.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Letsvote.Accounts.User
  alias Letsvote.Votes.Poll
  alias Letsvote.Votes.Image

  schema "users" do
    field(:username, :string)
    field(:email, :string)
    field(:active, :boolean, default: true)
    field(:encrypted_password, :string)
    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)
    field(:oauth_provider, :string)
    field(:oauth_id, :string)
    has_many(:polls, Poll)
    has_many(:images, Image)
    timestamps()
  end

  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :email, :active, :password, :password_confirmation, :oauth_provider, :oauth_id])
    |> validate_confirmation(:password, message: "Passwords do not match")
    |> validate_format(:email, ~r/@/)
    |> encrypt_password()
    |> validate_required([:username, :active, :encrypted_password])
    |> unique_constraint(:username)
  end

  def encrypt_password(changeset) do
    with password when not is_nil(password) <- get_change(changeset, :password) do
      put_change(changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
    else
      _ -> changeset
    end
  end
end