<script setup lang="ts">
import { computed } from "vue"
import { useProductStore } from "src/store/product"
import ProductInventoryCard from "./ProductInventoryCard.vue"

const productStore = useProductStore()

const products = computed(() => productStore.list)
</script>

<template>
  <div v-if="!productStore.loaded">
    Loading...
  </div>
  <template v-else>
    <div class="flex flex-wrap justify-evenly m-4">
      <ProductInventoryCard
        v-for="product in products"
        :key="product.id"
        :product="product"
      />
    </div>
  </template>
</template>
