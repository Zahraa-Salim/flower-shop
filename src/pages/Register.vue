<template>
  <section class="flex min-h-screen items-center justify-center bg-gradient-to-b from-rose-50 via-white to-emerald-50 px-4 py-10 sm:px-6 lg:px-8">
    <div class="mx-auto w-full max-w-md">
      <div class="rounded-[2rem] bg-white/90 p-8 shadow-sm ring-1 ring-rose-100">
        <div class="space-y-3 text-center">
          <p class="text-sm font-semibold uppercase tracking-[0.3em] text-rose-400">Join The Garden</p>
          <h1 class="heading-serif text-4xl font-semibold tracking-tight text-rose-950">Register</h1>
          <p class="text-sm leading-6 text-stone-500">
            Create your account to save your details and breeze through checkout.
          </p>
        </div>

        <form
          v-if="!successMessage"
          class="mt-8 space-y-5"
          @submit.prevent="handleRegister"
        >
          <label class="block space-y-2">
            <span class="text-sm font-medium text-rose-900">Full Name</span>
            <input
              v-model="fullName"
              class="w-full rounded-2xl border border-rose-200 bg-rose-50 px-4 py-3 text-rose-950 outline-none transition placeholder:text-stone-400 focus:border-rose-300 focus:bg-white"
              type="text"
              placeholder="Your full name"
              required
            />
          </label>

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
              placeholder="Create a secure password"
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
            {{ loading ? 'Creating account...' : 'Register' }}
          </button>
        </form>

        <div
          v-else
          class="mt-8 rounded-[2rem] bg-emerald-50 px-5 py-6 text-center"
        >
          <h2 class="text-2xl font-semibold text-emerald-900">Almost there</h2>
          <p class="mt-2 text-sm leading-6 text-emerald-800">
            {{ successMessage }}
          </p>
        </div>

        <p class="mt-6 text-center text-sm text-stone-500">
          Already have an account?
          <RouterLink
            class="font-semibold text-rose-700 transition hover:text-rose-900"
            to="/login"
          >
            Login
          </RouterLink>
        </p>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '@/lib/supabase'
import { useAuthStore } from '@/stores/auth'

const router = useRouter()
const authStore = useAuthStore()

const fullName = ref('')
const email = ref('')
const password = ref('')
const loading = ref(false)
const errorMessage = ref('')
const successMessage = ref('')

const handleRegister = async () => {
  loading.value = true
  errorMessage.value = ''

  const { error } = await supabase.auth.signUp({
    email: email.value,
    password: password.value,
    options: {
      data: {
        full_name: fullName.value
      }
    }
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
