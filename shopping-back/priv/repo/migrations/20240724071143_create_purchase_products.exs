defmodule Shopping.Repo.Migrations.CreatePurchaseProducts do
  use Ecto.Migration

  def change do
    create table(:purchase_products) do
      add :total_price, :decimal
      add :quantity, :integer
      add :purchase_record_id, references(:purchase_records, on_delete: :nothing)
      add :product_inventory_id, references(:product_inventories, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:purchase_products, [:purchase_record_id])
    create index(:purchase_products, [:product_inventory_id])
  end
end
