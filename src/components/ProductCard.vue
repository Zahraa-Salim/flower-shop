<!-- ProductCard.vue — Dark overlay product card with hover animations and flower meaning -->
<template>
  <article
    ref="cardRef"
    class="pcard"
    @click="quickView"
    @mouseenter="onEnter"
    @mouseleave="onLeave"
  >
    <!-- ── Image wrapper ── -->
    <div class="pcard__img-wrap">
      <OptimizedImage
        :src="product.image_url || fallback"
        :alt="product.name"
        img-class="pcard__img"
        loading="lazy"
      />

      <!-- Gradient overlay -->
      <div class="pcard__overlay" />

      <!-- Color dot + type pill — top left -->
      <div class="pcard__top-left">
        <span class="pcard__color-dot" :style="{ background: colorMap[product.color] || '#c5687a' }" />
        <span class="pcard__type-pill">{{ product.type }}</span>
      </div>

      <!-- Wishlist icon — top right -->
      <button class="pcard__wish" type="button" @click.stop="toggleWish">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
          <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
        </svg>
      </button>

      <!-- Bottom info panel (floats over image) -->
      <div class="pcard__info">
        <div class="pcard__name-row">
          <h2 class="pcard__name">{{ product.name }}</h2>
          <p class="pcard__price">${{ formattedPrice }}</p>
        </div>
        <p class="pcard__meaning">{{ meaning }}</p>

        <!-- Add to cart — slides up on hover -->
        <div ref="cartBtnWrap" class="pcard__cart-wrap">
          <button
            class="pcard__cart-btn"
            type="button"
            @click.stop="addToCart"
          >
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/>
              <line x1="3" y1="6" x2="21" y2="6"/>
              <path d="M16 10a4 4 0 0 1-8 0"/>
            </svg>
            Add to Cart
          </button>
        </div>
      </div>
    </div>

    <!-- ── Added to cart feedback ── -->
    <Transition name="toast">
      <div v-if="showToast" class="pcard__toast">✓ Added</div>
    </Transition>
  </article>
</template>

<script setup lang="ts">
import { computed, onUnmounted, ref } from 'vue'
import gsap from 'gsap'
import { prefersReducedMotion } from '@/animations/motion'
import OptimizedImage from '@/components/OptimizedImage.vue'
import type { Product } from '@/stores/flowers'
import { useCartStore } from '@/stores/cart'
import { useWishlistStore } from '@/stores/wishlist'
import { useQuickView } from '@/composables/useQuickView'
import { getFlowerMeaning } from '@/composables/useFlowerMeaning'

const props = defineProps<{ product: Product }>()

const fallback = 'https://images.unsplash.com/photo-1525310072745-f49212b5ac6d?auto=format&fit=crop&w=900&q=80'

const cartStore     = useCartStore()
const wishlistStore = useWishlistStore()
const { open: openQuickView } = useQuickView()
const cardRef     = ref<HTMLElement | null>(null)
const cartBtnWrap = ref<HTMLElement | null>(null)
const showToast   = ref(false)

const formattedPrice = computed(() => props.product.price.toFixed(2))
const meaning = computed(() => getFlowerMeaning(props.product))

// Map color names → hex dots
const colorMap: Record<string, string> = {
  Red: '#c0392b', Pink: '#e91e8c', White: '#f5f5f0', Yellow: '#f4d03f',
  Purple: '#8e44ad', Orange: '#e67e22', Coral: '#e8735a', Blue: '#2980b9',
  Mixed: 'linear-gradient(135deg,#e91e8c,#f4d03f,#2980b9)', Blush: '#e8a0b4',
  Lavender: '#967bb6', Green: '#27ae60',
}

const quickView = () => openQuickView(props.product)

const toggleWish = () => { wishlistStore.toggleWishlist(props.product.id) }

const addToCart = () => {
  cartStore.addToCart(props.product)
  showToast.value = true
  setTimeout(() => { showToast.value = false }, 1600)
}

const onEnter = () => {
  if (prefersReducedMotion()) return
  if (cardRef.value) {
    gsap.to(cardRef.value, { y: -10, duration: 0.35, ease: 'power2.out' })
  }
  if (cartBtnWrap.value) {
    gsap.to(cartBtnWrap.value, { y: 0, opacity: 1, duration: 0.38, ease: 'back.out(1.7)' })
  }
}

const onLeave = () => {
  if (prefersReducedMotion()) return
  if (cardRef.value) {
    gsap.to(cardRef.value, { y: 0, duration: 0.5, ease: 'elastic.out(1,0.5)' })
  }
  if (cartBtnWrap.value) {
    gsap.to(cartBtnWrap.value, { y: '100%', opacity: 0, duration: 0.25, ease: 'power2.in' })
  }
}

onUnmounted(() => {
  if (cardRef.value)     gsap.killTweensOf(cardRef.value)
  if (cartBtnWrap.value) gsap.killTweensOf(cartBtnWrap.value)
})
</script>

<style scoped>
/* ── Card shell ── */
.pcard {
  position: relative;
  cursor: pointer;
  border-radius: 24px;
  overflow: hidden;
  background: #1a0e0e;
  box-shadow: 0 8px 32px rgba(45, 26, 26, 0.14);
  transition: box-shadow 0.35s ease;
  will-change: transform;
}

.pcard:hover {
  box-shadow: 0 24px 64px rgba(45, 26, 26, 0.28), 0 4px 16px rgba(197,104,122,0.2);
}

/* ── Image ── */
.pcard__img-wrap {
  position: relative;
  aspect-ratio: 1 / 1;
  overflow: hidden;
}

.pcard__img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  transition: transform 0.7s cubic-bezier(0.25,0.46,0.45,0.94);
}

.pcard:hover .pcard__img {
  transform: scale(1.07);
}

/* ── Gradient overlay ── */
.pcard__overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(
    to bottom,
    transparent 35%,
    rgba(20, 8, 8, 0.35) 60%,
    rgba(20, 8, 8, 0.82) 100%
  );
  transition: opacity 0.35s ease;
}

.pcard:hover .pcard__overlay {
  opacity: 1.15;
}

/* ── Top left pill ── */
.pcard__top-left {
  position: absolute;
  top: 14px;
  left: 14px;
  display: flex;
  align-items: center;
  gap: 7px;
  background: rgba(255,252,248,0.18);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border: 1px solid rgba(255,255,255,0.22);
  border-radius: 100px;
  padding: 5px 12px 5px 8px;
}

.pcard__color-dot {
  width: 9px;
  height: 9px;
  border-radius: 50%;
  flex-shrink: 0;
  border: 1.5px solid rgba(255,255,255,0.4);
}

.pcard__type-pill {
  font-family: 'Inter', sans-serif;
  font-size: 0.68rem;
  font-weight: 600;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: rgba(255,252,248,0.92);
}

/* ── Wishlist ── */
.pcard__wish {
  position: absolute;
  top: 12px;
  right: 12px;
  width: 34px;
  height: 34px;
  border-radius: 50%;
  background: rgba(255,252,248,0.18);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border: 1px solid rgba(255,255,255,0.22);
  color: rgba(255,252,248,0.85);
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.25s cubic-bezier(0.34,1.56,0.64,1);
}

.pcard__wish:hover {
  background: rgba(197,104,122,0.75);
  border-color: rgba(197,104,122,0.5);
  transform: scale(1.15);
  color: white;
}

/* ── Info panel ── */
.pcard__info {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 16px 18px 18px;
}

.pcard__name-row {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 8px;
  margin-bottom: 10px;
}

.pcard__name {
  font-family: 'Cormorant Garamond', 'Playfair Display', Georgia, serif;
  font-size: 1.15rem;
  font-weight: 500;
  color: rgba(255,252,248,0.95);
  line-height: 1.2;
  margin: 0;
  flex: 1;
}

.pcard__price {
  font-family: 'Cormorant Garamond', 'Playfair Display', Georgia, serif;
  font-size: 1.2rem;
  font-weight: 600;
  color: #e8a0b4;
  margin: 0;
  white-space: nowrap;
}

/* ── Flower meaning ── */
.pcard__meaning {
  font-family: 'Cormorant Garamond', 'Playfair Display', Georgia, serif;
  font-size: 0.78rem;
  font-style: italic;
  color: rgba(255, 252, 248, 0.55);
  margin: 0 0 6px;
  line-height: 1.4;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-height: 0;
  opacity: 0;
  transition: max-height 0.35s ease, opacity 0.3s ease;
}

.pcard:hover .pcard__meaning {
  max-height: 2em;
  opacity: 1;
}

/* ── Cart button (slides up on hover) ── */
.pcard__cart-wrap {
  transform: translateY(100%);
  opacity: 0;
  will-change: transform, opacity;
}

.pcard__cart-btn {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 11px 20px;
  background: rgba(255,252,248,0.95);
  color: #1e0f0f;
  border: none;
  border-radius: 100px;
  font-family: 'Inter', sans-serif;
  font-size: 0.82rem;
  font-weight: 600;
  letter-spacing: 0.04em;
  cursor: pointer;
  transition: background 0.2s ease, transform 0.2s ease;
}

.pcard__cart-btn:hover {
  background: #fff;
  transform: scale(1.02);
}

/* ── Toast ── */
.pcard__toast {
  position: absolute;
  top: 12px;
  left: 50%;
  transform: translateX(-50%);
  background: #2d4a2a;
  color: white;
  font-family: 'Inter', sans-serif;
  font-size: 0.75rem;
  font-weight: 600;
  letter-spacing: 0.06em;
  padding: 6px 16px;
  border-radius: 100px;
  pointer-events: none;
  white-space: nowrap;
  z-index: 10;
}

.toast-enter-active { transition: all 0.3s cubic-bezier(0.34,1.56,0.64,1); }
.toast-leave-active { transition: all 0.25s ease; }
.toast-enter-from   { opacity: 0; transform: translateX(-50%) translateY(-10px) scale(0.85); }
.toast-leave-to     { opacity: 0; transform: translateX(-50%) translateY(-6px); }
</style>
