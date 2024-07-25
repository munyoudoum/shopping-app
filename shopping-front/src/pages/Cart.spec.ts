import { fireEvent, render, screen } from "@testing-library/vue";
import { describe, it, expect, beforeEach } from "vitest";
import Cart from "./Cart.vue";
import { createPinia, setActivePinia } from "pinia";
import { useCartStore } from "src/store/cart";
import { useProductStore } from "src/store/product";
import fixtures from "src/utils/test/fixtures";

describe("Cart Page", () => {
  beforeEach(() => {
    const pinia = createPinia();
    setActivePinia(pinia);
    const cartStore = useCartStore();
    const productStore = useProductStore();
    // Mocking the cart and product store data
    cartStore.contents = fixtures.mockCartStoreContents;
    productStore.items = {
      "1": fixtures.mockProduct,
    };
    productStore.ids = [1];
  });

  it("renders cart items correctly", () => {
    render(Cart);

    expect(screen.getByText("Test Product")).toBeInTheDocument();
    expect(screen.getByText("$39.98")).toBeInTheDocument(); // Total for 2 items
    expect(
      screen.getByRole("button", { name: "Purchase" })
    ).toBeInTheDocument();
  });

  it("displays empty cart message when cart is empty", async () => {
    const cartStore = useCartStore();
    cartStore.contents = {};

    render(Cart);

    expect(screen.getByText("Cart is empty.")).toBeInTheDocument();
  });

    it("updates cart contents when '-' or '+' is clicked", async () => {
        const cartStore = useCartStore();
        render(Cart);
        expect(screen.getByText("-")).toBeInTheDocument();
        const removebutton = screen.getByText("-");
        await fireEvent.click(removebutton);
        expect(cartStore.contents).toEqual({"1": {quantity: 1, id: 1}});

        expect(screen.getByText("+")).toBeInTheDocument();
        const addButton = screen.getByText("+");
        await fireEvent.click(addButton);

        expect(cartStore.contents).toEqual({"1": {quantity: 2, id: 1}});
        
        await fireEvent.click(removebutton);
        await fireEvent.click(removebutton);

        expect(cartStore.contents).toEqual({});
    });
});
