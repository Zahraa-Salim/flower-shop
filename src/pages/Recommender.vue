<!-- Recommender.vue — Step-by-step guided bouquet finder by occasion, recipient, and budget -->
<template>
  <section class="min-h-screen bg-gradient-to-b from-rose-50 via-white to-emerald-50 px-4 py-10 sm:px-6 lg:px-8">
    <div class="mx-auto max-w-2xl pt-20">
      <div ref="headerRef" class="text-center mb-10">
        <p class="text-sm font-semibold uppercase tracking-[0.3em] text-rose-400">Bouquet Advisor</p>
        <h1 class="heading-serif mt-3 text-4xl font-semibold text-rose-950 sm:text-5xl">Find the Perfect Bouquet</h1>
        <p class="mt-3 text-base text-stone-500">
          Answer a few questions and we'll suggest the ideal flowers.
        </p>
      </div>

      <div class="rounded-[2rem] bg-white/85 p-6 shadow-sm ring-1 ring-rose-100 sm:p-8">
        <!-- Step 1: Recipient -->
        <div v-if="step === 1" class="space-y-5">
          <h2 class="text-xl font-semibold text-rose-950">Who is this bouquet for?</h2>
          <div class="grid grid-cols-2 gap-3">
            <button
              v-for="r in recipients"
              :key="r.value"
              class="rounded-2xl border-2 px-4 py-4 text-sm font-semibold transition"
              :class="recipient === r.value
                ? 'border-rose-400 bg-rose-50 text-rose-900'
                : 'border-rose-100 bg-white text-stone-600 hover:border-rose-200'"
              type="button"
              @click="recipient = r.value; step = 2"
            >
              <span class="text-xl block mb-1">{{ r.icon }}</span>
              {{ r.label }}
            </button>
          </div>
        </div>

        <!-- Step 2: Occasion -->
        <div v-else-if="step === 2" class="space-y-5">
          <h2 class="text-xl font-semibold text-rose-950">What's the occasion?</h2>
          <div class="grid grid-cols-2 gap-3">
            <button
              v-for="o in occasions"
              :key="o.value"
              class="rounded-2xl border-2 px-4 py-4 text-sm font-semibold transition"
              :class="occasion === o.value
                ? 'border-rose-400 bg-rose-50 text-rose-900'
                : 'border-rose-100 bg-white text-stone-600 hover:border-rose-200'"
              type="button"
              @click="occasion = o.value; step = 3"
            >
              <span class="text-xl block mb-1">{{ o.icon }}</span>
              {{ o.label }}
            </button>
          </div>
          <button class="text-sm text-rose-400 hover:text-rose-600" type="button" @click="step = 1">← Back</button>
        </div>

        <!-- Step 3: Budget -->
        <div v-else-if="step === 3" class="space-y-5">
          <h2 class="text-xl font-semibold text-rose-950">What's your budget?</h2>
          <div class="grid grid-cols-2 gap-3">
            <button
              v-for="b in budgets"
              :key="b.value"
              class="rounded-2xl border-2 px-4 py-4 text-sm font-semibold transition"
              :class="budget === b.value
                ? 'border-rose-400 bg-rose-50 text-rose-900'
                : 'border-rose-100 bg-white text-stone-600 hover:border-rose-200'"
              type="button"
              @click="budget = b.value; step = 4"
            >
              {{ b.label }}
            </button>
          </div>
          <button class="text-sm text-rose-400 hover:text-rose-600" type="button" @click="step = 2">← Back</button>
        </div>

        <!-- Step 4: Results -->
        <div v-else class="space-y-6">
          <div class="flex items-center justify-between">
            <h2 class="text-xl font-semibold text-rose-950">Our Recommendations</h2>
            <button class="text-sm text-rose-400 hover:text-rose-600" type="button" @click="reset">Start Over</button>
          </div>

          <div v-if="recommendations.length === 0" class="text-center py-8 text-stone-500">
            <p class="text-3xl mb-3">🌿</p>
            <p>No exact matches found. Try adjusting your budget or occasion!</p>
          </div>

          <div v-else class="space-y-4">
            <article
              v-for="product in recommendations"
              :key="product.id"
              class="flex gap-4 rounded-2xl bg-rose-50/60 p-4 ring-1 ring-rose-100 transition hover:ring-rose-200 cursor-pointer"
              @click="$router.push(`/product/${product.id}`)"
            >
              <img
                :src="product.image_url"
                :alt="product.name"
                class="h-24 w-24 rounded-xl object-cover flex-shrink-0"
              />
              <div class="flex-1 min-w-0">
                <h3 class="font-semibold text-rose-950 truncate">{{ product.name }}</h3>
                <p class="text-sm font-semibold text-emerald-700 mt-1">${{ product.price.toFixed(2) }}</p>
                <p class="text-xs italic text-stone-500 mt-1 line-clamp-2">{{ getMeaning(product) }}</p>
              </div>
            </article>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useFlowerStore, type Product } from '@/stores/flowers'
import { getFlowerMeaning } from '@/composables/useFlowerMeaning'
import gsap from 'gsap'
import { prefersReducedMotion } from '@/animations/motion'

const store = useFlowerStore()

const headerRef = ref<HTMLElement | null>(null)

const step = ref(1)
const recipient = ref('')
const occasion = ref('')
const budget = ref('')

const recipients = [
  { value: 'partner', label: 'Partner', icon: '💕' },
  { value: 'parent', label: 'Parent', icon: '🏠' },
  { value: 'friend', label: 'Friend', icon: '🤝' },
  { value: 'self', label: 'Myself', icon: '✨' },
]

const occasions = [
  { value: 'birthday', label: 'Birthday', icon: '🎂' },
  { value: 'anniversary', label: 'Anniversary', icon: '💍' },
  { value: 'sympathy', label: 'Sympathy', icon: '🕊️' },
  { value: 'congratulations', label: 'Congrats', icon: '🎉' },
  { value: 'romance', label: 'Romance', icon: '❤️' },
  { value: 'just-because', label: 'Just Because', icon: '🌸' },
]

const budgets = [
  { value: 'low', label: 'Under $30' },
  { value: 'mid', label: '$30 – $60' },
  { value: 'high', label: '$60 – $100' },
  { value: 'premium', label: '$100+' },
]

// Recommendation rules: map occasions/recipients to preferred flower types
const typeScores: Record<string, Record<string, number>> = {
  partner:  { Rose: 5, Peony: 4, Orchid: 3, Tulip: 2 },
  parent:   { Lily: 5, Hydrangea: 4, Sunflower: 3, Daisy: 2 },
  friend:   { Sunflower: 5, Daisy: 4, Tulip: 3, Mixed: 2 },
  self:     { Peony: 5, Orchid: 4, Lavender: 3, Ranunculus: 2 },
}

const occasionScores: Record<string, Record<string, number>> = {
  birthday:        { Sunflower: 3, Tulip: 3, Mixed: 2, Daisy: 2 },
  anniversary:     { Rose: 5, Peony: 3, Lily: 2 },
  sympathy:        { Lily: 5, Hydrangea: 3, Chrysanthemum: 3 },
  congratulations: { Sunflower: 4, Daisy: 3, Mixed: 2 },
  romance:         { Rose: 5, Tulip: 3, Peony: 3, Orchid: 2 },
  'just-because':  { Mixed: 4, Daisy: 3, Sunflower: 2, Lavender: 2 },
}

const budgetRange: Record<string, [number, number]> = {
  low: [0, 30],
  mid: [30, 60],
  high: [60, 100],
  premium: [100, Infinity],
}

const recommendations = computed(() => {
  const flowers = store.flowers
  if (!flowers.length) return []

  const [minPrice, maxPrice] = budgetRange[budget.value] ?? [0, Infinity]
  const recipientMap = typeScores[recipient.value] ?? {}
  const occasionMap = occasionScores[occasion.value] ?? {}

  const scored = flowers
    .filter(f => f.price >= minPrice && f.price <= maxPrice && f.is_available)
    .map(f => {
      const score = (recipientMap[f.type] ?? 0) + (occasionMap[f.type] ?? 0)
      return { product: f, score }
    })
    .sort((a, b) => b.score - a.score)

  return scored.slice(0, 3).map(s => s.product)
})

const getMeaning = (product: Product) => getFlowerMeaning(product)

const reset = () => {
  step.value = 1
  recipient.value = ''
  occasion.value = ''
  budget.value = ''
}

onMounted(async () => {
  if (headerRef.value && !prefersReducedMotion()) {
    gsap.from(headerRef.value, { y: 30, autoAlpha: 0, duration: 0.6, ease: 'power2.out', immediateRender: false })
  }

  if (!store.flowers.length) await store.fetchFlowers()
})
</script>
