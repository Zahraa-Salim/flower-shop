<template>
  <Teleport to="body">
    <Transition name="qv">
      <div v-if="isOpen && product" class="qv-overlay" @click.self="close">
        <div class="qv-modal" ref="modalRef">
          <!-- Close button -->
          <button class="qv-close" type="button" @click="close" title="Close">✕</button>

          <div class="qv-grid">
            <!-- Image -->
            <div class="qv-image-wrap">
              <img
                :src="product.image_url || fallback"
                :alt="product.name"
                class="qv-image"
              />
              <div class="qv-tags">
                <span class="qv-tag qv-tag--type">{{ product.type }}</span>
                <span class="qv-tag qv-tag--color">{{ product.color }}</span>
              </div>
            </div>

            <!-- Details -->
            <div class="qv-details">
              <h2 class="qv-name">{{ product.name }}</h2>
              <p class="qv-price">${{ product.price.toFixed(2) }}</p>

              <!-- Flower meaning -->
              <div class="qv-meaning">
                <span class="qv-meaning__icon">✿</span>
                <p class="qv-meaning__text">{{ meaning }}</p>
              </div>

              <p class="qv-desc">{{ product.description }}</p>

              <p class="qv-stock" :class="isInStock ? 'qv-stock--in' : 'qv-stock--out'">
                {{ isInStock ? `${product.stock} in stock` : 'Out of stock' }}
              </p>

              <!-- Quantity + Add to Cart -->
              <div class="qv-actions">
                <div class="qv-qty">
                  <button type="button" :disabled="qty <= 1" @click="qty--">−</button>
                  <span>{{ qty }}</span>
                  <button type="button" :disabled="qty >= maxQty" @click="qty++">+</button>
                </div>
                <button
                  class="qv-add-btn"
                  type="button"
                  :disabled="!isInStock"
                  @click="addToCart"
                >
                  Add to Cart
                </button>
              </div>

              <RouterLink
                :to="`/product/${product.id}`"
                class="qv-full-link"
                @click="close"
              >
                View Full Details →
              </RouterLink>
            </div>
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { useQuickView } from '@/composables/useQuickView'
import { useCartStore } from '@/stores/cart'
import { getFlowerMeaning } from '@/composables/useFlowerMeaning'

const { product, isOpen, close } = useQuickView()
const cartStore = useCartStore()
const modalRef = ref<HTMLElement | null>(null)

const fallback = 'https://images.unsplash.com/photo-1525310072745-f49212b5ac6d?auto=format&fit=crop&w=900&q=80'

const qty = ref(1)
const isInStock = computed(() => !!product.value && product.value.stock > 0)
const maxQty = computed(() => product.value ? Math.min(product.value.stock, 10) : 1)
const meaning = computed(() => product.value ? getFlowerMeaning(product.value) : '')

// Reset qty when a new product is opened
watch(product, () => { qty.value = 1 })

// Lock body scroll when modal is open
watch(isOpen, (open) => {
  document.body.style.overflow = open ? 'hidden' : ''
})

const addToCart = () => {
  if (!product.value || !isInStock.value) return
  cartStore.addToCart({
    id: product.value.id,
    name: product.value.name,
    image_url: product.value.image_url,
    price: product.value.price,
    quantity: qty.value
  })
  close()
}
</script>

<style scoped>
.qv-overlay {
  position: fixed;
  inset: 0;
  z-index: 999;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(30, 15, 15, 0.45);
  backdrop-filter: blur(8px);
  padding: 20px;
}

.qv-modal {
  position: relative;
  width: 100%;
  max-width: 820px;
  max-height: 90vh;
  overflow-y: auto;
  background: rgba(255, 252, 248, 0.98);
  border-radius: 2rem;
  box-shadow: 0 24px 80px rgba(80, 20, 20, 0.18);
  border: 1px solid rgba(197, 104, 122, 0.12);
}

.qv-close {
  position: absolute;
  top: 16px;
  right: 16px;
  z-index: 10;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  border: none;
  background: rgba(255, 248, 244, 0.9);
  color: #5a3535;
  font-size: 0.9rem;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
}

.qv-close:hover {
  background: #c5687a;
  color: white;
  transform: scale(1.1);
}

.qv-grid {
  display: grid;
  grid-template-columns: 1fr;
}

@media (min-width: 640px) {
  .qv-grid {
    grid-template-columns: 1fr 1fr;
  }
}

.qv-image-wrap {
  position: relative;
  overflow: hidden;
  border-radius: 2rem 2rem 0 0;
}

@media (min-width: 640px) {
  .qv-image-wrap {
    border-radius: 2rem 0 0 2rem;
  }
}

.qv-image {
  width: 100%;
  height: 100%;
  min-height: 280px;
  object-fit: cover;
}

.qv-tags {
  position: absolute;
  top: 16px;
  left: 16px;
  display: flex;
  gap: 6px;
}

.qv-tag {
  font-size: 0.68rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.12em;
  padding: 4px 10px;
  border-radius: 100px;
  backdrop-filter: blur(8px);
}

.qv-tag--type {
  background: rgba(209, 250, 229, 0.85);
  color: #065f46;
}

.qv-tag--color {
  background: rgba(255, 228, 230, 0.85);
  color: #9f1239;
}

.qv-details {
  padding: 28px 24px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.qv-name {
  font-family: 'Cormorant Garamond', Georgia, serif;
  font-size: 1.8rem;
  font-weight: 600;
  color: #2d1a1a;
  line-height: 1.2;
}

.qv-price {
  font-family: 'Cormorant Garamond', Georgia, serif;
  font-size: 1.4rem;
  font-weight: 600;
  color: #2d6a4f;
}

.qv-meaning {
  display: flex;
  gap: 8px;
  align-items: flex-start;
  background: linear-gradient(135deg, rgba(255, 228, 230, 0.4), rgba(255, 243, 224, 0.3));
  border: 1px solid rgba(197, 104, 122, 0.12);
  border-radius: 14px;
  padding: 10px 12px;
}

.qv-meaning__icon {
  font-size: 1rem;
  flex-shrink: 0;
  margin-top: 1px;
}

.qv-meaning__text {
  font-family: 'Cormorant Garamond', Georgia, serif;
  font-size: 0.82rem;
  font-style: italic;
  color: #6b4040;
  line-height: 1.5;
}

.qv-desc {
  font-size: 0.88rem;
  color: #6b6b6b;
  line-height: 1.65;
}

.qv-stock {
  font-size: 0.82rem;
  font-weight: 600;
}

.qv-stock--in { color: #2d6a4f; }
.qv-stock--out { color: #c5303f; }

.qv-actions {
  display: flex;
  gap: 10px;
  align-items: center;
  margin-top: 4px;
}

.qv-qty {
  display: inline-flex;
  align-items: center;
  border: 1px solid rgba(197, 104, 122, 0.25);
  border-radius: 100px;
  overflow: hidden;
}

.qv-qty button {
  width: 36px;
  height: 36px;
  border: none;
  background: transparent;
  color: #5a3535;
  font-size: 1rem;
  cursor: pointer;
  transition: background 0.15s;
}

.qv-qty button:hover:not(:disabled) {
  background: rgba(197, 104, 122, 0.08);
}

.qv-qty button:disabled {
  color: #ccc;
  cursor: not-allowed;
}

.qv-qty span {
  min-width: 32px;
  text-align: center;
  font-weight: 600;
  font-size: 0.9rem;
  color: #2d1a1a;
}

.qv-add-btn {
  flex: 1;
  padding: 10px 20px;
  border: none;
  border-radius: 100px;
  background: #c5687a;
  color: white;
  font-family: 'Cormorant Garamond', Georgia, serif;
  font-size: 0.92rem;
  font-weight: 600;
  letter-spacing: 0.04em;
  cursor: pointer;
  transition: all 0.25s cubic-bezier(0.34, 1.56, 0.64, 1);
  box-shadow: 0 4px 16px rgba(197, 104, 122, 0.3);
}

.qv-add-btn:hover:not(:disabled) {
  background: #b05568;
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(197, 104, 122, 0.4);
}

.qv-add-btn:disabled {
  background: #e0d0d0;
  cursor: not-allowed;
  box-shadow: none;
}

.qv-full-link {
  font-family: 'Cormorant Garamond', Georgia, serif;
  font-size: 0.82rem;
  color: #c5687a;
  text-decoration: none;
  font-weight: 600;
  letter-spacing: 0.06em;
  transition: color 0.2s;
  align-self: flex-start;
}

.qv-full-link:hover {
  color: #8b3a4a;
}

/* ── Transition ── */
.qv-enter-active {
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}
.qv-leave-active {
  transition: all 0.2s ease-in;
}
.qv-enter-from,
.qv-leave-to {
  opacity: 0;
}
.qv-enter-from .qv-modal,
.qv-leave-to .qv-modal {
  transform: scale(0.92);
  opacity: 0;
}
</style>
