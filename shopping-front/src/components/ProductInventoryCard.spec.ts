import { render, fireEvent } from "@testing-library/vue";
import { describe, it, expect } from "vitest";
import ProductInventoryCard from "./ProductInventoryCard.vue";
import { createPinia, setActivePinia } from "pinia";
import { useProductStore } from "src/store/product";
import { useCartStore } from "src/store/cart";
import fixtures from "src/utils/test/fixtures";



describe("ProductInventoryCard", () => {
    beforeEach(() => {
        const pinia = createPinia();
        setActivePinia(pinia); // Set the active Pinia instance
        const productStore = useProductStore();
        productStore.items = {"1":fixtures.mockProduct};
        productStore.ids = [1];
      });

  it("renders product details correctly", () => {
    const { getByText, getByAltText } = render(ProductInventoryCard, {
      props: {
        product: fixtures.mockProduct,
      },
    });

    expect(getByText("Test Product")).toBeInTheDocument();
    expect(getByText("$19.99")).toBeInTheDocument();
    expect(getByAltText("Test Product")).toHaveAttribute(
      "src",
      "http://example.com/image.jpg"
    );
  });

  it("Cart contents are updated when 'Add to Cart' is clicked", async () => {
    const cartStore =useCartStore();
    const { getByText } = render(ProductInventoryCard, {
      props: {
        product: fixtures.mockProduct,
      },
    });

    const button = getByText("Add to Cart");
    await fireEvent.click(button);
    expect(cartStore.contents).toEqual({1: {quantity: 1, id: fixtures.mockProduct["id"]}});
  });
});
