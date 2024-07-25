defmodule ShoppingWeb.UserJSON do
  alias Shopping.UserManager.User

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      username: user.username,
      balance: user.balance
    }
  end

  def userToken(%{token: token, user: user}) do
    %{token: token, user: data(user)}
  end
end
