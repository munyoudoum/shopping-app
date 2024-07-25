import { defineStore } from "pinia"
import { useToast } from "src/plugins/toast"
import { api, handleFetchError } from "src/services"
import Storage from "src/utils/storage"
import { useProductStore } from "./product"

export interface Purchase {
  id: number
  quantity: number
}

interface CartState {
  contents: Record<string, Purchase>
}

export interface CartPreview {
  id: number
  image_url: string
  name: string
  quantity: number
  cost: number
}

export const cartStorage = new Storage<Record<string, Purchase>>(
  "CART_STORAGE",
)

const toast = useToast()
export const useCartStore = defineStore({
  id: "cart",

  state: (): CartState => ({
    contents: cartStorage.get() ?? {},
  }),

  getters: {
    count(): number {
      return Object.keys(this.contents).reduce((acc, id) => {
        return acc + this.contents[id].quantity
      }, 0)
    },

    total(): number {
      const products = useProductStore()
      return Object.keys(this.contents).reduce((acc, id) => {
        return (
          acc + Number(products.items[id].price) * this.contents[id].quantity
        )
      }, 0)
    },

    formattedCart(): CartPreview[] {
      const products = useProductStore()

      if (!products.loaded)
        return []
      return Object.keys(this.contents).map((productId) => {
        const purchase = this.contents[productId]
        return {
          id: purchase.id,
          image_url: products.items[purchase.id].image_url,
          name: products.items[purchase.id].name,
          quantity: purchase.quantity,
          cost: purchase.quantity * Number(products.items[purchase.id].price),
        }
      })
    },
  },

  actions: {
    add(id: number) {
      const products = useProductStore()
      const availableQuantity = products.items[id].quantity
      const cartItem = this.contents[id]
      if (cartItem) {
        if (cartItem.quantity < availableQuantity) {
          cartItem.quantity += 1
          toast.success("Added one more to cart")
        }
        else {
          toast.error("Cannot add more to cart, not enough stock")
        }
      }
      else {
        if (availableQuantity > 0) {
          this.contents[id] = {
            id,
            quantity: 1,
          }
          toast.success("Added to cart")
        }
        else {
          toast.error("Cannot add to cart, product is out of stock")
        }
      }
    },
    remove(id: number) {
      const cartItem = this.contents[id]
      if (!cartItem)
        return
      cartItem.quantity -= 1
      if (cartItem.quantity === 0) {
        toast.success("Removed from cart")
        delete this.contents[id]
      }
      else {
        toast.success("Removed one from cart")
      }
    },
    async purchase() {
      // Simulate a checkout
      try {
        await api.products.purchase({ purchase_products: Object.values(this.contents) })
        toast.success("Purchase successful")
        this.contents = {}
      }
      catch (error) {
        handleFetchError(error)
      }
    },
  },
})
