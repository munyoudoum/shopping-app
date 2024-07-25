<script setup lang="ts">
import { reactive, ref } from "vue"
import { useToast } from "src/plugins/toast"
import { routerPush } from "src/router"
import { api, handleFetchError } from "src/services"
import type { NewUser } from "src/services/api"

const formRef = ref<HTMLFormElement | null>(null)
const form: NewUser = reactive({
  username: "",
  password: "",
})

const toast = useToast()
async function register() {
  if (!formRef.value?.checkValidity())
    return

  try {
    await api.users.register({ user: form })
    toast.success("Registration successful")
    await routerPush("login")
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
        Sign up
      </h1>
      <p class="text-center text-blue-500">
        <AppLink name="login">
          Have an account?
        </AppLink>
      </p>
      <form
        ref="formRef"
        aria-label="Registration form"
        class="mt-4 space-y-4"
        @submit.prevent="register"
      >
        <fieldset>
          <input
            v-model="form.username"
            aria-label="Username"
            class="w-full p-2 border border-gray-300 rounded-lg"
            type="text"
            required
            placeholder="Your Name"
          >
        </fieldset>
        <fieldset>
          <input
            v-model="form.password"
            aria-label="Password"
            class="form-control w-full p-2 border rounded"
            type="password"
            :minLength="8"
            required
            placeholder="Password"
          >
        </fieldset>
        <button
          type="submit"
          class="w-full bg-blue-500 text-white py-2 rounded disabled:opacity-50"
          :disabled="!(form.username && form.password)"
        >
          Sign up
        </button>
      </form>
    </div>
  </div>
</template>
