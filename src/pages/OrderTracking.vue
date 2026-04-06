<template>
  <section class="min-h-screen bg-gradient-to-b from-rose-50 via-white to-emerald-50 px-4 py-10 sm:px-6 lg:px-8">
    <div class="mx-auto max-w-2xl pt-20">
      <button
        class="inline-flex items-center rounded-full border border-rose-200 bg-white px-4 py-2 text-sm font-medium text-rose-900 shadow-sm transition hover:bg-rose-50"
        type="button"
        @click="$router.back()"
      >
        ← Back
      </button>

      <div class="mt-8 rounded-[2rem] bg-white/85 p-8 shadow-sm ring-1 ring-rose-100">
        <p class="text-sm font-semibold uppercase tracking-[0.3em] text-rose-400">Order Tracking</p>
        <h1 class="heading-serif mt-2 text-3xl font-semibold text-rose-950">
          Order #{{ orderId }}
        </h1>

        <div v-if="loading" class="mt-8 text-center text-stone-500">Loading order status…</div>
        <div v-else-if="error" class="mt-8 text-center text-rose-600">{{ error }}</div>

        <div v-else class="mt-10">
          <!-- Visual stepper -->
          <div class="relative">
            <div class="absolute left-5 top-0 h-full w-0.5 bg-rose-100" />

            <div
              v-for="(step, i) in steps"
              :key="step.key"
              class="relative mb-8 flex items-start gap-4 last:mb-0"
            >
              <div
                class="relative z-10 flex h-10 w-10 flex-shrink-0 items-center justify-content-center rounded-full border-2 text-center text-sm font-bold transition-all duration-500"
                :class="stepClasses(i)"
              >
                <span class="mx-auto">{{ stepIcon(i) }}</span>
              </div>
              <div>
                <p
                  class="font-semibold transition-colors duration-300"
                  :class="i <= currentStepIndex ? 'text-rose-950' : 'text-stone-400'"
                >
                  {{ step.label }}
                </p>
                <p class="mt-1 text-sm text-stone-500">{{ step.description }}</p>
              </div>
            </div>
          </div>

          <!-- Live badge -->
          <div class="mt-6 flex items-center gap-2 rounded-full bg-emerald-50 px-4 py-2 text-sm font-medium text-emerald-700">
            <span class="relative flex h-2.5 w-2.5">
              <span class="absolute inline-flex h-full w-full animate-ping rounded-full bg-emerald-400 opacity-75" />
              <span class="relative inline-flex h-2.5 w-2.5 rounded-full bg-emerald-500" />
            </span>
            Live updates enabled
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { computed, onMounted, onUnmounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import { supabase } from '@/lib/supabase'
import type { RealtimeChannel } from '@supabase/supabase-js'

const route = useRoute()
const orderId = computed(() => route.params.id as string)

const loading = ref(true)
const error = ref('')
const orderStatus = ref('pending')

let channel: RealtimeChannel | null = null

const steps = [
  { key: 'pending',    label: 'Order Placed',      description: 'Your order has been received.' },
  { key: 'confirmed',  label: 'Confirmed',          description: 'The florist has confirmed your order.' },
  { key: 'preparing',  label: 'Preparing Bouquet',  description: 'Your flowers are being arranged with care.' },
  { key: 'shipped',    label: 'Out for Delivery',   description: 'Your bouquet is on its way!' },
  { key: 'delivered',  label: 'Delivered',           description: 'Enjoy your beautiful flowers!' },
]

const currentStepIndex = computed(() => {
  const idx = steps.findIndex(s => s.key === orderStatus.value)
  return idx >= 0 ? idx : 0
})

const stepClasses = (i: number) => {
  if (i < currentStepIndex.value) return 'border-emerald-500 bg-emerald-500 text-white'
  if (i === currentStepIndex.value) return 'border-rose-400 bg-rose-400 text-white scale-110'
  return 'border-stone-200 bg-white text-stone-400'
}

const stepIcon = (i: number) => {
  if (i < currentStepIndex.value) return '✓'
  return i + 1
}

async function fetchOrder() {
  const { data, error: err } = await supabase
    .from('orders')
    .select('status')
    .eq('id', orderId.value)
    .single()

  if (err || !data) {
    error.value = 'Order not found.'
  } else {
    orderStatus.value = data.status
  }
  loading.value = false
}

function subscribeToUpdates() {
  channel = supabase
    .channel(`order-${orderId.value}`)
    .on(
      'postgres_changes',
      {
        event: 'UPDATE',
        schema: 'public',
        table: 'orders',
        filter: `id=eq.${orderId.value}`
      },
      (payload) => {
        if (payload.new && 'status' in payload.new) {
          orderStatus.value = payload.new.status as string
        }
      }
    )
    .subscribe()
}

onMounted(() => {
  fetchOrder()
  subscribeToUpdates()
})

onUnmounted(() => {
  if (channel) {
    supabase.removeChannel(channel)
  }
})
</script>
