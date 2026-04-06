<!-- Reminders.vue — Personal occasion reminders manager -->
<template>
  <section class="min-h-screen bg-gradient-to-b from-rose-50 via-white to-emerald-50 px-4 pt-24 pb-10 sm:px-6 lg:px-8">
    <div class="mx-auto max-w-6xl space-y-8">
      <div ref="headerRef" class="rounded-[2rem] bg-white/85 p-8 shadow-sm ring-1 ring-rose-100">
        <div class="flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
          <div class="space-y-3">
            <p class="text-sm font-semibold uppercase tracking-[0.3em] text-rose-400">Thoughtful Planning</p>
            <h1 class="heading-serif text-4xl font-semibold tracking-tight text-rose-950 sm:text-5xl">Reminders</h1>
            <p class="max-w-2xl text-base leading-7 text-stone-600">
              Save important flower-giving moments so birthdays, anniversaries, and celebrations never sneak up on you.
            </p>
          </div>

          <div class="rounded-3xl bg-emerald-50 px-5 py-4">
            <p class="text-sm text-emerald-700">Saved reminders</p>
            <p class="text-3xl font-semibold text-emerald-900">{{ reminders.length }}</p>
          </div>
        </div>
      </div>

      <div class="grid gap-8 lg:grid-cols-[0.95fr_1.05fr]">
        <form
          class="rounded-[2rem] bg-white/90 p-6 shadow-sm ring-1 ring-rose-100 sm:p-8"
          @submit.prevent="createReminder"
        >
          <h2 class="text-2xl font-semibold text-rose-950">Add a Reminder</h2>

          <div class="mt-6 space-y-5">
            <label class="block space-y-2">
              <span class="text-sm font-medium text-rose-900">Occasion Name</span>
              <input
                v-model="occasionName"
                class="w-full rounded-2xl border border-rose-200 bg-rose-50 px-4 py-3 text-rose-950 outline-none transition placeholder:text-stone-400 focus:border-rose-300 focus:bg-white"
                type="text"
                placeholder="Mom's birthday"
                required
              />
            </label>

            <label class="block space-y-2">
              <span class="text-sm font-medium text-rose-900">Reminder Date</span>
              <input
                v-model="reminderDate"
                class="w-full rounded-2xl border border-rose-200 bg-rose-50 px-4 py-3 text-rose-950 outline-none transition focus:border-rose-300 focus:bg-white"
                type="date"
                required
              />
            </label>

            <label class="block space-y-2">
              <span class="text-sm font-medium text-rose-900">Message</span>
              <textarea
                v-model="message"
                class="min-h-28 w-full rounded-2xl border border-rose-200 bg-rose-50 px-4 py-3 text-rose-950 outline-none transition placeholder:text-stone-400 focus:border-rose-300 focus:bg-white"
                placeholder="Optional note for this occasion"
              />
            </label>

            <p
              v-if="formErrorMessage"
              class="rounded-2xl bg-rose-50 px-4 py-3 text-sm font-medium text-rose-700"
            >
              {{ formErrorMessage }}
            </p>

            <button
              class="w-full rounded-full bg-rose-300 px-6 py-4 text-base font-semibold text-rose-950 transition hover:bg-rose-400 disabled:cursor-not-allowed disabled:bg-rose-100 disabled:text-stone-400"
              type="submit"
              :disabled="submitting"
            >
              {{ submitting ? 'Saving Reminder...' : 'Save Reminder' }}
            </button>
          </div>
        </form>

        <section class="rounded-[2rem] bg-white/90 p-6 shadow-sm ring-1 ring-rose-100 sm:p-8">
          <div class="flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between">
            <div>
              <h2 class="text-2xl font-semibold text-rose-950">Your Reminder List</h2>
              <p class="mt-1 text-sm text-stone-500">Keep your future flower moments organized in one place.</p>
            </div>
          </div>

          <div
            v-if="loading"
            class="mt-8 flex items-center justify-center py-12"
          >
            <div class="h-10 w-10 animate-spin rounded-full border-4 border-rose-100 border-t-rose-400"></div>
          </div>

          <div
            v-else-if="reminders.length === 0"
            class="mt-8 rounded-[2rem] bg-rose-50 px-5 py-8 text-center"
          >
            <p class="text-base font-medium text-rose-900">No reminders yet</p>
            <p class="mt-2 text-sm text-stone-500">Add your first occasion and we’ll help you stay one step ahead.</p>
          </div>

          <div
            v-else
            class="mt-8 space-y-4"
          >
            <article
              v-for="reminder in reminders"
              :key="reminder.id"
              class="rounded-[1.75rem] bg-rose-50 p-5"
            >
              <div class="flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between">
                <div>
                  <h3 class="text-xl font-semibold text-rose-950">{{ reminder.occasion_name }}</h3>
                  <p class="mt-2 text-sm font-medium text-emerald-700">
                    {{ formatReminderDate(reminder.reminder_date) }}
                  </p>
                  <p
                    v-if="reminder.message"
                    class="mt-3 text-sm leading-6 text-stone-600"
                  >
                    {{ reminder.message }}
                  </p>
                </div>

                <button
                  class="self-start rounded-full border border-rose-200 px-4 py-2 text-sm font-medium text-rose-700 transition hover:bg-white"
                  type="button"
                  @click="deleteReminder(reminder.id)"
                >
                  Delete
                </button>
              </div>
            </article>
          </div>
        </section>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { storeToRefs } from 'pinia'
import { useRouter } from 'vue-router'
import { supabase } from '@/lib/supabase'
import { useAuthStore } from '@/stores/auth'
import gsap from 'gsap'
import { prefersReducedMotion } from '@/animations/motion'

interface Reminder {
  id: number
  user_id: string
  occasion_name: string
  reminder_date: string
  message: string | null
}

const router = useRouter()
const authStore = useAuthStore()
const { user } = storeToRefs(authStore)

const headerRef = ref<HTMLElement | null>(null)
const reminders = ref<Reminder[]>([])
const loading = ref(true)
const submitting = ref(false)
const occasionName = ref('')
const reminderDate = ref('')
const message = ref('')
const formErrorMessage = ref('')

const formatReminderDate = (value: string) =>
  new Date(value).toLocaleDateString(undefined, {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })

const fetchReminders = async () => {
  if (!user.value) {
    void router.push('/login')
    return
  }

  loading.value = true

  const { data } = await supabase.from('reminders').select('*').eq('user_id', user.value.id)

  reminders.value = (data as Reminder[] | null) ?? []
  loading.value = false
}

const createReminder = async () => {
  if (!user.value) {
    void router.push('/login')
    return
  }

  submitting.value = true
  formErrorMessage.value = ''

  const { error } = await supabase.from('reminders').insert({
    user_id: user.value.id,
    occasion_name: occasionName.value,
    reminder_date: reminderDate.value,
    message: message.value
  })

  if (error) {
    formErrorMessage.value = error.message
    submitting.value = false
    return
  }

  occasionName.value = ''
  reminderDate.value = ''
  message.value = ''
  await fetchReminders()
  submitting.value = false
}

const deleteReminder = async (id: number) => {
  const { error } = await supabase.from('reminders').delete().eq('id', id)

  if (error) {
    formErrorMessage.value = error.message
    return
  }

  reminders.value = reminders.value.filter((reminder) => reminder.id !== id)
}

onMounted(async () => {
  if (headerRef.value && !prefersReducedMotion()) {
    gsap.from(headerRef.value, { y: 30, autoAlpha: 0, duration: 0.6, ease: 'power2.out', immediateRender: false })
  }

  await authStore.fetchUser()

  if (!user.value) {
    void router.push('/login')
    return
  }

  await fetchReminders()
})
</script>
