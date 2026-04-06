<template>
  <section class="min-h-screen bg-gradient-to-b from-rose-50 via-white to-emerald-50 px-4 pt-24 pb-10 sm:px-6 lg:px-8">
    <div class="mx-auto max-w-6xl">
      <button
        class="inline-flex items-center rounded-full border border-rose-200 bg-white px-4 py-2 text-sm font-medium text-rose-900 shadow-sm transition hover:bg-rose-50"
        type="button"
        @click="goBack"
      >
        Back to Shop
      </button>

      <div
        v-if="loading"
        class="mt-8 rounded-[2rem] bg-white/80 p-8 shadow-sm ring-1 ring-rose-100"
      >
        <LoadingBloom
          title="Loading product details..."
          description="Unwrapping the bouquet details, pricing, and care notes."
        />
      </div>

      <div
        v-else-if="!product"
        class="mt-8 rounded-[2rem] bg-white/85 p-10 text-center shadow-sm ring-1 ring-rose-100"
      >
        <h1 class="text-3xl font-semibold text-rose-950">Product not found</h1>
        <p class="mt-3 text-base text-stone-600">
          We couldn’t find the flower you were looking for. It may have been removed or the link may be incorrect.
        </p>
        <button
          class="mt-6 rounded-full bg-rose-200 px-6 py-3 text-sm font-semibold text-rose-950 transition hover:bg-rose-300"
          type="button"
          @click="goBack"
        >
          Back to Shop
        </button>
      </div>

      <div
        v-else
        class="mt-8 space-y-8"
      >
        <div class="grid gap-8 rounded-[2rem] bg-white/85 p-6 shadow-sm ring-1 ring-rose-100 lg:grid-cols-[1.05fr_0.95fr] lg:p-8">
          <div class="overflow-hidden rounded-[1.75rem] bg-rose-50">
            <OptimizedImage
              :src="product.image_url || fallbackImage"
              :alt="product.name"
              img-class="h-full w-full object-cover"
              loading="eager"
            />
          </div>

          <div
            ref="detailContentRef"
            class="flex flex-col justify-between"
          >
            <div class="space-y-6">
              <div class="space-y-3">
                <div class="flex flex-wrap gap-2 text-xs font-semibold uppercase tracking-[0.2em]">
                  <span class="rounded-full bg-emerald-50 px-3 py-1 text-emerald-700">
                    {{ product.type }}
                  </span>
                  <span class="rounded-full bg-rose-50 px-3 py-1 text-rose-500">
                    {{ product.color }}
                  </span>
                </div>

                <h1 class="heading-serif text-4xl font-semibold tracking-tight text-rose-950">
                  {{ product.name }}
                </h1>

                <p
                  ref="priceRef"
                  class="text-3xl font-semibold text-emerald-700"
                >
                  ${{ formattedPrice }}
                </p>
              </div>

              <p
                ref="descriptionRef"
                class="text-base leading-7 text-stone-600"
              >
                {{ product.description }}
              </p>

              <div class="rounded-3xl border border-rose-100 bg-gradient-to-br from-rose-50 to-amber-50/40 p-5">
                <div class="flex items-start gap-3">
                  <span class="mt-0.5 text-lg">✿</span>
                  <div>
                    <p class="text-xs font-semibold uppercase tracking-[0.2em] text-rose-400">Flower Language</p>
                    <p class="mt-1.5 text-sm leading-relaxed text-stone-600 italic">{{ flowerMeaning }}</p>
                  </div>
                </div>
              </div>

              <div class="rounded-3xl bg-rose-50 p-4">
                <p class="text-sm font-medium text-stone-500">Availability</p>
                <p
                  :class="isInStock ? 'text-emerald-700' : 'text-rose-600'"
                  class="mt-1 text-lg font-semibold"
                >
                  {{ isInStock ? 'In Stock' : 'Out of Stock' }}
                </p>
              </div>

              <div class="space-y-3">
                <p class="text-sm font-medium uppercase tracking-[0.18em] text-stone-500">Quantity</p>
                <div class="inline-flex items-center rounded-full border border-rose-200 bg-white shadow-sm">
                  <button
                    class="h-11 w-11 rounded-full text-xl text-rose-900 transition hover:bg-rose-50 disabled:cursor-not-allowed disabled:text-stone-300"
                    type="button"
                    :disabled="quantity <= 1 || !isInStock"
                    @click="decreaseQuantity"
                  >
                    -
                  </button>
                  <span class="min-w-12 px-4 text-center text-base font-semibold text-rose-950">
                    {{ quantity }}
                  </span>
                  <button
                    class="h-11 w-11 rounded-full text-xl text-rose-900 transition hover:bg-rose-50 disabled:cursor-not-allowed disabled:text-stone-300"
                    type="button"
                    :disabled="!isInStock || quantity >= maxQuantity"
                    @click="increaseQuantity"
                  >
                    +
                  </button>
                </div>
                <p class="text-sm text-stone-500">
                  {{ isInStock ? `${product.stock} stems available today.` : 'Currently unavailable.' }}
                </p>
              </div>

              <button
                ref="addToCartButtonRef"
                class="w-full rounded-full bg-rose-300 px-6 py-4 text-base font-semibold text-rose-950 transition hover:bg-rose-400 disabled:cursor-not-allowed disabled:bg-rose-100 disabled:text-stone-400"
                type="button"
                :disabled="!isInStock"
                @click="addToCart"
              >
                Add to Cart
              </button>
            </div>

            <!-- Reviews section will go here later. -->
          </div>
        </div>

        <section class="rounded-[2rem] bg-white/90 p-6 shadow-sm ring-1 ring-rose-100 sm:p-8">
          <div class="flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between">
            <div>
              <p class="text-sm font-semibold uppercase tracking-[0.3em] text-rose-400">Customer Notes</p>
              <h2 class="mt-2 text-3xl font-semibold text-rose-950">Reviews</h2>
            </div>

            <p class="text-sm text-stone-500">
              {{ reviews.length }} {{ reviews.length === 1 ? 'review' : 'reviews' }}
            </p>
          </div>

          <div
            v-if="isLoggedIn"
            class="mt-8 rounded-[2rem] bg-rose-50 p-5"
          >
            <h3 class="text-xl font-semibold text-rose-950">Write a Review</h3>

            <form
              class="mt-5 space-y-4"
              @submit.prevent="submitReview"
            >
              <div class="space-y-2">
                <p class="text-sm font-medium text-rose-900">Your Rating</p>
                <div class="flex flex-wrap gap-2">
                  <button
                    v-for="star in [1, 2, 3, 4, 5]"
                    :key="star"
                    class="rounded-full px-4 py-2 text-sm font-semibold transition"
                    :class="reviewRating >= star ? 'bg-rose-300 text-rose-950' : 'bg-white text-stone-500 hover:bg-rose-100'"
                    type="button"
                    @click="reviewRating = star"
                  >
                    {{ star }} Star{{ star > 1 ? 's' : '' }}
                  </button>
                </div>
              </div>

              <label class="block space-y-2">
                <span class="text-sm font-medium text-rose-900">Comment</span>
                <textarea
                  v-model="reviewComment"
                  class="min-h-28 w-full rounded-2xl border border-rose-200 bg-white px-4 py-3 text-rose-950 outline-none transition placeholder:text-stone-400 focus:border-rose-300"
                  placeholder="Share what you loved about this bouquet"
                  required
                />
              </label>

              <p
                v-if="reviewErrorMessage"
                class="rounded-2xl bg-white px-4 py-3 text-sm font-medium text-rose-700"
              >
                {{ reviewErrorMessage }}
              </p>

              <button
                class="rounded-full bg-rose-300 px-6 py-3 text-sm font-semibold text-rose-950 transition hover:bg-rose-400 disabled:cursor-not-allowed disabled:bg-rose-100 disabled:text-stone-400"
                type="submit"
                :disabled="reviewsLoading || reviewSubmitting"
              >
                {{ reviewSubmitting ? 'Posting Review...' : 'Submit Review' }}
              </button>
            </form>
          </div>

          <div
            v-else
            class="mt-8 rounded-[2rem] bg-rose-50 px-5 py-6 text-center"
          >
            <p class="text-sm text-stone-600">Log in to leave a review for this bouquet.</p>
          </div>
          <div
            v-if="reviewsLoading"
            class="mt-8 flex items-center justify-center py-12"
          >
            <div class="h-10 w-10 animate-spin rounded-full border-4 border-rose-100 border-t-rose-400"></div>
          </div>

          <div
            v-else-if="reviews.length === 0"
            class="mt-8 rounded-[2rem] bg-rose-50 px-5 py-8 text-center"
          >
            <p class="text-base font-medium text-rose-900">No reviews yet</p>
            <p class="mt-2 text-sm text-stone-500">Be the first to share your experience with this bouquet.</p>
          </div>

          <div
            v-else
            class="mt-8 space-y-4"
          >
            <article
              v-for="review in reviews"
              :key="review.id"
              class="rounded-[1.75rem] bg-rose-50 p-5"
            >
              <div class="flex flex-col gap-3 sm:flex-row sm:items-start sm:justify-between">
                <div>
                  <p class="text-lg font-semibold text-rose-950">{{ getReviewerName(review) }}</p>
                  <div class="mt-2 flex items-center gap-1">
                    <span
                      v-for="star in 5"
                      :key="star"
                      class="text-lg"
                      :class="star <= review.rating ? 'text-amber-400' : 'text-rose-200'"
                    >
                      ★
                    </span>
                  </div>
                </div>

                <p class="text-sm text-stone-500">{{ formatReviewDate(review.created_at) }}</p>
              </div>

              <p class="mt-4 text-base leading-7 text-stone-600">
                {{ review.comment }}
              </p>
            </article>
          </div>
        </section>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { computed, nextTick, onMounted, onUnmounted, ref, watch } from 'vue'
import { storeToRefs } from 'pinia'
import gsap from 'gsap'
import ScrollTrigger from 'gsap/ScrollTrigger'
import { useRoute, useRouter } from 'vue-router'
import { prefersReducedMotion } from '@/animations/motion'
import LoadingBloom from '@/components/LoadingBloom.vue'
import OptimizedImage from '@/components/OptimizedImage.vue'
import type { Product } from '@/stores/flowers'
import { supabase } from '@/lib/supabase'
import { useCartStore } from '@/stores/cart'
import { useAuthStore } from '@/stores/auth'
import { getFlowerMeaning } from '@/composables/useFlowerMeaning'
import { useMagneticButton } from '@/composables/useMagneticButton'

gsap.registerPlugin(ScrollTrigger)

interface ReviewUser {
  full_name: string | null
}

interface Review {
  id: number
  product_id: number
  user_id: string
  rating: number
  comment: string
  created_at: string
  users: ReviewUser | ReviewUser[] | null
}

const fallbackImage =
  'https://images.unsplash.com/photo-1525310072745-f49212b5ac6d?auto=format&fit=crop&w=1200&q=80'

const route = useRoute()
const router = useRouter()
const cartStore = useCartStore()
const authStore = useAuthStore()
const { isLoggedIn, user } = storeToRefs(authStore)

const product = ref<Product | null>(null)
const loading = ref(true)
const quantity = ref(1)
const reviews = ref<Review[]>([])
const reviewsLoading = ref(false)
const reviewSubmitting = ref(false)
const reviewRating = ref(5)
const reviewComment = ref('')
const reviewErrorMessage = ref('')
const detailContentRef = ref<HTMLElement | null>(null)
const descriptionRef = ref<HTMLElement | null>(null)
const priceRef = ref<HTMLElement | null>(null)
const addToCartButtonRef = ref<HTMLElement | null>(null)

useMagneticButton(addToCartButtonRef)

let revealContext: gsap.Context | null = null

const maxQuantity = computed(() => {
  if (!product.value || product.value.stock < 1) {
    return 1
  }

  return product.value.stock
})

const isInStock = computed(() => {
  if (!product.value) {
    return false
  }

  return product.value.is_available && product.value.stock > 0
})

const formattedPrice = computed(() => {
  if (!product.value) {
    return '0.00'
  }

  return product.value.price.toFixed(2)
})

const flowerMeaning = computed(() => {
  if (!product.value) return ''
  return getFlowerMeaning(product.value)
})

const goBack = () => {
  void router.push('/shop')
}

const decreaseQuantity = () => {
  quantity.value = Math.max(1, quantity.value - 1)
}

const increaseQuantity = () => {
  quantity.value = Math.min(maxQuantity.value, quantity.value + 1)
}

const addToCart = () => {
  if (!product.value || !isInStock.value) {
    return
  }

  cartStore.addToCart({
    id: product.value.id,
    name: product.value.name,
    image_url: product.value.image_url,
    price: product.value.price,
    quantity: quantity.value
  })
}

const getCurrentProductId = () => {
  const routeId = Array.isArray(route.params.id) ? route.params.id[0] : route.params.id
  return Number(routeId)
}

const getReviewerName = (review: Review) => {
  if (Array.isArray(review.users)) {
    return review.users[0]?.full_name || 'Flower Lover'
  }

  return review.users?.full_name || 'Flower Lover'
}

const formatReviewDate = (value: string) =>
  new Date(value).toLocaleDateString(undefined, {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })

const fetchReviews = async () => {
  const id = getCurrentProductId()

  if (!Number.isFinite(id)) {
    reviews.value = []
    return
  }

  reviewsLoading.value = true

  const { data } = await supabase
    .from('reviews')
    .select('*, users(full_name)')
    .eq('product_id', id)

  reviews.value = (data as Review[] | null) ?? []
  reviewsLoading.value = false
}

const submitReview = async () => {
  const id = getCurrentProductId()

  if (!user.value || !Number.isFinite(id)) {
    reviewErrorMessage.value = 'Please log in to submit a review.'
    return
  }

  reviewSubmitting.value = true
  reviewErrorMessage.value = ''

  const { error } = await supabase.from('reviews').insert({
    user_id: user.value.id,
    product_id: id,
    rating: reviewRating.value,
    comment: reviewComment.value
  })

  if (error) {
    reviewErrorMessage.value = error.message
    reviewSubmitting.value = false
    return
  }

  reviewComment.value = ''
  reviewRating.value = 5
  await fetchReviews()
  reviewSubmitting.value = false
}

const fetchProduct = async () => {
  loading.value = true
  product.value = null
  quantity.value = 1

  const id = getCurrentProductId()

  if (!Number.isFinite(id)) {
    loading.value = false
    return
  }

  const { data } = await supabase.from('products').select('*').eq('id', id).single()

  product.value = data as Product | null
  loading.value = false
}

const initializeDetailReveal = async () => {
  await nextTick()

  revealContext?.revert()
  ScrollTrigger.getAll().forEach((trigger) => trigger.kill())

  if (prefersReducedMotion() || !detailContentRef.value) {
    return
  }

  revealContext = gsap.context(() => {
    ;[
      { element: descriptionRef.value, delay: 0 },
      { element: priceRef.value, delay: 0.12 },
      { element: addToCartButtonRef.value, delay: 0.24 }
    ].forEach(({ element, delay }) => {
      if (!element) {
        return
      }

      gsap.from(element, {
        y: 40,
        opacity: 0,
        duration: 0.7,
        delay,
        ease: 'power2.out',
        scrollTrigger: {
          trigger: element,
          start: 'top 85%'
        }
      })
    })
  }, detailContentRef.value)
}

onMounted(() => {
  void fetchProduct()
  void fetchReviews()
})

watch(product, (value) => {
  if (!value) {
    return
  }

  void initializeDetailReveal()
})

onUnmounted(() => {
  revealContext?.revert()
  ScrollTrigger.getAll().forEach((trigger) => trigger.kill())
})
</script>
