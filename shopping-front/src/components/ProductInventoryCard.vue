<script setup lang="ts">
import type { ProductInventory } from "src/services/api"
import { useCartStore } from "src/store/cart"

interface Props {
  product: ProductInventory
}

defineProps<Props>()
const cartStore = useCartStore()
</script>

<template>
  <div class="p-4 border border-gray-300 rounded-md m-2 w-80">
    <h2 class="text-xl text-center font-semibold line-clamp-1">
      {{ product.name }}
    </h2>
    <img
      class="w-80 h-80 object-contain my-2"
      :src="product.image_url"
      :alt="product.name"
    >
    <p class="">
      ${{ product.price }}
    </p>
    <button
      class="mt-2 p-2 bg-blue-500 text-white py-1 px-4 rounded-md"
      @click="cartStore.add(product.id)"
    >
      Add to Cart
    </button>
  </div>
</template>
