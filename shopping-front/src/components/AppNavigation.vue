<script setup lang="ts">
import { computed } from "vue"
import type { RouteParams } from "vue-router"
import { storeToRefs } from "pinia"
import type { AppRouteNames } from "src/router"
import { useCartStore } from "src/store/cart"
import { useUserStore } from "src/store/user"

interface NavLink {
  name: AppRouteNames
  params?: Partial<RouteParams>
  title: string
  display: "all" | "anonym" | "authorized"
}

const { user } = storeToRefs(useUserStore())
const cartStore = useCartStore()
const CartCount = computed(() => cartStore.count)
const username = computed(() => user.value?.username)
const displayStatus = computed(() =>
  username.value ? "authorized" : "anonym",
)

const allNavLinks = computed<NavLink[]>(() => [
  {
    name: "register",
    title: "Sign up",
    display: "anonym",
  },
  {
    name: "cart",
    title: `Cart (${CartCount.value})`,
    display: "all",
  },
  {
    name: "user",
    title: "User",
    display: "authorized",
  },
])

const navLinks = computed(() =>
  allNavLinks.value.filter(
    l => l.display === displayStatus.value || l.display === "all",
  ),
)
</script>

<template>
  <nav class="bg-white shadow">
    <div class="container mx-auto p-4 flex justify-between items-center mb-2">
      <AppLink class="text-xl font-bold" name="home">
        Shop Name
      </AppLink>

      <ul class="flex space-x-4">
        <li v-for="link in navLinks" :key="link.name" class="nav-item">
          <AppLink
            class="text-gray-700 hover:text-blue-500"
            active-class="text-blue-500"
            :name="link.name"
            :params="link.params"
            :aria-label="link.title"
          >
            {{ link.title }}
          </AppLink>
        </li>
      </ul>
    </div>
  </nav>
</template>
