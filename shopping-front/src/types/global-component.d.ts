import type AppLink from "src/components/AppLink.vue"

declare module "@vue/runtime-core" {
  export interface GlobalComponents {
    AppLink: typeof AppLink
  }
}
