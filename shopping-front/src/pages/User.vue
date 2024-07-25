<script setup lang="ts">
import { computed, onMounted, ref } from "vue"
import { routerPush } from "src/router"
import { api } from "src/services"
import { useUserStore } from "src/store/user"
import type { User } from "@/services/api"

const user = ref<User | null>(null)
const userStore = useUserStore()
const userData = computed(() => user.value)

async function onLogout() {
  userStore.updateUser(null)
  await routerPush("home")
}

onMounted(async () => {
  if (!userStore.isAuthorized)
    return await routerPush("login")
  try {
    const response = await api.users.getCurrentUser()
    user.value = response.data.data
  }
  catch (error) {
    console.error(error)
  }
})
</script>

<template>
  <div class="flex flex-col items-center justify-center">
    <h1 class="text-2xl font-semibold">
      User
    </h1>
    <div class="flex flex-col items-center justify-center space-y-2 w-80">
      <div class="flex justify-between w-full">
        <p class="text-lg">
          Username:
        </p>
        <p class="text-lg">
          {{ userData?.username }}
        </p>
      </div>
      <div class="flex justify-between w-full">
        <p class="text-lg">
          Balance:
        </p>
        <p class="text-lg">
          ${{ userData?.balance }}
        </p>
      </div>
      <button
        class="mt-4 p-2 bg-blue-500 text-white py-1 px-4 rounded-md"
        @click="onLogout"
      >
        Logout
      </button>
    </div>
  </div>
</template>
