defmodule ShoppingWeb.InventoryControllerTest do
  use ShoppingWeb.ConnCase

  import Shopping.ProductFixtures

  alias Shopping.Product.Inventory

  @create_attrs %{
    name: "some name",
    description: "some description",
    price: "120.5",
    quantity: 42,
    image_url: "some image_url"
  }
  @update_attrs %{
    name: "some updated name",
    description: "some updated description",
    price: "456.7",
    quantity: 43,
    image_url: "some updated image_url"
  }
  @invalid_attrs %{name: nil, description: nil, price: nil, quantity: nil, image_url: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all product_inventories", %{conn: conn} do
      conn = get(conn, ~p"/api/product_inventories")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create inventory" do
    test "renders inventory when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/product_inventories", inventory: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/product_inventories/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some description",
               "image_url" => "some image_url",
               "name" => "some name",
               "price" => "120.5",
               "quantity" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/product_inventories", inventory: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update inventory" do
    setup [:create_inventory]

    test "renders inventory when data is valid", %{conn: conn, inventory: %Inventory{id: id} = inventory} do
      conn = put(conn, ~p"/api/product_inventories/#{inventory}", inventory: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/product_inventories/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "image_url" => "some updated image_url",
               "name" => "some updated name",
               "price" => "456.7",
               "quantity" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, inventory: inventory} do
      conn = put(conn, ~p"/api/product_inventories/#{inventory}", inventory: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete inventory" do
    setup [:create_inventory]

    test "deletes chosen inventory", %{conn: conn, inventory: inventory} do
      conn = delete(conn, ~p"/api/product_inventories/#{inventory}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/product_inventories/#{inventory}")
      end
    end
  end

  defp create_inventory(_) do
    inventory = inventory_fixture()
    %{inventory: inventory}
  end
end
