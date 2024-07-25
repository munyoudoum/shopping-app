import { onUnmounted } from "vue"
import { cartStorage, useCartStore } from "src/store/cart"

export function usePersistCart() {
  const cartStore = useCartStore()

  const unsub = cartStore.$subscribe(() => {
    cartStorage.set(cartStore.contents)
  })

  onUnmounted(() => {
    unsub()
  })
}
