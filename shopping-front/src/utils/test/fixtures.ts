import { CartPreview } from "@/store/cart";
import type { LoginResponse, ProductInventory } from "src/services/api";

const loginResponse: LoginResponse = {
  user: {
    id: 1,
    username: "test",
    balance: "0",
  },
  token: "token",
};

const mockProduct: ProductInventory = {
  id: 1,
  name: "Test Product",
  price: "19.99",
  image_url: "http://example.com/image.jpg",
  quantity: 2,
  description: "Test description",
};

const mockCartStoreContents = {
  "1": { id: 1, quantity: 2 },
};

export default {
  loginResponse,
  mockProduct,
  mockCartStoreContents,
};
