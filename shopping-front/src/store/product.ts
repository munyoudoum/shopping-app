import { defineStore } from "pinia"
import { api } from "src/services"
import type { ProductInventory } from "src/services/api"

interface ProductState {
  items: Record<string, ProductInventory>
  ids: number[]
}

export const useProductStore = defineStore({
  id: "product",

  state: (): ProductState => ({
    items: {},
    ids: [],
  }),

  getters: {
    list(): ProductInventory[] {
      return this.ids.map(i => this.items[i])
    },

    loaded(): boolean {
      return this.ids.length > 0
    },
  },

  actions: {
    async fetchAll() {
      if (this.loaded)
        return

      const response = await api.products.getProductInventories()
      const data: ProductInventory[] = response.data.data
      this.ids = data.map((product) => {
        this.items[product.id] = product
        return product.id
      })
    },
  },
})
