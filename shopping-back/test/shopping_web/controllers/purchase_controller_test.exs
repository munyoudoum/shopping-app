defmodule ShoppingWeb.PurchaseControllerTest do
  use ShoppingWeb.ConnCase, async: true

  alias Shopping.ProductFixtures
  alias Shopping.UserManagerFixtures

  setup do
    user = UserManagerFixtures.user_fixture(%{balance: "100.00"})
    inventory = ProductFixtures.inventory_fixture()
    conn = build_conn() |> log_in_user(user)
    {:ok, conn: conn, user: user, inventory: inventory}
  end

  describe "POST /api/purchase" do
    test "creates a purchase and returns the purchase record", %{
      conn: conn,
      user: user,
      inventory: inventory
    } do
      # Assuming you have a product with id 1 and sufficient quantity
      conn =
        post(conn, "/api/purchase", %{
          "purchase_products" => [
            %{"id" => inventory.id, "quantity" => 2}
          ]
        })

      assert json_response(conn, 201)["data"]["total_price"] ==
               Decimal.to_string(Decimal.mult(inventory.price, 2))
      assert json_response(conn, 201)["data"]["user_id"] == user.id
    end

    test "returns error when product id is invalid", %{conn: conn} do
      conn = post(conn, "/api/purchase", %{"purchase_products" => [%{"id" => 0, "quantity" => 2}]})

      assert json_response(conn, 400)["errors"] == "Product inventory not found"
    end

    test "returns error when balance is insufficient", %{conn: conn, inventory: inventory} do
      conn = post(conn, "/api/purchase", %{"purchase_products" => [%{"id" => inventory.id, "quantity" => 42}]})

      assert json_response(conn, 400)["errors"] == "Not enough balance"
    end

    test "returns error when product inventory is insufficient", %{conn: conn, inventory: inventory} do
      conn =
        post(conn, "/api/purchase", %{
          "purchase_products" => [
            %{"id" => inventory.id, "quantity" => inventory.quantity + 1}
          ]
        })

      assert json_response(conn, 400)["errors"] == "Not enough inventory for product #{inventory.name}"
    end

    test "returns error when quantity is invalid", %{conn: conn, inventory: inventory} do
      conn = post(conn, "/api/purchase", %{"purchase_products" => [%{"id" => inventory.id, "quantity" => 0}]})

      assert json_response(conn, 400)["errors"] == "Quantity must be greater than 0"
    end
  end
end
