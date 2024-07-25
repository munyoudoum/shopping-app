<script setup lang="ts">
import type { CartPreview } from "src/store/cart"
import { useCartStore } from "src/store/cart"

defineProps<{
  cartProduct: CartPreview
}>()

const cartStore = useCartStore()
</script>

<template>
  <div class="flex border p-4 rounded-md">
    <figure class="flex-shrink-0 w-1/3">
      <img
        :src="cartProduct.image_url"
        :alt="cartProduct.name"
        class="object-contain w-full h-48"
      >
    </figure>
    <div class="flex-grow ml-4">
      <h2 class="text-xl font-bold">
        {{ cartProduct.name }}
      </h2>
      <p class="mt-2 text-lg">
        ${{ cartProduct.cost }}
      </p>
      <div class="mt-4">
        <div class="btn-group">
          <button
            class="bg-blue-500 p-3 rounded-l-lg text-white"
            @click="cartStore.remove(cartProduct.id)"
          >
            -
          </button>
          <button class="btn btn-ghost no-animation mx-3">
            {{ cartProduct.quantity }}
          </button>
          <button
            class="bg-blue-500 p-3 rounded-r-lg text-white"
            @click="cartStore.add(cartProduct.id)"
          >
            +
          </button>
        </div>
      </div>
    </div>
  </div>
</template>
