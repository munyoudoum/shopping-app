<script setup lang="ts">
import { computed } from "vue"
import CartCard from "src/components/CartCard.vue"
import { useCartStore } from "src/store/cart"
import { useProductStore } from "src/store/product"
import CartCardSkeleton from "../components/CartCardSkeleton.vue"

const cartStore = useCartStore()
const productStore = useProductStore()

const formattedCart = computed(() => cartStore.formattedCart)
</script>

<template>
  <div class="p-4 max-w-4xl mx-auto">
    <div v-if="!productStore.loaded" class="space-y-4">
      <CartCardSkeleton v-for="n in 15" :key="n" />
    </div>
    <div v-else-if="!formattedCart.length">
      <h1 class="text-xl text-center">
        Cart is empty.
      </h1>
    </div>
    <div v-else class="space-y-4">
      <CartCard
        v-for="(cartProduct, index) in formattedCart"
        :key="index"
        :cart-product="cartProduct"
      />
      <div class="text-right text-2xl md:text-4xl">
        <!-- precision 2 -->
        Total: ${{ cartStore.total.toFixed(2) }}
      </div>
      <div class="text-right">
        <button
          class="mb-4 p-2 bg-blue-500 text-white py-1 px-4 rounded-md"
          @click="cartStore.purchase"
        >
          Purchase
        </button>
      </div>
    </div>
  </div>
</template>
