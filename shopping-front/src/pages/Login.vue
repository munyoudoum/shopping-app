<script setup lang="ts">
import { reactive, ref } from "vue"
import { routerPush } from "src/router"
import { api, handleFetchError } from "src/services"
import type { NewUser } from "src/services/api"
import { useUserStore } from "src/store/user"

const formRef = ref<HTMLFormElement | null>(null)
const form: NewUser = reactive({
  username: "",
  password: "",
})

const { updateUser } = useUserStore()

async function login() {
  if (!formRef.value?.checkValidity())
    return

  try {
    const result = await api.users.login({ user: form })
    updateUser(result.data)
    await routerPush("home")
  }
  catch (error) {
    handleFetchError(error)
  }
}
</script>

<template>
  <div class="flex items-center justify-center mx-4">
    <div class="w-full max-w-md space-y-2">
      <h1 class="text-center text-2xl font-bold">
        Sign in
      </h1>
      <p class="text-center text-blue-500">
        <AppLink name="register">
          Need an account?
        </AppLink>
      </p>
      <form
        ref="formRef"
        aria-label="Login form"
        class="mt-4 space-y-4"
        @submit.prevent="login"
      >
        <fieldset>
          <input
            v-model="form.username"
            aria-label="Username"
            class="w-full p-2 border border-gray-300 rounded-lg"
            type="username"
            required
            placeholder="Username"
          >
        </fieldset>
        <fieldset>
          <input
            v-model="form.password"
            aria-label="Password"
            class="w-full p-2 border border-gray-300 rounded-lg"
            type="password"
            required
            placeholder="Password"
          >
        </fieldset>
        <button
          class="w-full py-2 bg-blue-500 text-white rounded-lg disabled:opacity-50"
          :disabled="!form.username || !form.password"
          type="submit"
        >
          Sign in
        </button>
      </form>
    </div>
  </div>
</template>
