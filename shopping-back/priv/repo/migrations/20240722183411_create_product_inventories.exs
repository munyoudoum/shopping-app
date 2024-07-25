defmodule Shopping.Repo.Migrations.CreateProductInventories do
  use Ecto.Migration

  def change do
    create table(:product_inventories) do
      add :name, :string
      add :description, :text
      add :price, :decimal
      add :quantity, :integer
      add :image_url, :text

      timestamps(type: :utc_datetime)
    end
  end
end
