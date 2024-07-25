import { CONFIG } from "src/config"
import { useToast } from "src/plugins/toast"
import type { GenericErrorModel, HttpResponse } from "src/services/api"
import { Api, ContentType } from "src/services/api"

const toast = useToast()
export const limit = 10

export const api = new Api({
  baseUrl: `${CONFIG.API_HOST}/api`,
  securityWorker: token => token ? { headers: { Authorization: `Bearer ${String(token)}` } } : {},
  baseApiParams: {
    headers: {
      "content-type": ContentType.Json,
    },
    format: "json",
  },
})

export function pageToOffset(page: number = 1, localLimit = limit): { limit: number, offset: number } {
  const offset = (page - 1) * localLimit
  return { limit: localLimit, offset }
}

function isFetchError<E = GenericErrorModel>(e: unknown): e is HttpResponse<unknown, E> {
  return e instanceof Object && "error" in e
}

export function handleFetchError(e: unknown): void {
  if (isFetchError(e)) {
    let errorMessage = ""
    if (e.error.errors instanceof Object) {
      for (const key in e.error.errors)
        errorMessage += `${key}: ${e.error.errors[key]}\n`
    }
    else if (typeof e.error.errors === "string") {
      errorMessage = e.error.errors
    }

    toast.error(errorMessage || "An error occurred")
  }
}
