import { computed, ref } from "vue"
import { defineStore } from "pinia"
import { api } from "src/services"
import type { LoginResponse, UserStorage } from "src/services/api"
import Storage from "src/utils/storage"

export const userStorage = new Storage<UserStorage>("user")

export const isAuthorized = (): boolean => !!userStorage.get()

export const useUserStore = defineStore("user", () => {
  const user = ref(userStorage.get())
  const isAuthorized = computed(() => !!user.value)

  function updateUser(userData?: LoginResponse | null): void {
    if (userData) {
      const userStorageData = { ...userData.user, token: userData.token }
      userStorage.set(userStorageData)
      api.setSecurityData(userData.token)
      user.value = userStorageData
    }
    else {
      userStorage.remove()
      api.setSecurityData(null)
      user.value = null
    }
  }

  return {
    user,
    isAuthorized,
    updateUser,
  }
})
