<!-- Wishlist.vue — Saved favorite products grid -->
<template>
  <section class="min-h-screen bg-gradient-to-b from-rose-50 via-white to-emerald-50 px-4 py-10 sm:px-6 lg:px-8">
    <div class="mx-auto max-w-7xl pt-20">
      <div ref="headerRef" class="mb-10 text-center">
        <p class="text-sm font-semibold uppercase tracking-[0.3em] text-rose-400">Your Favourites</p>
        <h1 class="heading-serif mt-3 text-4xl font-semibold text-rose-950 sm:text-5xl">Wishlist</h1>
        <p class="mt-3 text-base text-stone-500">
          {{ wishlisted.length }} {{ wishlisted.length === 1 ? 'flower' : 'flowers' }} saved
        </p>
      </div>

      <div v-if="loading" class="rounded-[2rem] bg-white/80 p-10 shadow-sm ring-1 ring-rose-100">
        <LoadingBloom title="Loading your wishlist..." description="Gathering your favourite blooms." />
      </div>

      <div
        v-else-if="wishlisted.length === 0"
        class="rounded-[2rem] bg-white/85 p-12 text-center shadow-sm ring-1 ring-rose-100"
      >
        <p class="text-5xl">♡</p>
        <h2 class="mt-4 text-2xl font-semibold text-rose-950">No favourites yet</h2>
        <p class="mt-2 text-base text-stone-500">
          Tap the heart on any flower to save it here.
        </p>
        <RouterLink
          to="/shop"
          class="mt-6 inline-block rounded-full bg-rose-200 px-6 py-3 text-sm font-semibold text-rose-950 transition hover:bg-rose-300"
        >
          Browse Flowers
        </RouterLink>
      </div>

      <div v-else class="grid gap-6 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
        <ProductCard
          v-for="product in wishlisted"
          :key="product.id"
          :product="product"
        />
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { storeToRefs } from 'pinia'
import { useWishlistStore } from '@/stores/wishlist'
import { useFlowerStore } from '@/stores/flowers'
import LoadingBloom from '@/components/LoadingBloom.vue'
import ProductCard from '@/components/ProductCard.vue'
import gsap from 'gsap'
import { prefersReducedMotion } from '@/animations/motion'

const wishlistStore = useWishlistStore()
const flowerStore = useFlowerStore()
const { productIds } = storeToRefs(wishlistStore)

const headerRef = ref<HTMLElement | null>(null)
const loading = ref(true)

const wishlisted = computed(() =>
  flowerStore.flowers.filter(f => productIds.value.includes(f.id))
)

onMounted(async () => {
  if (headerRef.value && !prefersReducedMotion()) {
    gsap.from(headerRef.value, { y: 30, autoAlpha: 0, duration: 0.6, ease: 'power2.out', immediateRender: false })
  }

  await Promise.all([
    wishlistStore.fetchWishlist(),
    flowerStore.flowers.length === 0 ? flowerStore.fetchFlowers() : Promise.resolve()
  ])
  loading.value = false
})
</script>
