defmodule ShoppingWeb.PurchaseJSON do
  alias Shopping.Product.PurchaseRecord

  @doc """
  Renders a single purchase record.
  """
  def show(%{purchase_record: purchase_record}) do
    %{data: data(purchase_record)}
  end

  defp data(%PurchaseRecord{} = purchase_record) do
    %{
      id: purchase_record.id,
      user_id: purchase_record.user_id,
      total_price: purchase_record.total_price,
      purchase_date: purchase_record.purchase_date
    }
  end
end
