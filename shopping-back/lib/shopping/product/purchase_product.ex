defmodule Shopping.Product.PurchaseProduct do
  use Ecto.Schema
  import Ecto.Changeset

  schema "purchase_products" do
    field :total_price, :decimal
    field :quantity, :integer
    belongs_to :purchase_record, Shopping.Product.PurchaseRecord
    belongs_to :product_inventory, Shopping.Product.Inventory

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(purchase_product, attrs) do
    purchase_product
    |> cast(attrs, [:total_price, :quantity, :purchase_record_id, :product_inventory_id])
    |> validate_required([:total_price, :quantity, :purchase_record_id, :product_inventory_id])
  end
end
