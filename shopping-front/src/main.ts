import { createApp } from "vue"
import type { PluginOptions } from "vue-toastification"
import Toast, { POSITION } from "vue-toastification"
import { createPinia } from "pinia"
import App from "./App.vue"
import registerGlobalComponents from "./plugins/global-components"
import setAuthorizationToken from "./plugins/set-authorization-token"
import { router } from "./router"
import "./styles/main.css"
import "vue-toastification/dist/index.css"

const app = createApp(App)
const options: PluginOptions = {
  position: POSITION.BOTTOM_RIGHT,
  timeout: 2000,
}

app.use(Toast, options)
app.use(createPinia())
app.use(router)

setAuthorizationToken()
registerGlobalComponents(app)

app.mount("#app")
