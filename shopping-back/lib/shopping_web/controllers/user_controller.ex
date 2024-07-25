defmodule ShoppingWeb.UserController do
  use ShoppingWeb, :controller

  alias Shopping.{UserManager, UserManager.Guardian}

  action_fallback ShoppingWeb.FallbackController

  def register(conn, %{"user" => user_params}) do
    with {:ok, _} <- UserManager.create_user(user_params) do
      conn
      |> put_status(:created)
      |> json(%{message: "User created successfully"})
    end
  end
  def login(conn,  %{"user" => %{"username" => username, "password" => password}}) do
    case UserManager.authenticate_user(username, password) do
      {:ok, user} ->
        {:ok, token, _} = Guardian.encode_and_sign(user)
        conn
        |> render(:userToken, token: token, user: user)
      {:error, _} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{errors: "Invalid username or password"})
    end
  end

  def me(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    conn
    |> put_status(:ok)
    |> render(:show, user: user)
  end
end
