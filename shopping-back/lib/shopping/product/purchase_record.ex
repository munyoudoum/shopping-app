defmodule Shopping.Product.PurchaseRecord do
  use Ecto.Schema
  import Ecto.Changeset

  schema "purchase_records" do
    field :total_price, :decimal
    field :purchase_date, :utc_datetime
    belongs_to :user, Shopping.UserManager.User
    has_many :purchase_products, Shopping.Product.PurchaseProduct

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(purchase_record, attrs) do
    purchase_record
    |> cast(attrs, [:total_price, :purchase_date, :user_id])
    |> validate_required([:total_price, :purchase_date, :user_id])
  end
end
