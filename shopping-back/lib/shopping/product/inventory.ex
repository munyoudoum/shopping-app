defmodule Shopping.Product.Inventory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "product_inventories" do
    field :name, :string
    field :description, :string
    field :price, :decimal
    field :quantity, :integer
    field :image_url, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(inventory, attrs) do
    inventory
    |> cast(attrs, [:name, :description, :price, :quantity, :image_url])
    |> validate_required([:name, :description, :price, :quantity, :image_url])
  end
end
