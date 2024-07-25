defmodule ShoppingWeb.InventoryController do
  use ShoppingWeb, :controller

  alias Shopping.Product
  alias Shopping.Product.Inventory
  action_fallback ShoppingWeb.FallbackController

  def index(conn, _params) do
    product_inventories = Product.list_product_inventories()
    render(conn, :index, product_inventories: product_inventories)
  end

  def create(conn, %{"inventory" => inventory_params}) do
    with {:ok, %Inventory{} = inventory} <- Product.create_inventory(inventory_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/product_inventories/#{inventory}")
      |> render(:show, inventory: inventory)
    end
  end

  def show(conn, %{"id" => id}) do
    inventory = Product.get_inventory!(id)
    render(conn, :show, inventory: inventory)
  end

  def update(conn, %{"id" => id, "inventory" => inventory_params}) do
    inventory = Product.get_inventory!(id)

    with {:ok, %Inventory{} = inventory} <- Product.update_inventory(inventory, inventory_params) do
      render(conn, :show, inventory: inventory)
    end
  end

  def delete(conn, %{"id" => id}) do
    inventory = Product.get_inventory!(id)

    with {:ok, %Inventory{}} <- Product.delete_inventory(inventory) do
      send_resp(conn, :no_content, "")
    end
  end
end
