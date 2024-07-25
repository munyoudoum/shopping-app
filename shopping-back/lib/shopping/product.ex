defmodule Shopping.Product do
  @moduledoc """
  The Product context.
  """

  import Ecto.Query, warn: false
  alias Shopping.Repo

  alias Shopping.Product.Inventory
  alias Shopping.Product.PurchaseRecord
  alias Shopping.Product.PurchaseProduct

  @doc """
  Returns the list of product_inventories.

  ## Examples

      iex> list_product_inventories()
      [%Inventory{}, ...]

  """
  def list_product_inventories do
    Repo.all(Inventory)
  end

  @doc """
  Returns the list of product_inventories by ids with pessimistic lock for update.

  ## Examples

      iex> list_product_inventories_by_ids([1, 2, 3])
      [%Inventory{}, ...]

  """
  def list_product_inventories_by_ids(ids) do
    query = from(i in Inventory, where: i.id in ^ids, lock: "FOR UPDATE NOWAIT")
    Repo.all(query)
  end

  @doc """
  Gets a single inventory.

  Raises `Ecto.NoResultsError` if the Inventory does not exist.

  ## Examples

      iex> get_inventory!(123)
      %Inventory{}

      iex> get_inventory!(456)
      ** (Ecto.NoResultsError)

  """
  def get_inventory!(id), do: Repo.get!(Inventory, id)

  @doc """
  Creates a inventory.

  ## Examples

      iex> create_inventory(%{field: value})
      {:ok, %Inventory{}}

      iex> create_inventory(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_inventory(attrs \\ %{}) do
    %Inventory{}
    |> Inventory.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a inventory.

  ## Examples

      iex> update_inventory(inventory, %{field: new_value})
      {:ok, %Inventory{}}

      iex> update_inventory(inventory, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_inventory(%Inventory{} = inventory, attrs) do
    inventory
    |> Inventory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a inventory.

  ## Examples

      iex> delete_inventory(inventory)
      {:ok, %Inventory{}}

      iex> delete_inventory(inventory)
      {:error, %Ecto.Changeset{}}

  """
  def delete_inventory(%Inventory{} = inventory) do
    Repo.delete(inventory)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking inventory changes.

  ## Examples

      iex> change_inventory(inventory)
      %Ecto.Changeset{data: %Inventory{}}

  """
  def change_inventory(%Inventory{} = inventory, attrs \\ %{}) do
    Inventory.changeset(inventory, attrs)
  end

  def create_purchase_record(attrs) do
    %PurchaseRecord{}
    |> PurchaseRecord.changeset(attrs)
    |> Repo.insert()
  end

  def create_purchase_product(attrs) do
    %PurchaseProduct{}
    |> PurchaseProduct.changeset(attrs)
    |> Repo.insert()
  end

    @doc """
    Gets a single purchase record

    Raises `Ecto.NoResultsError` if the PurchaseRecord does not exist.

    ## Examples

        iex> get_purchase_record!(123)
        %PurchaseRecord{}

        iex> get_purchase_record!(456)
        ** (Ecto.NoResultsError)

    """
    def get_purchase_record!(id), do: Repo.get!(PurchaseRecord, id)
end
