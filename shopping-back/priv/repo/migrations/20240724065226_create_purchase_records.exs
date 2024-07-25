defmodule Shopping.Repo.Migrations.CreatePurchaseRecords do
  use Ecto.Migration

  def change do
    create table(:purchase_records) do
      add :total_price, :decimal
      add :purchase_date, :utc_datetime
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:purchase_records, [:user_id])
  end
end
