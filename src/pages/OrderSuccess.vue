<template>
  <section class="min-h-screen bg-gradient-to-b from-rose-50 via-white to-emerald-50 px-4 pt-24 pb-10 sm:px-6 lg:px-8">
    <div class="mx-auto max-w-4xl">
      <div class="rounded-[2rem] bg-white/90 p-8 text-center shadow-sm ring-1 ring-rose-100 sm:p-10">
        <!-- Download celebration.json from LottieFiles and place it at public/lottie/celebration.json -->
        <LottieAnimation
          class="mx-auto h-56 w-full max-w-sm pointer-events-none"
          src="/lottie/celebration.json"
          autoplay
          @complete="revealSuccessContent"
          @error="revealSuccessContent"
        />

        <div
          ref="messageBlockRef"
          class="space-y-4"
        >
          <p class="text-sm font-semibold uppercase tracking-[0.3em] text-rose-400">Order Confirmed</p>
          <h1 class="heading-serif text-4xl font-semibold tracking-tight text-rose-950 sm:text-5xl">
            Your order has been placed!
          </h1>
          <p class="mx-auto max-w-2xl text-base leading-7 text-stone-600">
            Your flowers are now in our queue and we’ll begin preparing them with care.
          </p>
        </div>
      </div>

      <div
        ref="summaryBlockRef"
        class="mt-8 rounded-[2rem] bg-white/90 p-6 shadow-sm ring-1 ring-rose-100 sm:p-8"
      >
        <div class="flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between">
          <div>
            <h2 class="text-2xl font-semibold text-rose-950">What You Ordered</h2>
            <p class="mt-1 text-sm text-stone-500">
              Order #{{ orderSummary?.orderId ?? 'N/A' }}
            </p>
          </div>

          <p
            v-if="orderSummary?.deliveryDate"
            class="text-sm font-medium text-emerald-700"
          >
            Delivery date: {{ orderSummary.deliveryDate }}
          </p>
        </div>

        <div
          v-if="orderSummary && orderSummary.items.length > 0"
          class="mt-6 space-y-4"
        >
          <article
            v-for="item in orderSummary.items"
            :key="item.id"
            class="flex items-center gap-4 rounded-3xl bg-rose-50 p-4"
          >
            <div class="h-18 w-18 shrink-0 overflow-hidden rounded-[1.25rem] bg-white">
              <img
                :src="item.image_url || fallbackImage"
                :alt="item.name"
                class="h-full w-full object-cover"
              />
            </div>

            <div class="min-w-0 flex-1 text-left">
              <h3 class="truncate text-base font-semibold text-rose-950">{{ item.name }}</h3>
              <p class="mt-1 text-sm text-stone-500">Qty: {{ item.quantity }}</p>
            </div>

            <p class="text-sm font-semibold text-emerald-700">
              ${{ (item.price * item.quantity).toFixed(2) }}
            </p>
          </article>

          <div class="flex items-center justify-between border-t border-rose-100 pt-6 text-lg font-semibold text-rose-950">
            <span>Total</span>
            <span>${{ orderSummary.totalPrice.toFixed(2) }}</span>
          </div>
        </div>

        <div
          v-else
          class="mt-6 rounded-3xl bg-rose-50 px-5 py-6 text-center"
        >
          <p class="text-sm text-stone-600">We couldn’t load the latest order summary, but your order was submitted.</p>
        </div>

        <div
          ref="actionsRef"
          class="mt-8 grid gap-3 sm:grid-cols-3"
        >
          <RouterLink
            v-if="orderSummary?.orderId"
            :to="`/orders/${orderSummary.orderId}/track`"
            class="w-full rounded-full border border-rose-200 bg-white px-6 py-4 text-center text-base font-semibold text-rose-950 transition hover:bg-rose-50"
          >
            Track Order
          </RouterLink>
          <button
            class="w-full rounded-full bg-rose-300 px-6 py-4 text-base font-semibold text-rose-950 transition hover:bg-rose-400"
            type="button"
            @click="goToShop"
          >
            Back to Shop
          </button>
          <button
            class="w-full rounded-full border border-emerald-200 bg-emerald-50 px-6 py-4 text-base font-semibold text-emerald-800 transition hover:bg-emerald-100"
            type="button"
            @click="goToBuilder"
          >
            Build Another Bouquet
          </button>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { nextTick, onMounted, ref } from 'vue'
import gsap from 'gsap'
import { useRouter } from 'vue-router'
import { prefersReducedMotion } from '@/animations/motion'
import type { CartItemId } from '@/stores/cart'

interface LastOrderSummaryItem {
  id: CartItemId
  name: string
  image_url: string
  price: number
  quantity: number
}

interface LastOrderSummary {
  orderId: number
  items: LastOrderSummaryItem[]
  totalPrice: number
  deliveryDate: string
}

const fallbackImage =
  'https://images.unsplash.com/photo-1525310072745-f49212b5ac6d?auto=format&fit=crop&w=900&q=80'

const LAST_ORDER_KEY = 'flower-shop:last-order'

const router = useRouter()
const orderSummary = ref<LastOrderSummary | null>(null)
const messageBlockRef = ref<HTMLElement | null>(null)
const summaryBlockRef = ref<HTMLElement | null>(null)
const actionsRef = ref<HTMLElement | null>(null)
const hasRevealed = ref(false)

const goToShop = () => {
  void router.push('/shop')
}

const goToBuilder = () => {
  void router.push('/bouquet-builder')
}

const revealSuccessContent = () => {
  if (hasRevealed.value) {
    return
  }

  hasRevealed.value = true

  const elements = [messageBlockRef.value, summaryBlockRef.value, actionsRef.value].filter(
    (element): element is HTMLElement => element instanceof HTMLElement
  )

  if (elements.length === 0) {
    return
  }

  if (prefersReducedMotion()) {
    gsap.set(elements, {
      clearProps: 'all'
    })
    return
  }

  gsap.to(elements, {
    opacity: 1,
    y: 0,
    duration: 0.7,
    ease: 'power2.out',
    stagger: 0.14
  })
}

onMounted(() => {
  const savedOrder = sessionStorage.getItem(LAST_ORDER_KEY)

  if (!savedOrder) {
    return
  }

  try {
    orderSummary.value = JSON.parse(savedOrder) as LastOrderSummary
  } catch {
    orderSummary.value = null
  }

  void nextTick(() => {
    const elements = [messageBlockRef.value, summaryBlockRef.value, actionsRef.value].filter(
      (element): element is HTMLElement => element instanceof HTMLElement
    )

    if (prefersReducedMotion()) {
      revealSuccessContent()
      return
    }

    gsap.set(elements, {
      opacity: 0,
      y: 24
    })
  })
})
</script>
