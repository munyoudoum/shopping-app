import { useToast as useToastOriginal } from "vue-toastification"

// Wrapper to use the toast plugin in the tests
export function useToast(): ReturnType<typeof useToastOriginal> {
  return useToastOriginal()
}
