defmodule Shopping.ProductTest do
  use Shopping.DataCase

  alias Shopping.Product

  describe "product_inventories" do
    alias Shopping.Product.Inventory

    import Shopping.ProductFixtures

    @invalid_attrs %{name: nil, description: nil, price: nil, quantity: nil, image_url: nil}

    test "list_product_inventories/0 returns all product_inventories" do
      inventory = inventory_fixture()
      assert Product.list_product_inventories() == [inventory]
    end

    test "get_inventory!/1 returns the inventory with given id" do
      inventory = inventory_fixture()
      assert Product.get_inventory!(inventory.id) == inventory
    end

    test "create_inventory/1 with valid data creates a inventory" do
      valid_attrs = %{name: "some name", description: "some description", price: "120.5", quantity: 42, image_url: "some image_url"}

      assert {:ok, %Inventory{} = inventory} = Product.create_inventory(valid_attrs)
      assert inventory.name == "some name"
      assert inventory.description == "some description"
      assert inventory.price == Decimal.new("120.5")
      assert inventory.quantity == 42
      assert inventory.image_url == "some image_url"
    end

    test "create_inventory/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Product.create_inventory(@invalid_attrs)
    end

    test "update_inventory/2 with valid data updates the inventory" do
      inventory = inventory_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description", price: "456.7", quantity: 43, image_url: "some updated image_url"}

      assert {:ok, %Inventory{} = inventory} = Product.update_inventory(inventory, update_attrs)
      assert inventory.name == "some updated name"
      assert inventory.description == "some updated description"
      assert inventory.price == Decimal.new("456.7")
      assert inventory.quantity == 43
      assert inventory.image_url == "some updated image_url"
    end

    test "update_inventory/2 with invalid data returns error changeset" do
      inventory = inventory_fixture()
      assert {:error, %Ecto.Changeset{}} = Product.update_inventory(inventory, @invalid_attrs)
      assert inventory == Product.get_inventory!(inventory.id)
    end

    test "delete_inventory/1 deletes the inventory" do
      inventory = inventory_fixture()
      assert {:ok, %Inventory{}} = Product.delete_inventory(inventory)
      assert_raise Ecto.NoResultsError, fn -> Product.get_inventory!(inventory.id) end
    end

    test "change_inventory/1 returns a inventory changeset" do
      inventory = inventory_fixture()
      assert %Ecto.Changeset{} = Product.change_inventory(inventory)
    end
  end
end
