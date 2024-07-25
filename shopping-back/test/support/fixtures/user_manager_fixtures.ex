defmodule Shopping.UserManagerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Shopping.UserManager` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        balance: "120.5",
        password: "password",
        username: "username"
      })
      |> Shopping.UserManager.create_user()

    user
  end
end
