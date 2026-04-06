<!-- Shop.vue — Product catalog with filtering by type, color, and occasion -->
<template>
  <section class="min-h-screen bg-gradient-to-b from-rose-50 via-white to-emerald-50 px-4 pt-24 pb-10 sm:px-6 lg:px-8">
    <div class="mx-auto max-w-7xl space-y-8">
      <div class="rounded-[2rem] bg-white/80 p-8 shadow-sm ring-1 ring-rose-100 backdrop-blur">
        <p class="text-sm font-semibold uppercase tracking-[0.3em] text-rose-400">Flower Shop</p>
        <div class="mt-4 flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
          <div class="max-w-2xl space-y-3">
            <h1 class="heading-serif text-4xl font-semibold tracking-tight text-rose-950 sm:text-5xl">
              Fresh blooms for every moment
            </h1>
            <p class="text-base leading-7 text-stone-600">
              Explore soft seasonal arrangements, romantic stems, and bright bouquets curated
              for gifting, celebration, and everyday beauty.
            </p>
          </div>

          <div class="rounded-3xl bg-emerald-50 px-5 py-4 text-left shadow-inner">
            <p class="text-sm text-emerald-700">Available bouquets</p>
            <p class="text-3xl font-semibold text-emerald-900">{{ filteredFlowers.length }}</p>
          </div>
        </div>
      </div>

      <FilterBar />

      <div
        v-if="loading"
        class="rounded-[2rem] border border-dashed border-rose-200 bg-white/80 px-6 py-12 shadow-sm"
      >
        <LoadingBloom />
      </div>

      <div
        v-else-if="filteredFlowers.length === 0"
        class="rounded-[2rem] border border-dashed border-emerald-200 bg-white/80 px-6 py-16 text-center shadow-sm"
      >
        <p class="text-lg font-medium text-rose-900">No flowers match those filters yet.</p>
        <p class="mt-2 text-sm text-stone-500">Try a different type or color to discover more arrangements.</p>
      </div>

      <div
        v-else
        ref="gridRef"
        class="product-grid grid gap-6 sm:grid-cols-2 xl:grid-cols-3"
      >
        <ProductCard
          v-for="flower in filteredFlowers"
          :key="flower.id"
          :product="flower"
        />
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { nextTick, onMounted, onUnmounted, ref, watch } from 'vue'
import { storeToRefs } from 'pinia'
import gsap from 'gsap'
import ScrollTrigger from 'gsap/ScrollTrigger'
import { prefersReducedMotion } from '@/animations/motion'
import FilterBar from '@/components/FilterBar.vue'
import LoadingBloom from '@/components/LoadingBloom.vue'
import ProductCard from '@/components/ProductCard.vue'
import { useFlowerStore } from '@/stores/flowers'

gsap.registerPlugin(ScrollTrigger)

const store = useFlowerStore()
const { filteredFlowers, loading } = storeToRefs(store)
const gridRef = ref<HTMLElement | null>(null)

let gridAnimation: gsap.core.Tween | null = null

const clearGridAnimation = () => {
  gridAnimation?.scrollTrigger?.kill()
  gridAnimation?.kill()
  gridAnimation = null
}

const initializeGridAnimation = async () => {
  await nextTick()
  clearGridAnimation()

  if (prefersReducedMotion() || loading.value || !gridRef.value) {
    return
  }

  const cards = gridRef.value.querySelectorAll<HTMLElement>('.product-card')

  if (cards.length === 0) {
    return
  }

  gridAnimation = gsap.from(cards, {
    scale: 0.7,
    rotation: -5,
    opacity: 0,
    duration: 0.9,
    ease: 'back.out(1.7)',
    stagger: 0.12,
    scrollTrigger: {
      trigger: gridRef.value,
      start: 'top 80%'
    }
  })
}

onMounted(() => {
  void store.fetchFlowers()
})

watch(
  [() => loading.value, () => filteredFlowers.value.map((flower) => flower.id).join(',')],
  () => {
    void initializeGridAnimation()
  }
)

onUnmounted(() => {
  clearGridAnimation()
  ScrollTrigger.getAll().forEach((trigger) => trigger.kill())
})
</script>
