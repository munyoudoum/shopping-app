defmodule ShoppingWeb.PurchaseController do
  use ShoppingWeb, :controller

  alias Shopping.UserManager
  alias Shopping.Product
  alias Shopping.UserManager.Guardian
  action_fallback ShoppingWeb.FallbackController

  @doc """
  Purchase multiple products.

  ## Examples

      iex> purchase(conn, %{"purchase_products" => [%{"id": 1, "quantity": 2}]})
      {:ok, %PurchaseRecord{}}
  """
  def purchase(conn, %{"purchase_products" => purchase_products}) do
    user = Guardian.Plug.current_resource(conn)
    product_inventory_ids = Enum.map(purchase_products, fn p -> p["id"] end)
    Ecto.Multi.new()
    |> Ecto.Multi.run(:product_inventories, fn _repo, _changes ->
      try do
        product_inventories = Product.list_product_inventories_by_ids(product_inventory_ids)
        # can sleep 5 seconds here to simulate a lock to test
        {:ok, product_inventories}
      rescue
        e in Postgrex.Error ->
          if e.postgres.code == :lock_not_available do
            {:error, "Someone is purchasing the same product, please try again later"}
          else
            {:error, "An unexpected error occurred"}
          end
      end
    end)
    |> Ecto.Multi.run(:calculate_total_price, fn _repo, %{product_inventories: product_inventories} ->
      calculate_total_price(purchase_products, product_inventories)
    end)
    |> Ecto.Multi.run(:check_balance, fn _repo, %{calculate_total_price: {total_price, _}} ->
      check_balance(user.balance, total_price)
    end)
    |> Ecto.Multi.run(:create_purchase_record, fn _repo,
                                                  %{
                                                    calculate_total_price: {total_price, _}
                                                  } ->
      Product.create_purchase_record(%{
        total_price: total_price,
        user_id: user.id,
        purchase_date: DateTime.utc_now()
      })
    end)
    |> Ecto.Multi.run(:update_user, fn _repo, %{create_purchase_record: purchase_record} ->
      UserManager.update_user(user, %{
        balance: Decimal.sub(user.balance, purchase_record.total_price)
      })
    end)
    |> Ecto.Multi.run(:create_purchase_products, fn _repo,
                                                    %{
                                                      create_purchase_record: purchase_record,
                                                      calculate_total_price:
                                                        {_, purchase_products}
                                                    } ->
      Enum.each(purchase_products, fn %{
                                        "id" => id,
                                        "quantity" => quantity,
                                        "total_price" => total_price
                                      } ->
        Product.create_purchase_product(%{
          purchase_record_id: purchase_record.id,
          product_inventory_id: id,
          quantity: quantity,
          total_price: total_price
        })
      end)

      {:ok, :created}
    end)
    |> Shopping.Repo.transaction()
    |> case do
      {:ok, %{create_purchase_record: purchase_record}} ->
        conn |> put_status(:created) |> render(:show, purchase_record: purchase_record)

      {:error, _operation, message, _changes} ->
        conn |> put_status(:bad_request) |> json(%{errors: message})
    end
  end

  defp check_balance(balance, total_price) do
    if Decimal.lt?(balance, total_price) do
      {:error, "Not enough balance"}
    else
      {:ok, "Enough balance"}
    end
  end

  # Example: calculate_total_price([%{"id": 1, "quantity": 2}]], [%Inventory{}])
  # Returns the total price of the purchase and each total price of each product
  defp calculate_total_price(purchase_products, product_inventories) do
    # Loop purchase_products and update total price of each product in the list
    Enum.reduce_while(purchase_products, {0, []}, fn purchase_product, {acc, purchase_products} ->
      id = Map.get(purchase_product, "id")
      quantity = Map.get(purchase_product, "quantity")
      product_inventory = Enum.find(product_inventories, fn p -> p.id == id end)
      cond do
        product_inventory == nil ->
          {:halt, {:error, "Product inventory not found"}}

        quantity <= 0 ->
          {:halt, {:error, "Quantity must be greater than 0"}}

        product_inventory.quantity < quantity ->
          {:halt, {:error, "Not enough inventory for product #{product_inventory.name}"}}

        true ->
          Product.update_inventory(product_inventory, %{
            quantity: product_inventory.quantity - quantity
          })

          total_price_product = Decimal.mult(product_inventory.price, quantity)
          purchase_product = Map.put(purchase_product, "total_price", total_price_product)

          {:cont,
           {Decimal.add(acc, total_price_product), purchase_products ++ [purchase_product]}}
      end
    end)
    |> case do
      {:error, message} ->
        {:error, message}

      {total_price, purchase_products} ->
        {:ok, {total_price, purchase_products}}
    end
  end
end
