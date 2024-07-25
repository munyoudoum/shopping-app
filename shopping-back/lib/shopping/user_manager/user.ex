defmodule Shopping.UserManager.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :balance, :decimal, default: 0
    field :username, :string
    field :password, :string

    timestamps(type: :utc_datetime)
  end

  alias Argon2

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :balance])
    |> validate_required([:username, :password])
    |> validate_length(:username, min: 4, max: 20)
    |> validate_length(:password, min: 8)
    |> unique_constraint(:username)
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
