/** main.ts — Vue app bootstrap with Pinia and Router plugins */
import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from '@/App.vue'
import router from '@/router'
import LottieAnimation from '@/components/LottieAnimation'
import { useAuthStore } from '@/stores/auth'
import '@/animations/bloom.css'
import '@/animations/transitions.css'
import '@/animations/keyframes.css'
import '@/style.css'

const app = createApp(App)
const pinia = createPinia()

app.use(pinia)
app.component('LottieAnimation', LottieAnimation)

const authStore = useAuthStore(pinia)
void authStore.fetchUser()

app.use(router)
app.mount('#app')
