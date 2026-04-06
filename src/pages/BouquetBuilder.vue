<template>
  <section class="min-h-screen bg-gradient-to-b from-rose-50 via-white to-emerald-50 px-4 pt-24 pb-10 sm:px-6 lg:px-8">
    <!-- Floating petals (decorative) -->
    <div v-if="!reduceMotion" class="builder-petals" aria-hidden="true">
      <span v-for="i in 6" :key="i" class="builder-petal" :style="{ animationDelay: `${i * 1.3}s`, left: `${10 + i * 14}%` }"></span>
    </div>

    <div class="mx-auto max-w-7xl space-y-8">
      <!-- Header with progress ring -->
      <div ref="headerRef" class="rounded-[2rem] bg-white/85 p-8 shadow-sm ring-1 ring-rose-100">
        <div class="flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
          <div class="max-w-3xl space-y-3">
            <p class="text-sm font-semibold uppercase tracking-[0.3em] text-rose-400">Design Studio</p>
            <h1 class="heading-serif text-4xl font-semibold tracking-tight text-rose-950 sm:text-5xl">
              Craft Your Bouquet
            </h1>
            <p class="text-base leading-7 text-stone-600">
              Choose your favorite stems, balance colors and textures, and craft a bouquet that feels completely your own.
            </p>
          </div>

          <!-- Progress ring -->
          <div class="flex items-center gap-4">
            <div class="relative flex items-center justify-center">
              <svg width="72" height="72" viewBox="0 0 72 72" class="builder-ring-svg">
                <circle cx="36" cy="36" r="28" fill="none" stroke="rgba(197,104,122,0.15)" stroke-width="4" />
                <circle
                  ref="progressRingRef"
                  cx="36" cy="36" r="28"
                  fill="none"
                  stroke="#c5687a"
                  stroke-width="4"
                  stroke-linecap="round"
                  :stroke-dasharray="ringCircumference"
                  :stroke-dashoffset="ringCircumference"
                  transform="rotate(-90 36 36)"
                />
              </svg>
              <span class="builder-ring-count">{{ selectedStemCount }}</span>
            </div>
            <div>
              <p class="text-sm text-stone-500">stems selected</p>
              <p class="text-xs text-stone-400">{{ milestoneText }}</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Main grid -->
      <div class="grid gap-8 lg:grid-cols-[1.25fr_0.75fr]">
        <!-- Component cards -->
        <div class="space-y-6">
          <div
            v-if="loading"
            class="rounded-[2rem] bg-white/85 px-6 py-16 text-center shadow-sm ring-1 ring-rose-100"
          >
            <div class="mx-auto h-12 w-12 animate-spin rounded-full border-4 border-rose-100 border-t-rose-400"></div>
            <p class="mt-4 text-lg font-medium text-rose-900">Loading bouquet components...</p>
          </div>

          <div
            v-else-if="errorMessage"
            class="rounded-[2rem] bg-white/85 px-6 py-16 text-center shadow-sm ring-1 ring-rose-100"
          >
            <p class="text-lg font-medium text-rose-900">{{ errorMessage }}</p>
          </div>

          <div
            v-else
            ref="gridContainerRef"
            class="grid gap-6 sm:grid-cols-2 xl:grid-cols-3"
          >
            <article
              v-for="component in components"
              :key="component.id"
              :ref="(el) => setCardRef(component.id, el)"
              class="builder-card"
              @mouseenter="onCardEnter(component.id)"
              @mouseleave="onCardLeave(component.id)"
            >
              <!-- Quantity badge -->
              <Transition name="bloom">
                <span
                  v-if="getQuantity(component.id) > 0"
                  :ref="(el) => setBadgeRef(component.id, el)"
                  class="builder-card__badge"
                >
                  {{ getQuantity(component.id) }}
                </span>
              </Transition>

              <!-- Image wrap -->
              <div class="builder-card__img-wrap">
                <OptimizedImage
                  :src="component.image_url || fallbackImage"
                  :alt="component.name"
                  img-class="builder-card__img"
                />
                <div class="builder-card__overlay"></div>

                <!-- Info panel over image -->
                <div class="builder-card__info">
                  <h2 class="builder-card__name">{{ component.name }}</h2>
                  <p class="builder-card__meaning">{{ getComponentMeaning(component) }}</p>
                  <p class="builder-card__price">${{ getPrice(component).toFixed(2) }}<span class="builder-card__price-label"> / stem</span></p>

                  <!-- Glassmorphic stepper (slides up on hover) -->
                  <div class="builder-card__stepper">
                    <button
                      class="builder-card__step-btn"
                      type="button"
                      :disabled="getQuantity(component.id) === 0"
                      @click.stop="onDecrease(component.id)"
                    >
                      &minus;
                    </button>
                    <span
                      :ref="(el) => setQtyRef(component.id, el)"
                      class="builder-card__qty"
                    >
                      {{ getQuantity(component.id) }}
                    </span>
                    <button
                      class="builder-card__step-btn"
                      type="button"
                      @click.stop="onIncrease(component.id)"
                    >
                      &plus;
                    </button>
                  </div>
                </div>
              </div>
            </article>
          </div>
        </div>

        <!-- Sidebar (desktop) -->
        <aside class="hidden lg:block">
          <div class="builder-sidebar lg:sticky lg:top-28">
            <div class="flex items-end justify-between gap-4">
              <div>
                <h2 class="text-2xl font-semibold text-rose-950">Your Bouquet</h2>
                <p class="mt-1 text-sm text-stone-500">A soft, hand-picked arrangement in progress.</p>
              </div>
              <p ref="sidebarTotalRef" class="text-2xl font-semibold text-emerald-800">${{ totalPrice.toFixed(2) }}</p>
            </div>

            <!-- Vase area -->
            <div ref="vaseAreaRef" class="builder-vase">
              <svg viewBox="0 0 120 80" class="builder-vase__svg" aria-hidden="true">
                <path d="M35 25 Q30 50 38 70 L82 70 Q90 50 85 25 Z" fill="none" stroke="rgba(197,104,122,0.2)" stroke-width="1.5" />
                <ellipse cx="60" cy="25" rx="26" ry="6" fill="none" stroke="rgba(197,104,122,0.15)" stroke-width="1.5" />
              </svg>
              <!-- Stem dots appear here dynamically -->
              <div class="builder-vase__dots">
                <span
                  v-for="(dot, i) in vaseDots"
                  :key="dot.id"
                  class="builder-vase__dot"
                  :style="{ backgroundColor: dot.color, left: dot.x + 'px', bottom: (20 + i * 4) + 'px' }"
                ></span>
              </div>
            </div>

            <div
              v-if="selectedComponents.length === 0"
              class="mt-4 rounded-3xl bg-rose-50 px-5 py-8 text-center"
            >
              <p class="builder-empty-icon">&#10047;</p>
              <p class="text-base font-medium text-rose-900">Your bouquet is empty</p>
              <p class="mt-2 text-sm text-stone-500">Add a few stems from the left to start arranging.</p>
            </div>

            <div
              v-else
              class="mt-4 space-y-3"
            >
              <article
                v-for="component in selectedComponents"
                :key="component.id"
                :ref="(element) => setSidebarItemRef(component.id, element)"
                class="builder-sidebar__item"
              >
                <div class="flex items-start justify-between gap-3">
                  <div class="min-w-0">
                    <h3 class="truncate text-base font-semibold text-rose-950">{{ component.name }}</h3>
                    <p class="mt-1 text-sm text-stone-500">{{ component.quantity }} stems</p>
                  </div>
                  <p class="builder-sidebar__item-price text-sm font-semibold text-emerald-700">
                    ${{ (component.price * component.quantity).toFixed(2) }}
                  </p>
                </div>
              </article>
            </div>

            <button
              ref="addButtonRef"
              class="builder-cta mt-6 w-full"
              type="button"
              :disabled="selectedComponents.length === 0"
              @click="addBouquetToCart"
            >
              Add Bouquet to Cart
            </button>
          </div>
        </aside>

        <!-- Mobile bottom sheet -->
        <div ref="bottomSheetRef" class="builder-bottom-sheet lg:hidden">
          <div class="builder-bottom-sheet__handle" @click="toggleBottomSheet"></div>
          <div class="builder-bottom-sheet__header" @click="toggleBottomSheet">
            <div class="flex items-center gap-3">
              <span class="builder-bottom-sheet__count">{{ selectedStemCount }}</span>
              <span class="text-sm font-medium text-rose-950">stems</span>
            </div>
            <p class="text-lg font-semibold text-emerald-800">${{ totalPrice.toFixed(2) }}</p>
          </div>
          <div class="builder-bottom-sheet__body">
            <div class="space-y-3 pb-4">
              <article
                v-for="component in selectedComponents"
                :key="'m-' + component.id"
                class="builder-sidebar__item"
              >
                <div class="flex items-start justify-between gap-3">
                  <div class="min-w-0">
                    <h3 class="truncate text-sm font-semibold text-rose-950">{{ component.name }}</h3>
                    <p class="text-xs text-stone-500">{{ component.quantity }} stems</p>
                  </div>
                  <p class="text-xs font-semibold text-emerald-700">
                    ${{ (component.price * component.quantity).toFixed(2) }}
                  </p>
                </div>
              </article>
            </div>
            <button
              class="builder-cta w-full"
              type="button"
              :disabled="selectedComponents.length === 0"
              @click="addBouquetToCart"
            >
              Add Bouquet to Cart
            </button>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { computed, nextTick, onMounted, onUnmounted, ref, watch } from 'vue'
import type { ComponentPublicInstance } from 'vue'
import gsap from 'gsap'
import ScrollTrigger from 'gsap/ScrollTrigger'
import { prefersReducedMotion } from '@/animations/motion'
import { useCartStore } from '@/stores/cart'
import type { CustomBouquetComponent } from '@/stores/cart'
import { supabase } from '@/lib/supabase'
import { getFlowerMeaning } from '@/composables/useFlowerMeaning'
import { useMagneticButton } from '@/composables/useMagneticButton'
import OptimizedImage from '@/components/OptimizedImage.vue'

gsap.registerPlugin(ScrollTrigger)

interface BouquetComponent {
  id: number
  name: string
  image_url: string
  price_per_stem?: number | null
  price?: number | null
}

const fallbackImage =
  'https://images.unsplash.com/photo-1525310072745-f49212b5ac6d?auto=format&fit=crop&w=900&q=80'

const STEM_COLORS = ['#c5687a', '#e8a0b4', '#d4956b', '#7da67d', '#b08ec2', '#e0c97a', '#6ba3b5', '#d46b7c']
const CONFETTI_COLORS = ['#c5687a', '#e8a0b4', '#f4d03f', '#27ae60']
const MAX_STEMS = 12
const reduceMotion = prefersReducedMotion()

const cartStore = useCartStore()

// State
const components = ref<BouquetComponent[]>([])
const selectedQuantities = ref<Record<number, number>>({})
const loading = ref(true)
const errorMessage = ref('')
const bottomSheetOpen = ref(false)

// Refs
const headerRef = ref<HTMLElement | null>(null)
const progressRingRef = ref<SVGCircleElement | null>(null)
const gridContainerRef = ref<HTMLElement | null>(null)
const vaseAreaRef = ref<HTMLElement | null>(null)
const addButtonRef = ref<HTMLElement | null>(null)
const bottomSheetRef = ref<HTMLElement | null>(null)
const sidebarTotalRef = ref<HTMLElement | null>(null)

const sidebarItemRefs = new Map<number, HTMLElement>()
const cardRefs = new Map<number, HTMLElement>()
const badgeRefs = new Map<number, HTMLElement>()
const qtyRefs = new Map<number, HTMLElement>()

// Progress ring
const ringCircumference = 2 * Math.PI * 28

// Magnetic CTA
useMagneticButton(addButtonRef)

// Helpers
const getPrice = (component: BouquetComponent) =>
  component.price_per_stem ?? component.price ?? 0

const getComponentMeaning = (component: BouquetComponent) =>
  getFlowerMeaning({ name: component.name })

const getQuantity = (componentId: number) => selectedQuantities.value[componentId] ?? 0

// Computed
const selectedComponents = computed<CustomBouquetComponent[]>(() =>
  components.value
    .filter((component) => getQuantity(component.id) > 0)
    .map((component) => ({
      id: component.id,
      name: component.name,
      image_url: component.image_url,
      price: getPrice(component),
      quantity: getQuantity(component.id)
    }))
)

const selectedStemCount = computed(() =>
  selectedComponents.value.reduce((total, component) => total + component.quantity, 0)
)

const totalPrice = computed(() =>
  selectedComponents.value.reduce(
    (total, component) => total + component.price * component.quantity,
    0
  )
)

const milestoneText = computed(() => {
  const count = selectedStemCount.value
  if (count === 0) return 'Start picking!'
  if (count < 3) return 'Nice start...'
  if (count < 6) return 'Looking lovely!'
  if (count < 9) return 'Beautiful arrangement!'
  if (count < MAX_STEMS) return 'Almost a full bouquet!'
  return 'A stunning bouquet!'
})

const vaseDots = computed(() => {
  return selectedComponents.value.flatMap((comp, ci) =>
    Array.from({ length: Math.min(comp.quantity, 4) }, (_, i) => ({
      id: `${comp.id}-${i}`,
      color: STEM_COLORS[(ci + i) % STEM_COLORS.length],
      x: 24 + ((ci * 3 + i * 7) % 52)
    }))
  )
})

// Ref setters
const setCardRef = (id: number, el: Element | ComponentPublicInstance | null) => {
  if (el instanceof HTMLElement) cardRefs.set(id, el)
  else cardRefs.delete(id)
}
const setBadgeRef = (id: number, el: Element | ComponentPublicInstance | null) => {
  if (el instanceof HTMLElement) badgeRefs.set(id, el)
  else badgeRefs.delete(id)
}
const setQtyRef = (id: number, el: Element | ComponentPublicInstance | null) => {
  if (el instanceof HTMLElement) qtyRefs.set(id, el)
  else qtyRefs.delete(id)
}
const setSidebarItemRef = (id: number, el: Element | ComponentPublicInstance | null) => {
  if (el instanceof HTMLElement) sidebarItemRefs.set(id, el)
  else sidebarItemRefs.delete(id)
}

// Card hover animations
const onCardEnter = (id: number) => {
  if (reduceMotion) return
  const card = cardRefs.get(id)
  if (!card) return
  const img = card.querySelector('.builder-card__img')
  const stepper = card.querySelector('.builder-card__stepper')
  gsap.to(card, { y: -8, duration: 0.35, ease: 'power2.out' })
  if (img) gsap.to(img, { scale: 1.07, duration: 0.7, ease: 'power2.out' })
  if (stepper) gsap.to(stepper, { y: 0, opacity: 1, duration: 0.38, ease: 'back.out(1.7)' })
}

const onCardLeave = (id: number) => {
  if (reduceMotion) return
  const card = cardRefs.get(id)
  if (!card) return
  const img = card.querySelector('.builder-card__img')
  const stepper = card.querySelector('.builder-card__stepper')
  gsap.to(card, { y: 0, duration: 0.5, ease: 'elastic.out(1, 0.5)' })
  if (img) gsap.to(img, { scale: 1, duration: 0.5, ease: 'power2.out' })
  if (stepper) gsap.to(stepper, { y: '100%', opacity: 0, duration: 0.25, ease: 'power2.in' })
}

// Quantity with animations
const onIncrease = (componentId: number) => {
  increaseQuantity(componentId)
  animateQtyChange(componentId)
  animateFlyingDot(componentId)
  animateBadgePulse(componentId)
}

const onDecrease = (componentId: number) => {
  decreaseQuantity(componentId)
  animateQtyChange(componentId)
}

const increaseQuantity = (componentId: number) => {
  selectedQuantities.value = {
    ...selectedQuantities.value,
    [componentId]: getQuantity(componentId) + 1
  }
}

const decreaseQuantity = (componentId: number) => {
  const nextQuantity = Math.max(0, getQuantity(componentId) - 1)
  selectedQuantities.value = {
    ...selectedQuantities.value,
    [componentId]: nextQuantity
  }
}

const animateQtyChange = (componentId: number) => {
  if (reduceMotion) return
  const qtyEl = qtyRefs.get(componentId)
  if (!qtyEl) return
  gsap.fromTo(qtyEl,
    { scale: 1.4, color: '#c5687a' },
    { scale: 1, color: 'rgba(255,252,248,0.92)', duration: 0.4, ease: 'back.out(1.7)' }
  )
}

const animateBadgePulse = (componentId: number) => {
  if (reduceMotion) return
  nextTick(() => {
    const badge = badgeRefs.get(componentId)
    if (!badge) return
    gsap.fromTo(badge, { scale: 1.3 }, { scale: 1, duration: 0.3, ease: 'back.out(1.7)' })
  })
}

const animateFlyingDot = (componentId: number) => {
  if (reduceMotion || !vaseAreaRef.value) return
  const card = cardRefs.get(componentId)
  if (!card) return

  const stepper = card.querySelector('.builder-card__stepper')
  if (!stepper) return

  const startRect = stepper.getBoundingClientRect()
  const endRect = vaseAreaRef.value.getBoundingClientRect()

  const dot = document.createElement('div')
  dot.style.cssText = `
    position: fixed; z-index: 9999; width: 12px; height: 12px; border-radius: 50%;
    pointer-events: none; background: #c5687a;
    left: ${startRect.left + startRect.width / 2 - 6}px;
    top: ${startRect.top + startRect.height / 2 - 6}px;
  `
  document.body.appendChild(dot)

  const midX = (startRect.left + endRect.left + endRect.width / 2) / 2
  const midY = Math.min(startRect.top, endRect.top) - 60

  gsap.timeline()
    .to(dot, { left: midX, top: midY, scale: 0.8, duration: 0.3, ease: 'power2.out' })
    .to(dot, {
      left: endRect.left + endRect.width / 2,
      top: endRect.top + 30,
      scale: 0.4,
      opacity: 0,
      duration: 0.3,
      ease: 'power2.in',
      onComplete: () => dot.remove()
    })
}

// Confetti on add to cart
const fireConfetti = () => {
  if (reduceMotion || !addButtonRef.value) return
  const rect = addButtonRef.value.getBoundingClientRect()
  const cx = rect.left + rect.width / 2
  const cy = rect.top

  for (let i = 0; i < 25; i++) {
    const particle = document.createElement('div')
    const color = CONFETTI_COLORS[i % CONFETTI_COLORS.length]
    const size = 4 + Math.random() * 4
    particle.style.cssText = `
      position: fixed; z-index: 9999; pointer-events: none; border-radius: 50%;
      width: ${size}px; height: ${size}px; background: ${color};
      left: ${cx}px; top: ${cy}px;
    `
    document.body.appendChild(particle)

    const angle = Math.random() * Math.PI * 2
    const distance = 60 + Math.random() * 120

    gsap.to(particle, {
      left: `+=${Math.cos(angle) * distance}`,
      top: `+=${Math.sin(angle) * distance - 40}`,
      scale: 0,
      opacity: 0,
      rotation: Math.random() * 360,
      duration: 0.6 + Math.random() * 0.4,
      ease: 'power2.out',
      onComplete: () => particle.remove()
    })
  }
}

const addBouquetToCart = () => {
  if (selectedComponents.value.length === 0) return

  // Button animation
  if (!reduceMotion && addButtonRef.value) {
    gsap.timeline()
      .to(addButtonRef.value, { scale: 0.95, duration: 0.1, ease: 'power2.in' })
      .to(addButtonRef.value, { scale: 1.05, duration: 0.3, ease: 'back.out(2)' })
      .to(addButtonRef.value, { scale: 1, duration: 0.2 })
  }

  fireConfetti()

  cartStore.addToCart({
    id: 'custom-bouquet',
    name: 'Custom Bouquet',
    image_url: selectedComponents.value[0]?.image_url || fallbackImage,
    price: totalPrice.value,
    quantity: 1,
    components: selectedComponents.value
  })
}

// Bottom sheet
const toggleBottomSheet = () => {
  bottomSheetOpen.value = !bottomSheetOpen.value
  if (reduceMotion || !bottomSheetRef.value) return
  const body = bottomSheetRef.value.querySelector('.builder-bottom-sheet__body') as HTMLElement
  if (!body) return
  gsap.to(body, {
    height: bottomSheetOpen.value ? 'auto' : 0,
    duration: 0.4,
    ease: 'power2.inOut'
  })
}

// Data fetching
const fetchComponents = async () => {
  loading.value = true
  errorMessage.value = ''
  const { data, error } = await supabase.from('bouquet_components').select('*')
  if (error) {
    errorMessage.value = error.message
    loading.value = false
    return
  }
  components.value = (data ?? []) as BouquetComponent[]
  loading.value = false
}

// Lifecycle
onMounted(async () => {
  await fetchComponents()

  if (reduceMotion) return

  // Header entrance
  if (headerRef.value) {
    gsap.from(headerRef.value, { y: 40, opacity: 0, duration: 0.8, ease: 'power3.out' })
  }

  // Progress ring entrance
  if (progressRingRef.value) {
    gsap.from(progressRingRef.value, {
      scale: 0, rotation: -90, opacity: 0, duration: 0.6,
      ease: 'back.out(1.7)', delay: 0.3
    })
  }

  // Staggered card entrance
  await nextTick()
  if (gridContainerRef.value) {
    gsap.from(gridContainerRef.value.querySelectorAll('.builder-card'), {
      y: 60, opacity: 0, scale: 0.92,
      duration: 0.7, ease: 'power2.out',
      stagger: { amount: 0.8, from: 'start' },
      scrollTrigger: {
        trigger: gridContainerRef.value,
        start: 'top 85%',
        toggleActions: 'play none none none'
      }
    })
  }
})

// Watch progress ring
watch(selectedStemCount, (newCount, oldCount) => {
  if (reduceMotion || !progressRingRef.value) return

  const progress = Math.min(newCount / MAX_STEMS, 1)
  const offset = ringCircumference * (1 - progress)

  gsap.to(progressRingRef.value, {
    strokeDashoffset: offset,
    duration: 0.6,
    ease: 'power2.out'
  })

  // Milestone pulse
  if (newCount > 0 && newCount % 3 === 0 && newCount > (oldCount ?? 0)) {
    gsap.fromTo(progressRingRef.value,
      { scale: 1 },
      { scale: 1.15, duration: 0.3, ease: 'power2.out', yoyo: true, repeat: 1, transformOrigin: 'center' }
    )
  }
})

// Watch sidebar items
watch(
  () => selectedComponents.value.map((c) => c.id),
  async (nextIds, previousIds) => {
    const newId = nextIds.find((id) => !previousIds.includes(id))
    if (newId === undefined) return
    await nextTick()
    const newItem = sidebarItemRefs.get(newId)
    if (!newItem || reduceMotion) return

    gsap.timeline()
      .from(newItem, { scale: 0, opacity: 0, y: 20, duration: 0.5, ease: 'back.out(1.7)' })
      .from(newItem.querySelector('.builder-sidebar__item-price') || newItem, { x: -10, opacity: 0, duration: 0.3 }, '-=0.2')

    // Check for items removed from sidebar
    const removedId = previousIds.find((id) => !nextIds.includes(id))
    if (removedId !== undefined) {
      const removedItem = sidebarItemRefs.get(removedId)
      if (removedItem && !reduceMotion) {
        gsap.to(removedItem, {
          x: 40, opacity: 0, height: 0, padding: 0,
          duration: 0.4, ease: 'power2.in'
        })
      }
    }
  },
  { deep: false }
)

onUnmounted(() => {
  gsap.killTweensOf(Array.from(sidebarItemRefs.values()))
  gsap.killTweensOf(Array.from(cardRefs.values()))
})
</script>

<style scoped>
/* ── Builder Cards (pcard-style dark overlay) ── */
.builder-card {
  position: relative;
  border-radius: 24px;
  overflow: hidden;
  background: #1a0e0e;
  box-shadow: 0 8px 32px rgba(45, 26, 26, 0.14);
  transition: box-shadow 0.35s ease;
  will-change: transform;
  cursor: default;
}

.builder-card:hover {
  box-shadow: 0 24px 64px rgba(45, 26, 26, 0.28), 0 4px 16px rgba(197,104,122,0.2);
}

.builder-card__img-wrap {
  position: relative;
  aspect-ratio: 3 / 4;
  overflow: hidden;
}

.builder-card :deep(.builder-card__img) {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  transition: transform 0.7s cubic-bezier(0.25,0.46,0.45,0.94);
}

.builder-card__overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(
    to bottom,
    transparent 35%,
    rgba(20, 8, 8, 0.35) 60%,
    rgba(20, 8, 8, 0.82) 100%
  );
  pointer-events: none;
}

.builder-card__info {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 16px 18px 18px;
}

.builder-card__name {
  font-family: 'Cormorant Garamond', 'Playfair Display', Georgia, serif;
  font-size: 1.15rem;
  font-weight: 500;
  color: rgba(255,252,248,0.95);
  line-height: 1.2;
  margin: 0 0 4px;
}

.builder-card__meaning {
  font-family: 'Cormorant Garamond', 'Playfair Display', Georgia, serif;
  font-size: 0.75rem;
  font-style: italic;
  color: rgba(255, 252, 248, 0.5);
  margin: 0 0 6px;
  line-height: 1.4;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-height: 0;
  opacity: 0;
  transition: max-height 0.35s ease, opacity 0.3s ease;
}

.builder-card:hover .builder-card__meaning {
  max-height: 2em;
  opacity: 1;
}

.builder-card__price {
  font-family: 'Cormorant Garamond', 'Playfair Display', Georgia, serif;
  font-size: 1.1rem;
  font-weight: 600;
  color: #e8a0b4;
  margin: 0 0 10px;
}

.builder-card__price-label {
  font-size: 0.75rem;
  font-weight: 400;
  color: rgba(255,252,248,0.5);
}

/* ── Glassmorphic stepper ── */
.builder-card__stepper {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 4px;
  background: rgba(255,252,248,0.18);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border: 1px solid rgba(255,255,255,0.22);
  border-radius: 100px;
  padding: 4px 8px;
  transform: translateY(100%);
  opacity: 0;
  will-change: transform, opacity;
}

.builder-card__step-btn {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  border: none;
  background: rgba(255,252,248,0.12);
  color: rgba(255,252,248,0.9);
  font-size: 1.2rem;
  font-weight: 500;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background 0.2s ease;
}

.builder-card__step-btn:hover:not(:disabled) {
  background: rgba(197,104,122,0.4);
}

.builder-card__step-btn:disabled {
  opacity: 0.3;
  cursor: not-allowed;
}

.builder-card__qty {
  min-width: 32px;
  text-align: center;
  font-weight: 600;
  font-size: 1rem;
  color: rgba(255,252,248,0.92);
}

/* ── Quantity badge ── */
.builder-card__badge {
  position: absolute;
  top: 12px;
  right: 12px;
  z-index: 10;
  width: 30px;
  height: 30px;
  border-radius: 50%;
  background: rgba(197,104,122,0.85);
  backdrop-filter: blur(8px);
  border: 1.5px solid rgba(255,255,255,0.3);
  color: white;
  font-size: 0.8rem;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
}

/* ── Progress ring ── */
.builder-ring-svg {
  display: block;
}

.builder-ring-count {
  position: absolute;
  font-family: 'Cormorant Garamond', 'Playfair Display', Georgia, serif;
  font-size: 1.4rem;
  font-weight: 700;
  color: #c5687a;
}

/* ── Sidebar ── */
.builder-sidebar {
  background: rgba(255,252,248,0.6);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(197,104,122,0.1);
  border-radius: 2rem;
  padding: 1.5rem;
  box-shadow: 0 4px 24px rgba(45,26,26,0.06);
}

.builder-sidebar__item {
  border-radius: 1.25rem;
  background: rgba(197,104,122,0.06);
  padding: 1rem;
  transition: background 0.2s ease;
}

.builder-sidebar__item:hover {
  background: rgba(197,104,122,0.1);
}

/* ── Vase visualization ── */
.builder-vase {
  position: relative;
  height: 80px;
  margin-top: 1rem;
  display: flex;
  align-items: center;
  justify-content: center;
}

.builder-vase__svg {
  width: 120px;
  height: 80px;
  opacity: 0.6;
}

.builder-vase__dots {
  position: absolute;
  width: 100px;
  height: 60px;
  bottom: 10px;
}

.builder-vase__dot {
  position: absolute;
  width: 8px;
  height: 8px;
  border-radius: 50%;
  transition: all 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
}

/* ── Empty state ── */
.builder-empty-icon {
  font-size: 2rem;
  color: rgba(197,104,122,0.3);
  margin-bottom: 0.5rem;
  animation: float 4s ease-in-out infinite;
}

/* ── CTA button ── */
.builder-cta {
  border: none;
  border-radius: 100px;
  padding: 1rem 1.5rem;
  font-size: 1rem;
  font-weight: 600;
  color: white;
  background: linear-gradient(135deg, #c5687a, #e8a0b4);
  box-shadow: 0 4px 20px rgba(197,104,122,0.35);
  cursor: pointer;
  transition: box-shadow 0.3s ease, opacity 0.3s ease;
}

.builder-cta:hover:not(:disabled) {
  box-shadow: 0 8px 30px rgba(197,104,122,0.5);
}

.builder-cta:disabled {
  opacity: 0.4;
  cursor: not-allowed;
  box-shadow: none;
}

/* ── Mobile bottom sheet ── */
.builder-bottom-sheet {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  z-index: 40;
  background: rgba(255,252,248,0.95);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border-top: 1px solid rgba(197,104,122,0.15);
  border-radius: 1.5rem 1.5rem 0 0;
  box-shadow: 0 -4px 24px rgba(45,26,26,0.08);
  padding: 0 1.25rem 1.25rem;
}

.builder-bottom-sheet__handle {
  width: 36px;
  height: 4px;
  border-radius: 2px;
  background: rgba(197,104,122,0.25);
  margin: 10px auto 8px;
  cursor: pointer;
}

.builder-bottom-sheet__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 8px 0 12px;
  cursor: pointer;
}

.builder-bottom-sheet__count {
  width: 28px;
  height: 28px;
  border-radius: 50%;
  background: linear-gradient(135deg, #c5687a, #e8a0b4);
  color: white;
  font-size: 0.8rem;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
}

.builder-bottom-sheet__body {
  height: 0;
  overflow: hidden;
}

/* ── Floating petals ── */
.builder-petals {
  position: fixed;
  inset: 0;
  pointer-events: none;
  z-index: 0;
  overflow: hidden;
}

.builder-petal {
  position: absolute;
  top: -12%;
  width: 8px;
  height: 8px;
  border-radius: 50% 0 50% 50%;
  background: rgba(197,104,122,0.1);
  animation: fall 8s linear infinite;
}

.builder-petal:nth-child(2n) {
  width: 6px;
  height: 6px;
  background: rgba(232,160,180,0.08);
  animation-duration: 10s;
}

.builder-petal:nth-child(3n) {
  width: 10px;
  height: 10px;
  background: rgba(197,104,122,0.06);
  animation-duration: 12s;
}

/* ── Bloom transition for badge ── */
.bloom-enter-active {
  animation: bloom-in 0.5s cubic-bezier(0.34, 1.56, 0.64, 1);
}
.bloom-leave-active {
  animation: bloom-out 0.2s ease forwards;
}
@keyframes bloom-in {
  from { transform: scale(0); opacity: 0; }
  to { transform: scale(1); opacity: 1; }
}
@keyframes bloom-out {
  from { transform: scale(1); opacity: 1; }
  to { transform: scale(0.7); opacity: 0; }
}
</style>
