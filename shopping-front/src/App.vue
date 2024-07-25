<script setup lang="ts">
import { RouterView } from "vue-router"
import { usePersistCart } from "src/composable/usePersistCart"
import { useProductStore } from "src/store/product"
import AppNavigation from "./components/AppNavigation.vue"

const productStore = useProductStore()

productStore.fetchAll()
usePersistCart()
</script>

<template>
  <AppNavigation />
  <RouterView />
</template>
