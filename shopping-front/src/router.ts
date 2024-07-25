import type { RouteParams, RouteRecordRaw } from "vue-router"
import { createRouter, createWebHashHistory } from "vue-router"
import Home from "./pages/Home.vue"
import { isAuthorized } from "./store/user"

export type AppRouteNames = "home" | "login" | "register" | "user" | "cart"

export const routes: RouteRecordRaw[] = [
  {
    name: "home",
    path: "/",
    component: Home,
  },
  {
    name: "login",
    path: "/login",
    component: () => import("./pages/Login.vue"),
    beforeEnter: () => !isAuthorized(),
  },
  {
    name: "register",
    path: "/register",
    component: () => import("./pages/Register.vue"),
    beforeEnter: () => !isAuthorized(),
  },
  {
    name: "cart",
    path: "/cart",
    component: () => import("./pages/Cart.vue"),
  },
  {
    name: "user",
    path: "/user",
    component: () => import("./pages/User.vue"),
  },
]
export const router = createRouter({
  history: createWebHashHistory(),
  routes,
})

export function routerPush(
  name: AppRouteNames,
  params?: RouteParams,
): ReturnType<typeof router.push> {
  return params === undefined
    ? router.push({ name })
    : router.push({ name, params })
}
