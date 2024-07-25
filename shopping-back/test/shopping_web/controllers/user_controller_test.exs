defmodule ShoppingWeb.UserControllerTest do
  use ShoppingWeb.ConnCase, async: true

  @create_attrs %{
    username: "username",
    password: "password"
  }

  describe "register" do
    test "registers a new user", %{conn: conn} do
      conn = post(conn, "/api/users", user: @create_attrs)
      assert json_response(conn, 201)["message"] == "User created successfully"
    end

    test "returns error when data is invalid", %{conn: conn} do
      conn = post(conn, "/api/users", user: %{username: nil, password: nil})

      assert json_response(conn, 422)["errors"] == %{
               "username" => ["can't be blank"],
               "password" => ["can't be blank"]
             }
    end

    test "returns error when username is already taken", %{conn: conn} do
      post(conn, "/api/users", user: @create_attrs)
      conn = post(conn, "/api/users", user: @create_attrs)

      assert json_response(conn, 422)["errors"] == %{
               "username" => ["has already been taken"]
             }
    end
    test "returns error when username or password is too short", %{conn: conn} do
      conn = post(conn, "/api/users", user: %{username: "a", password: "a"})

      assert json_response(conn, 422)["errors"] == %{
               "username" => ["should be at least 4 character(s)"],
               "password" => ["should be at least 8 character(s)"]
             }
    end
  end

  describe "login" do
    test "logs in a user", %{conn: conn} do
      post(conn, "/api/users", user: @create_attrs)
      conn = post(conn, "/api/users/login", user: @create_attrs)

      assert json_response(conn, 200)["token"] != nil
    end
    test "returns error when username or password is invalid", %{conn: conn} do
      post(conn, "/api/users", user: @create_attrs)
      conn = post(conn, "/api/users/login", user: %{username: "invalid", password: "invalid"})

      assert json_response(conn, 401)["errors"] == "Invalid username or password"
    end
  end

  describe "me" do
    test "returns error when token is invalid", %{conn: conn} do
      conn = get(conn, "/api/users/me")

      assert json_response(conn, 401)["errors"] == "unauthenticated"
    end

    test "returns the current user", %{conn: conn} do
      user = Shopping.UserManagerFixtures.user_fixture()
      conn = conn |> log_in_user(user) |> get("/api/users/me")

      assert json_response(conn, 200)["data"] == %{
               "id" => user.id,
               "username" => user.username,
               "balance" => Decimal.to_string(user.balance)
             }
    end
  end
end
