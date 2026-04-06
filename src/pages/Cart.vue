<!-- Cart.vue — Shopping cart with glassmorphic cards, animated totals, and swipe-to-delete -->
<template>
  <section ref="sectionRef" class="min-h-screen bg-gradient-to-b from-rose-50 via-white to-emerald-50 px-4 pt-24 pb-10 sm:px-6 lg:px-8">
    <div class="mx-auto max-w-6xl">
      <!-- Header -->
      <div ref="headerRef" class="rounded-[2rem] bg-white/85 p-8 shadow-sm ring-1 ring-rose-100">
        <div class="flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
          <div class="space-y-3">
            <p class="text-sm font-semibold uppercase tracking-[0.3em] text-rose-400">Your Basket</p>
            <h1 class="heading-serif text-4xl font-semibold tracking-tight text-rose-950 sm:text-5xl">Cart</h1>
            <p class="max-w-2xl text-base leading-7 text-stone-600">
              Keep track of your chosen bouquets and adjust quantities before heading to checkout.
            </p>
          </div>

          <div ref="totalBadgeRef" class="cart-total-badge">
            <p class="text-sm text-emerald-700">Cart total</p>
            <p class="text-3xl font-semibold text-emerald-900">${{ displayedTotalFormatted }}</p>
          </div>
        </div>
      </div>

      <!-- Empty state -->
      <div
        v-if="items.length === 0"
        class="mt-8 rounded-[2rem] bg-white/85 p-10 text-center shadow-sm ring-1 ring-rose-100"
      >
        <div ref="emptyVaseRef" class="cart-empty__vase">&#10047;</div>
        <h2 ref="emptyTextRef" class="text-3xl font-semibold text-rose-950">Your cart is feeling a little empty</h2>
        <p class="mt-3 text-base text-stone-600">
          Browse the shop and add a few blooms to start building your perfect bouquet.
        </p>
        <button
          ref="emptyCtaRef"
          class="cart-cta cart-cta--secondary mt-6 inline-block"
          type="button"
          @click="continueShopping"
        >
          Go to Shop
        </button>
      </div>

      <!-- Cart items + summary -->
      <div
        v-else
        class="mt-8 grid gap-8 lg:grid-cols-[1.4fr_0.6fr]"
      >
        <!-- Items list -->
        <div class="space-y-4">
          <article
            v-for="item in items"
            :key="item.id"
            :ref="(el) => setItemRef(item.id, el)"
            class="cart-item"
            @touchstart.passive="onTouchStart($event, item.id)"
            @touchmove.passive="onTouchMove($event, item.id)"
            @touchend.passive="onTouchEnd($event, item.id)"
          >
            <!-- Swipe delete background -->
            <div class="cart-item__delete-bg">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2">
                <polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/>
              </svg>
            </div>

            <div class="cart-item__content">
              <!-- Thumbnail -->
              <div class="cart-item__thumb">
                <img
                  :src="item.image_url || fallbackImage"
                  :alt="item.name"
                  class="h-full w-full object-cover"
                />
              </div>

              <!-- Details -->
              <div class="flex-1 space-y-3">
                <div class="flex flex-col gap-3 sm:flex-row sm:items-start sm:justify-between">
                  <div>
                    <h2 class="text-xl font-semibold text-rose-950 sm:text-2xl">{{ item.name }}</h2>
                    <p class="mt-1 text-base font-medium text-emerald-700">${{ item.price.toFixed(2) }}</p>
                  </div>

                  <button
                    class="cart-item__remove"
                    type="button"
                    @click="removeItem(item.id)"
                    aria-label="Remove item"
                  >
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
                    </svg>
                  </button>
                </div>

                <div class="flex flex-wrap items-center justify-between gap-4">
                  <!-- Quantity stepper -->
                  <div class="cart-item__stepper">
                    <button
                      class="cart-item__step-btn"
                      type="button"
                      @mousedown="onStepPress"
                      @mouseup="onStepRelease"
                      @mouseleave="onStepRelease"
                      @click="onDecrease(item.id, item.quantity)"
                    >
                      &minus;
                    </button>
                    <span
                      :ref="(el) => setQtyRef(item.id, el)"
                      class="cart-item__qty"
                    >
                      {{ item.quantity }}
                    </span>
                    <button
                      class="cart-item__step-btn"
                      type="button"
                      @mousedown="onStepPress"
                      @mouseup="onStepRelease"
                      @mouseleave="onStepRelease"
                      @click="onIncrease(item.id, item.quantity)"
                    >
                      &plus;
                    </button>
                  </div>

                  <p class="cart-item__subtotal">
                    Subtotal: <span :ref="(el) => setSubtotalRef(item.id, el)">${{ (item.price * item.quantity).toFixed(2) }}</span>
                  </p>
                </div>
              </div>
            </div>
          </article>
        </div>

        <!-- Order summary sidebar -->
        <aside ref="summaryRef" class="cart-summary lg:sticky lg:top-28">
          <h2 class="text-2xl font-semibold text-rose-950">Order Summary</h2>

          <div class="mt-6 space-y-4">
            <div class="flex items-center justify-between text-sm text-stone-500">
              <span>Total items</span>
              <span class="font-medium text-stone-700">{{ totalItems }}</span>
            </div>
            <div class="flex items-center justify-between text-lg font-semibold text-rose-950">
              <span>Total price</span>
              <span>${{ displayedTotalFormatted }}</span>
            </div>
          </div>

          <!-- Shipping progress bar -->
          <div class="mt-6">
            <div class="flex items-center justify-between text-xs">
              <span ref="shippingTextRef" class="text-stone-500">
                {{ shippingMessage }}
              </span>
              <span class="font-medium" :class="shippingMet ? 'text-emerald-600' : 'text-stone-400'">
                ${{ FREE_SHIPPING_THRESHOLD }}
              </span>
            </div>
            <div class="cart-shipping-track mt-2">
              <div ref="shippingBarRef" class="cart-shipping-fill" :class="{ 'cart-shipping-fill--met': shippingMet }"></div>
            </div>
          </div>

          <div class="mt-8 space-y-3">
            <button
              class="w-full rounded-full border border-emerald-200 bg-emerald-50 px-5 py-3 text-sm font-semibold text-emerald-800 transition hover:bg-emerald-100"
              type="button"
              @click="continueShopping"
            >
              Continue Shopping
            </button>
            <button
              ref="checkoutBtnRef"
              class="cart-checkout-btn w-full"
              type="button"
              @click="proceedToCheckout"
            >
              Proceed to Checkout
            </button>
          </div>
        </aside>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { computed, nextTick, onMounted, onUnmounted, ref, watch } from 'vue'
import type { ComponentPublicInstance } from 'vue'
import { storeToRefs } from 'pinia'
import gsap from 'gsap'
import { useRouter } from 'vue-router'
import { prefersReducedMotion } from '@/animations/motion'
import { useCartStore } from '@/stores/cart'
import type { CartItemId } from '@/stores/cart'
import { useMagneticButton } from '@/composables/useMagneticButton'

const FREE_SHIPPING_THRESHOLD = 75
const reduceMotion = prefersReducedMotion()

const fallbackImage =
  'https://images.unsplash.com/photo-1525310072745-f49212b5ac6d?auto=format&fit=crop&w=900&q=80'

const router = useRouter()
const cartStore = useCartStore()
const { items, totalItems, totalPrice } = storeToRefs(cartStore)

// Refs
const sectionRef = ref<HTMLElement | null>(null)
const headerRef = ref<HTMLElement | null>(null)
const totalBadgeRef = ref<HTMLElement | null>(null)
const summaryRef = ref<HTMLElement | null>(null)
const checkoutBtnRef = ref<HTMLElement | null>(null)
const shippingBarRef = ref<HTMLElement | null>(null)
const shippingTextRef = ref<HTMLElement | null>(null)
const emptyVaseRef = ref<HTMLElement | null>(null)
const emptyTextRef = ref<HTMLElement | null>(null)
const emptyCtaRef = ref<HTMLElement | null>(null)

const itemRefs = new Map<string, HTMLElement>()
const qtyRefs = new Map<string, HTMLElement>()
const subtotalRefs = new Map<string, HTMLElement>()
const removingItems = new Set<string>()

// Touch state for swipe
const touchState = ref<{ startX: number; itemId: CartItemId | null }>({ startX: 0, itemId: null })

// Animated price counter
const displayedTotal = ref(totalPrice.value)
const displayedTotalFormatted = computed(() => displayedTotal.value.toFixed(2))

// Shipping
const shippingMet = computed(() => totalPrice.value >= FREE_SHIPPING_THRESHOLD)
const shippingMessage = computed(() =>
  shippingMet.value
    ? 'Free shipping unlocked!'
    : `$${(FREE_SHIPPING_THRESHOLD - totalPrice.value).toFixed(0)} more for free shipping`
)

// Magnetic checkout button
useMagneticButton(checkoutBtnRef)

// Ref setters
const setItemRef = (id: CartItemId, el: Element | ComponentPublicInstance | null) => {
  const key = String(id)
  if (el instanceof HTMLElement) itemRefs.set(key, el)
  else itemRefs.delete(key)
}
const setQtyRef = (id: CartItemId, el: Element | ComponentPublicInstance | null) => {
  const key = String(id)
  if (el instanceof HTMLElement) qtyRefs.set(key, el)
  else qtyRefs.delete(key)
}
const setSubtotalRef = (id: CartItemId, el: Element | ComponentPublicInstance | null) => {
  const key = String(id)
  if (el instanceof HTMLElement) subtotalRefs.set(key, el)
  else subtotalRefs.delete(key)
}

// Navigation
const continueShopping = () => void router.push('/shop')

const proceedToCheckout = () => {
  if (reduceMotion) {
    void router.push('/checkout')
    return
  }

  // Exit animation
  const tl = gsap.timeline({ onComplete: () => void router.push('/checkout') })
  if (checkoutBtnRef.value) {
    tl.to(checkoutBtnRef.value, { scale: 0.97, duration: 0.1 })
      .to(checkoutBtnRef.value, { scale: 1.05, duration: 0.15, ease: 'back.out(2)' })
  }
  tl.to('.cart-item', { y: -10, opacity: 0, stagger: 0.05, duration: 0.3 }, '-=0.1')
  if (sectionRef.value) {
    tl.to(sectionRef.value, { opacity: 0, duration: 0.2 })
  }
}

// Multi-stage remove
const removeItem = (productId: CartItemId) => {
  const key = String(productId)
  if (removingItems.has(key)) return

  const el = itemRefs.get(key)
  if (!el || reduceMotion) {
    cartStore.removeFromCart(productId)
    return
  }

  removingItems.add(key)

  const tl = gsap.timeline({
    onComplete: () => {
      cartStore.removeFromCart(productId)
      removingItems.delete(key)
      itemRefs.delete(key)
    }
  })

  tl.to(el, { backgroundColor: 'rgba(197,104,122,0.08)', duration: 0.15 })
    .to(el, { x: 80, opacity: 0, scale: 0.95, duration: 0.35, ease: 'power2.in' })
    .to(el, { height: 0, padding: 0, margin: 0, overflow: 'hidden', duration: 0.25, ease: 'power2.inOut' })
}

// Quantity with animation
const onDecrease = (productId: CartItemId, quantity: number) => {
  cartStore.updateQuantity(productId, quantity - 1)
  animateQtyChange(productId, 'down')
}

const onIncrease = (productId: CartItemId, quantity: number) => {
  cartStore.updateQuantity(productId, quantity + 1)
  animateQtyChange(productId, 'up')
}

const animateQtyChange = (productId: CartItemId, direction: 'up' | 'down') => {
  if (reduceMotion) return
  const key = String(productId)
  const qtyEl = qtyRefs.get(key)
  const subtotalEl = subtotalRefs.get(key)

  if (qtyEl) {
    gsap.fromTo(qtyEl,
      { scale: direction === 'up' ? 1.4 : 0.7, color: direction === 'up' ? '#27ae60' : '#c5687a' },
      { scale: 1, color: '#1c1917', duration: 0.4, ease: 'back.out(1.7)' }
    )
  }
  if (subtotalEl) {
    gsap.fromTo(subtotalEl, { opacity: 0.5 }, { opacity: 1, duration: 0.3 })
  }
}

// Step button press feedback
const onStepPress = (e: MouseEvent) => {
  if (reduceMotion) return
  gsap.to(e.currentTarget, { scale: 0.9, duration: 0.1 })
}
const onStepRelease = (e: MouseEvent) => {
  if (reduceMotion) return
  gsap.to(e.currentTarget, { scale: 1, duration: 0.2, ease: 'back.out(2)' })
}

// Swipe-to-delete (mobile)
const onTouchStart = (e: TouchEvent, itemId: CartItemId) => {
  touchState.value = { startX: e.touches[0].clientX, itemId }
}

const onTouchMove = (e: TouchEvent, itemId: CartItemId) => {
  if (touchState.value.itemId !== itemId) return
  const deltaX = e.touches[0].clientX - touchState.value.startX
  if (deltaX > 0) return // only allow left swipe
  const el = itemRefs.get(String(itemId))
  if (!el) return
  const content = el.querySelector('.cart-item__content') as HTMLElement
  if (content) gsap.set(content, { x: deltaX })
}

const onTouchEnd = (e: TouchEvent, itemId: CartItemId) => {
  if (touchState.value.itemId !== itemId) return
  const deltaX = e.changedTouches[0].clientX - touchState.value.startX
  const el = itemRefs.get(String(itemId))
  if (!el) return
  const content = el.querySelector('.cart-item__content') as HTMLElement
  if (!content) return

  if (deltaX < -100) {
    // Swipe past threshold — delete
    gsap.to(content, {
      x: -window.innerWidth, opacity: 0,
      duration: 0.3, ease: 'power2.in',
      onComplete: () => cartStore.removeFromCart(itemId)
    })
  } else {
    // Spring back
    gsap.to(content, { x: 0, duration: 0.4, ease: 'elastic.out(1, 0.5)' })
  }
  touchState.value = { startX: 0, itemId: null }
}

// Animated total counter
watch(totalPrice, (newVal, oldVal) => {
  if (reduceMotion) {
    displayedTotal.value = newVal
    return
  }
  gsap.to({ val: oldVal }, {
    val: newVal,
    duration: 0.6,
    ease: 'power2.out',
    onUpdate() {
      displayedTotal.value = this.targets()[0].val
    }
  })
})

// Shipping bar animation
watch(totalPrice, (newVal) => {
  if (reduceMotion || !shippingBarRef.value) return
  const progress = Math.min(newVal / FREE_SHIPPING_THRESHOLD, 1)
  gsap.to(shippingBarRef.value, {
    width: `${progress * 100}%`,
    duration: 0.6,
    ease: 'power2.out'
  })

  if (progress >= 1 && shippingTextRef.value) {
    gsap.fromTo(shippingTextRef.value, { scale: 1 }, {
      scale: 1.1, duration: 0.3, yoyo: true, repeat: 1, ease: 'power2.out'
    })
  }
}, { immediate: true })

// Page entrance
onMounted(async () => {
  await nextTick()

  if (reduceMotion) return

  if (items.value.length === 0) {
    // Empty state entrance
    if (emptyVaseRef.value) gsap.from(emptyVaseRef.value, { scale: 0, rotation: -10, opacity: 0, duration: 0.8, ease: 'back.out(1.7)' })
    if (emptyTextRef.value) gsap.from(emptyTextRef.value, { y: 30, opacity: 0, duration: 0.6, delay: 0.3 })
    if (emptyCtaRef.value) gsap.from(emptyCtaRef.value, { y: 20, opacity: 0, scale: 0.9, duration: 0.5, delay: 0.5, ease: 'back.out(1.7)' })
    return
  }

  const tl = gsap.timeline({ defaults: { ease: 'power3.out' } })

  if (headerRef.value) tl.from(headerRef.value, { y: 30, opacity: 0, duration: 0.6 })
  if (totalBadgeRef.value) tl.from(totalBadgeRef.value, { scale: 0, opacity: 0, duration: 0.5, ease: 'back.out(1.7)' }, '-=0.3')

  tl.from('.cart-item', { y: 40, opacity: 0, duration: 0.5, stagger: 0.1 }, '-=0.2')

  if (summaryRef.value) tl.from(summaryRef.value, { x: 30, opacity: 0, duration: 0.5 }, '-=0.3')
})

onUnmounted(() => {
  gsap.killTweensOf(Array.from(itemRefs.values()))
})
</script>

<style scoped>
/* ── Total badge ── */
.cart-total-badge {
  border-radius: 1.5rem;
  background: rgba(236,253,245,0.8);
  backdrop-filter: blur(8px);
  padding: 1rem 1.25rem;
  transition: transform 0.3s ease;
}

/* ── Cart item (glassmorphic) ── */
.cart-item {
  position: relative;
  border-radius: 24px;
  overflow: hidden;
  transition: box-shadow 0.3s ease, transform 0.3s ease;
}

.cart-item:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(45,26,26,0.12);
}

.cart-item__content {
  position: relative;
  z-index: 1;
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
  padding: 1.25rem;
  background: rgba(255,252,248,0.6);
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
  border: 1px solid rgba(197,104,122,0.1);
  border-radius: 24px;
  box-shadow: 0 2px 12px rgba(45,26,26,0.06);
}

@media (min-width: 640px) {
  .cart-item__content {
    flex-direction: row;
    align-items: center;
  }
}

/* ── Swipe delete background ── */
.cart-item__delete-bg {
  position: absolute;
  inset: 0;
  z-index: 0;
  background: linear-gradient(135deg, #c5687a, #e05d73);
  border-radius: 24px;
  display: flex;
  align-items: center;
  justify-content: flex-end;
  padding-right: 2rem;
}

@media (min-width: 1024px) {
  .cart-item__delete-bg {
    display: none;
  }
}

/* ── Thumbnail ── */
.cart-item__thumb {
  width: 100%;
  height: 7rem;
  border-radius: 20px;
  overflow: hidden;
  background: #fdf2f4;
  flex-shrink: 0;
  box-shadow: 0 4px 16px rgba(0,0,0,0.06);
}

@media (min-width: 640px) {
  .cart-item__thumb {
    width: 120px;
    height: 120px;
  }
}

.cart-item__thumb img {
  transition: transform 0.4s ease;
}

.cart-item:hover .cart-item__thumb img {
  transform: scale(1.05);
}

/* ── Remove button ── */
.cart-item__remove {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  border: none;
  background: rgba(197,104,122,0.08);
  color: #c5687a;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.25s cubic-bezier(0.34,1.56,0.64,1);
  flex-shrink: 0;
}

.cart-item__remove:hover {
  background: rgba(197,104,122,0.2);
  transform: scale(1.15);
  color: #a14d5e;
}

/* ── Quantity stepper ── */
.cart-item__stepper {
  display: inline-flex;
  align-items: center;
  border-radius: 100px;
  background: rgba(255,252,248,0.8);
  border: 1px solid rgba(197,104,122,0.12);
  box-shadow: 0 1px 4px rgba(45,26,26,0.04);
}

.cart-item__step-btn {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  border: none;
  background: transparent;
  color: #9f1239;
  font-size: 1.2rem;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background 0.2s ease;
}

.cart-item__step-btn:hover {
  background: rgba(197,104,122,0.08);
}

.cart-item__qty {
  min-width: 3rem;
  padding: 0 0.5rem;
  text-align: center;
  font-size: 1rem;
  font-weight: 600;
  color: #1c1917;
}

.cart-item__subtotal {
  font-size: 0.875rem;
  font-weight: 500;
  color: #78716c;
}

/* ── Summary sidebar ── */
.cart-summary {
  border-radius: 2rem;
  background: rgba(255,252,248,0.6);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(197,104,122,0.1);
  padding: 1.5rem;
  box-shadow: 0 4px 24px rgba(45,26,26,0.06);
  height: fit-content;
}

/* ── Shipping bar ── */
.cart-shipping-track {
  height: 4px;
  border-radius: 2px;
  background: rgba(197,104,122,0.12);
  overflow: hidden;
}

.cart-shipping-fill {
  height: 100%;
  width: 0%;
  border-radius: 2px;
  background: linear-gradient(90deg, #c5687a, #e8a0b4);
  transition: background 0.4s ease;
}

.cart-shipping-fill--met {
  background: linear-gradient(90deg, #27ae60, #2ecc71);
}

/* ── Checkout button ── */
.cart-checkout-btn {
  border: none;
  border-radius: 100px;
  padding: 0.85rem 1.5rem;
  font-size: 0.875rem;
  font-weight: 600;
  color: white;
  background: linear-gradient(135deg, #c5687a, #e8a0b4);
  box-shadow: 0 4px 20px rgba(197,104,122,0.35);
  cursor: pointer;
  transition: box-shadow 0.3s ease;
}

.cart-checkout-btn:hover {
  box-shadow: 0 8px 30px rgba(197,104,122,0.5);
}

/* ── CTA buttons ── */
.cart-cta {
  border: none;
  border-radius: 100px;
  padding: 0.85rem 1.5rem;
  font-size: 0.875rem;
  font-weight: 600;
  cursor: pointer;
}

.cart-cta--secondary {
  background: linear-gradient(135deg, #c5687a, #e8a0b4);
  color: white;
  box-shadow: 0 4px 20px rgba(197,104,122,0.3);
}

/* ── Empty state ── */
.cart-empty__vase {
  font-size: 3.5rem;
  color: rgba(197,104,122,0.3);
  margin-bottom: 1rem;
  animation: float 4s ease-in-out infinite;
}
</style>
