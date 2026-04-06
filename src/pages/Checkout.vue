<template>
  <section class="min-h-screen bg-gradient-to-b from-rose-50 via-white to-emerald-50 px-4 pt-24 pb-10 sm:px-6 lg:px-8">
    <div class="mx-auto max-w-6xl">
      <div class="rounded-[2rem] bg-white/85 p-8 shadow-sm ring-1 ring-rose-100">
        <div class="flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
          <div class="space-y-3">
            <p class="text-sm font-semibold uppercase tracking-[0.3em] text-rose-400">Final Touches</p>
            <h1 class="heading-serif text-4xl font-semibold tracking-tight text-rose-950 sm:text-5xl">Checkout</h1>
            <p class="max-w-2xl text-base leading-7 text-stone-600">
              Add your delivery details and a sweet note, then we’ll prepare your bouquet for its next stop.
            </p>
          </div>

          <div class="rounded-3xl bg-emerald-50 px-5 py-4">
            <p class="text-sm text-emerald-700">Order total</p>
            <p class="text-3xl font-semibold text-emerald-900">${{ formattedTotalPrice }}</p>
          </div>
        </div>
      </div>

      <div
        v-if="items.length === 0"
        class="mt-8 rounded-[2rem] bg-white/85 p-10 text-center shadow-sm ring-1 ring-rose-100"
      >
        <h2 class="text-3xl font-semibold text-rose-950">Your cart is empty</h2>
        <p class="mt-3 text-base text-stone-600">
          Add a few flowers first, then come back here to schedule delivery.
        </p>
        <button
          class="mt-6 rounded-full bg-rose-300 px-6 py-3 text-sm font-semibold text-rose-950 transition hover:bg-rose-400"
          type="button"
          @click="goToShop"
        >
          Go to Shop
        </button>
      </div>

      <div
        v-else
        class="mt-8 grid gap-8 lg:grid-cols-[1.1fr_0.9fr]"
      >
        <form
          class="rounded-[2rem] bg-white/90 p-6 shadow-sm ring-1 ring-rose-100 sm:p-8"
          @submit.prevent="placeOrder"
        >
          <div class="space-y-6">
            <label class="block space-y-2">
              <span class="text-sm font-medium text-rose-900">Delivery Address</span>
              <textarea
                v-model="deliveryAddress"
                class="min-h-32 w-full rounded-2xl border border-rose-200 bg-rose-50 px-4 py-3 text-rose-950 outline-none transition placeholder:text-stone-400 focus:border-rose-300 focus:bg-white"
                placeholder="Enter the full delivery address"
                required
              />
            </label>

            <label class="block space-y-2">
              <span class="text-sm font-medium text-rose-900">Delivery Date</span>
              <input
                v-model="deliveryDate"
                class="w-full rounded-2xl border border-rose-200 bg-rose-50 px-4 py-3 text-rose-950 outline-none transition focus:border-rose-300 focus:bg-white"
                type="date"
                :min="today"
                required
              />
            </label>

            <label class="block space-y-2">
              <span class="text-sm font-medium text-rose-900">Message Card</span>
              <textarea
                v-model="messageCard"
                class="min-h-28 w-full rounded-2xl border border-rose-200 bg-rose-50 px-4 py-3 text-rose-950 outline-none transition placeholder:text-stone-400 focus:border-rose-300 focus:bg-white"
                placeholder="Add a sweet note for the recipient (optional)"
              />
            </label>

            <label class="flex items-center gap-3 rounded-2xl bg-rose-50 px-4 py-4 text-sm font-medium text-rose-900">
              <input
                v-model="isSurprise"
                class="h-4 w-4 rounded border-rose-300 text-rose-500 focus:ring-rose-300"
                type="checkbox"
              />
              Make this order a surprise
            </label>

            <!-- Gift Scheduling -->
            <div class="rounded-2xl border border-rose-100 bg-rose-50/50 p-4 space-y-3">
              <label class="flex items-center gap-3 text-sm font-medium text-rose-900">
                <input
                  v-model="isRecurring"
                  class="h-4 w-4 rounded border-rose-300 text-rose-500 focus:ring-rose-300"
                  type="checkbox"
                />
                Schedule recurring delivery
              </label>
              <div v-if="isRecurring" class="ml-7 space-y-2">
                <p class="text-xs text-stone-500">Automatically reorder this bouquet on a schedule</p>
                <select
                  v-model="recurrenceInterval"
                  class="w-full rounded-xl border border-rose-200 bg-white px-3 py-2.5 text-sm text-rose-950 outline-none focus:border-rose-300"
                >
                  <option value="weekly">Every week</option>
                  <option value="biweekly">Every 2 weeks</option>
                  <option value="monthly">Every month</option>
                </select>
              </div>
            </div>

            <p
              v-if="errorMessage"
              class="rounded-2xl bg-rose-50 px-4 py-3 text-sm font-medium text-rose-700"
            >
              {{ errorMessage }}
            </p>

            <button
              class="w-full rounded-full bg-rose-300 px-6 py-4 text-base font-semibold text-rose-950 transition hover:bg-rose-400 disabled:cursor-not-allowed disabled:bg-rose-100 disabled:text-stone-400"
              type="submit"
              :disabled="loading"
            >
              {{ loading ? 'Placing Order...' : 'Place Order' }}
            </button>
          </div>
        </form>

        <aside class="rounded-[2rem] bg-white/90 p-6 shadow-sm ring-1 ring-rose-100">
          <h2 class="text-2xl font-semibold text-rose-950">Order Summary</h2>

          <div class="mt-6 space-y-4">
            <article
              v-for="item in items"
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

              <div class="min-w-0 flex-1">
                <h3 class="truncate text-base font-semibold text-rose-950">{{ item.name }}</h3>
                <p class="mt-1 text-sm text-stone-500">Qty: {{ item.quantity }}</p>
              </div>

              <p class="text-sm font-semibold text-emerald-700">
                ${{ (item.price * item.quantity).toFixed(2) }}
              </p>
            </article>
          </div>

          <div class="mt-8 space-y-3 border-t border-rose-100 pt-6">
            <div class="flex items-center justify-between text-sm text-stone-500">
              <span>Total items</span>
              <span class="font-medium text-stone-700">{{ totalItems }}</span>
            </div>
            <div class="flex items-center justify-between text-lg font-semibold text-rose-950">
              <span>Total price</span>
              <span>${{ formattedTotalPrice }}</span>
            </div>
          </div>
        </aside>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import { storeToRefs } from 'pinia'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useCartStore } from '@/stores/cart'
import type { CartItemId } from '@/stores/cart'
import { supabase } from '@/lib/supabase'

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
const authStore = useAuthStore()
const cartStore = useCartStore()
const { items, totalItems, totalPrice } = storeToRefs(cartStore)
const { user } = storeToRefs(authStore)

const deliveryAddress = ref('')
const deliveryDate = ref('')
const messageCard = ref('')
const isSurprise = ref(false)
const isRecurring = ref(false)
const recurrenceInterval = ref('monthly')
const loading = ref(false)
const errorMessage = ref('')

const today = new Date().toISOString().split('T')[0]
const formattedTotalPrice = computed(() => totalPrice.value.toFixed(2))

const goToShop = () => {
  void router.push('/shop')
}

const placeOrder = async () => {
  if (!user.value) {
    errorMessage.value = 'Please log in again before placing your order.'
    return
  }

  if (items.value.length === 0) {
    errorMessage.value = 'Your cart is empty.'
    return
  }

  const now = new Date().toISOString().split('T')[0]
  if (!deliveryDate.value || deliveryDate.value < now) {
    errorMessage.value = 'Please choose a delivery date today or in the future.'
    return
  }

  loading.value = true
  errorMessage.value = ''

  const { data: order, error: orderError } = await supabase
    .from('orders')
    .insert({
      user_id: user.value.id,
      status: 'pending',
      total_price: totalPrice.value,
      delivery_date: deliveryDate.value,
      delivery_address: deliveryAddress.value,
      message_card: messageCard.value,
      is_surprise: isSurprise.value,
      is_recurring: isRecurring.value,
      recurrence_interval: isRecurring.value ? recurrenceInterval.value : null
    })
    .select('id')
    .single()

  if (orderError || !order) {
    errorMessage.value = orderError?.message || 'Unable to create your order right now.'
    loading.value = false
    return
  }

  const orderItems = items.value.map((item) => ({
    order_id: order.id,
    product_id: item.id,
    quantity: item.quantity,
    unit_price: item.price
  }))

  const { error: orderItemsError } = await supabase.from('order_items').insert(orderItems)

  if (orderItemsError) {
    errorMessage.value = orderItemsError.message
    loading.value = false
    return
  }

  const lastOrderSummary: LastOrderSummary = {
    orderId: order.id,
    items: items.value.map((item) => ({ ...item })),
    totalPrice: totalPrice.value,
    deliveryDate: deliveryDate.value
  }

  sessionStorage.setItem(LAST_ORDER_KEY, JSON.stringify(lastOrderSummary))
  cartStore.clearCart()
  loading.value = false
  void router.push('/order-success')
}
</script>
