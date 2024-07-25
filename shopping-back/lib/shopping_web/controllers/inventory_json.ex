defmodule ShoppingWeb.InventoryJSON do
  alias Shopping.Product.Inventory

  @doc """
  Renders a list of product_inventories.
  """
  def index(%{product_inventories: product_inventories}) do
    %{data: for(inventory <- product_inventories, do: data(inventory))}
  end

  @doc """
  Renders a single inventory.
  """
  def show(%{inventory: inventory}) do
    %{data: data(inventory)}
  end

  defp data(%Inventory{} = inventory) do
    %{
      id: inventory.id,
      name: inventory.name,
      description: inventory.description,
      price: inventory.price,
      quantity: inventory.quantity,
      image_url: inventory.image_url
    }
  end
end
