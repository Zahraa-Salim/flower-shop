<template>
  <section class="flex min-h-screen items-center justify-center bg-gradient-to-b from-rose-50 via-white to-emerald-50 px-4 py-10 sm:px-6 lg:px-8">
    <div class="mx-auto w-full max-w-md">
      <div class="rounded-[2rem] bg-white/90 p-8 shadow-sm ring-1 ring-rose-100">
        <div class="space-y-3 text-center">
          <p class="text-sm font-semibold uppercase tracking-[0.3em] text-rose-400">Welcome Back</p>
          <h1 class="heading-serif text-4xl font-semibold tracking-tight text-rose-950">Login</h1>
          <p class="text-sm leading-6 text-stone-500">
            Sign in to access your cart, checkout, and saved flower orders.
          </p>
        </div>

        <form
          class="mt-8 space-y-5"
          @submit.prevent="handleLogin"
        >
          <label class="block space-y-2">
            <span class="text-sm font-medium text-rose-900">Email</span>
            <input
              v-model="email"
              class="w-full rounded-2xl border border-rose-200 bg-rose-50 px-4 py-3 text-rose-950 outline-none transition placeholder:text-stone-400 focus:border-rose-300 focus:bg-white"
              type="email"
              placeholder="you@example.com"
              required
            />
          </label>

          <label class="block space-y-2">
            <span class="text-sm font-medium text-rose-900">Password</span>
            <input
              v-model="password"
              class="w-full rounded-2xl border border-rose-200 bg-rose-50 px-4 py-3 text-rose-950 outline-none transition placeholder:text-stone-400 focus:border-rose-300 focus:bg-white"
              type="password"
              placeholder="Enter your password"
              required
            />
          </label>

          <p
            v-if="errorMessage"
            class="rounded-2xl bg-rose-50 px-4 py-3 text-sm font-medium text-rose-700"
          >
            {{ errorMessage }}
          </p>

          <button
            class="w-full rounded-full bg-rose-300 px-6 py-3 text-base font-semibold text-rose-950 transition hover:bg-rose-400 disabled:cursor-not-allowed disabled:bg-rose-100 disabled:text-stone-400"
            type="submit"
            :disabled="loading"
          >
            {{ loading ? 'Signing in...' : 'Login' }}
          </button>
        </form>

        <p class="mt-6 text-center text-sm text-stone-500">
          Don’t have an account?
          <RouterLink
            class="font-semibold text-rose-700 transition hover:text-rose-900"
            to="/register"
          >
            Register
          </RouterLink>
        </p>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { supabase } from '@/lib/supabase'

const router = useRouter()
const authStore = useAuthStore()

const email = ref('')
const password = ref('')
const loading = ref(false)
const errorMessage = ref('')

const handleLogin = async () => {
  loading.value = true
  errorMessage.value = ''

  const { error } = await supabase.auth.signInWithPassword({
    email: email.value,
    password: password.value
  })

  if (error) {
    errorMessage.value = error.message
    loading.value = false
    return
  }

  await authStore.fetchUser()
  loading.value = false
  void router.push(authStore.isAdmin ? '/admin' : '/shop')
}
</script>
