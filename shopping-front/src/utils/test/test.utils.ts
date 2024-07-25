import { Suspense, defineComponent, h } from "vue"
import type { RouteLocationRaw, Router } from "vue-router"
import { createMemoryHistory, createRouter } from "vue-router"
import { createTestingPinia } from "@pinia/testing"
import type { RenderOptions } from "@testing-library/vue"
import AppLink from "src/components/AppLink.vue"
import { routes } from "src/router"

export function createTestRouter(base?: string): Router {
  return createRouter({
    routes,
    history: createMemoryHistory(base),
  })
}

interface RenderOptionsArgs {
  props: Record<string, unknown>
  slots: Record<string, (...args: unknown[]) => unknown>

  router?: Router
  initialRoute: RouteLocationRaw

  initialState: Record<string, unknown>
  stubActions: boolean
}

const scheduler = typeof setImmediate === "function" ? setImmediate : setTimeout

export function flushPromises(): Promise<void> {
  return new Promise((resolve) => {
    scheduler(resolve, 0)
  })
}

export function renderOptions(): RenderOptions
export function renderOptions(args: Partial<Omit<RenderOptionsArgs, "initialRoute">>): RenderOptions
export async function renderOptions(args: (Partial<RenderOptionsArgs> & { initialRoute: RouteLocationRaw })): Promise<RenderOptions>
export function renderOptions(args: Partial<RenderOptionsArgs> = {}): RenderOptions | Promise<RenderOptions> {
  const router = args.router || createTestRouter()

  const result = {
    props: args.props,
    slots: args.slots,
    global: {
      plugins: [
        router,
        createTestingPinia({
          initialState: {
            user: { user: null },
            ...args.initialState,
          },
          stubActions: args.stubActions ?? false,
        }),
      ],
      components: { AppLink },
    },
  }

  const { initialRoute } = args

  if (!initialRoute)
    return result

  return new Promise((resolve) => {
    void router.replace(initialRoute).then(() => resolve(result))
  })
}

export function asyncWrapper(component: ReturnType<typeof defineComponent>, props?: Record<string, unknown>): ReturnType<typeof defineComponent> {
  return defineComponent({
    render() {
      return h(
        "div",
        { id: "root" },
        h(Suspense, null, {
          default() {
            return h(component, props)
          },
          fallback: h("div", "Loading..."),
        }),
      )
    },
  })
}
