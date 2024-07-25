defmodule Shopping.ProductFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Shopping.Product` context.
  """

  @doc """
  Generate a inventory.
  """
  def inventory_fixture(attrs \\ %{}) do
    {:ok, inventory} =
      attrs
      |> Enum.into(%{
        description: "some description",
        image_url: "some image_url",
        name: "some name",
        price: "2.5",
        quantity: 42
      })
      |> Shopping.Product.create_inventory()

    inventory
  end
end
