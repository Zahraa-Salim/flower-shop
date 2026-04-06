<!-- SocialProofToast.vue — Animated toast showing recent order notifications -->
<template>
  <Transition name="social-toast">
    <div
      v-if="visible && currentProof"
      class="social-toast"
      @mouseenter="pauseAutoHide"
      @mouseleave="resumeAutoHide"
    >
      <button class="social-toast__close" type="button" @click="dismiss">✕</button>
      <div class="social-toast__content">
        <div class="social-toast__avatar">🌸</div>
        <div>
          <p class="social-toast__text">
            <strong>{{ currentProof.name }}</strong> just ordered
          </p>
          <p class="social-toast__product">{{ currentProof.product }}</p>
          <p class="social-toast__time">{{ currentProof.timeAgo }}</p>
        </div>
      </div>
    </div>
  </Transition>
</template>

<script setup lang="ts">
import { onMounted, onUnmounted, ref } from 'vue'

interface ProofItem {
  name: string
  product: string
  timeAgo: string
}

const names = ['Sophie', 'Emma', 'Liam', 'Olivia', 'Noah', 'Ava', 'Mia', 'Ethan', 'Isabella', 'Lucas']
const products = [
  'Rose Bouquet', 'Spring Tulips', 'Sunflower Arrangement', 'Lily Collection',
  'Peony Garden', 'Orchid Elegance', 'Wildflower Mix', 'Lavender Dream',
  'Daisy Charm', 'Custom Bouquet'
]
const times = ['just now', '2 min ago', '5 min ago', '8 min ago', '12 min ago']

const visible = ref(false)
const muted = ref(false)
const currentProof = ref<ProofItem | null>(null)

let showTimer: ReturnType<typeof setTimeout> | null = null
let hideTimer: ReturnType<typeof setTimeout> | null = null
let cycleTimer: ReturnType<typeof setInterval> | null = null

function randomItem<T>(arr: T[]): T {
  return arr[Math.floor(Math.random() * arr.length)]
}

function generateProof(): ProofItem {
  return {
    name: randomItem(names),
    product: randomItem(products),
    timeAgo: randomItem(times),
  }
}

function showProof() {
  if (muted.value) return
  currentProof.value = generateProof()
  visible.value = true
  hideTimer = setTimeout(() => { visible.value = false }, 5000)
}

function dismiss() {
  visible.value = false
  muted.value = true
  if (cycleTimer) clearInterval(cycleTimer)
}

function pauseAutoHide() {
  if (hideTimer) clearTimeout(hideTimer)
}

function resumeAutoHide() {
  hideTimer = setTimeout(() => { visible.value = false }, 3000)
}

onMounted(() => {
  // First toast after 8 seconds
  showTimer = setTimeout(() => {
    showProof()
    // Then every 25-40 seconds
    cycleTimer = setInterval(showProof, 25000 + Math.random() * 15000)
  }, 8000)
})

onUnmounted(() => {
  if (showTimer) clearTimeout(showTimer)
  if (hideTimer) clearTimeout(hideTimer)
  if (cycleTimer) clearInterval(cycleTimer)
})
</script>

<style scoped>
.social-toast {
  position: fixed;
  bottom: 24px;
  left: 24px;
  z-index: 900;
  max-width: 300px;
  background: rgba(255, 252, 248, 0.97);
  backdrop-filter: blur(16px);
  border: 1px solid rgba(197, 104, 122, 0.15);
  border-radius: 18px;
  padding: 14px 16px;
  box-shadow: 0 8px 32px rgba(80, 20, 20, 0.12);
}

.social-toast__close {
  position: absolute;
  top: 8px;
  right: 10px;
  background: none;
  border: none;
  font-size: 0.7rem;
  color: #a08080;
  cursor: pointer;
  padding: 2px;
  transition: color 0.2s;
}

.social-toast__close:hover {
  color: #c5687a;
}

.social-toast__content {
  display: flex;
  gap: 10px;
  align-items: flex-start;
}

.social-toast__avatar {
  font-size: 1.4rem;
  flex-shrink: 0;
  margin-top: 2px;
}

.social-toast__text {
  font-size: 0.82rem;
  color: #2d1a1a;
  line-height: 1.4;
}

.social-toast__text strong {
  color: #c5687a;
}

.social-toast__product {
  font-family: 'Cormorant Garamond', Georgia, serif;
  font-size: 0.88rem;
  font-weight: 600;
  color: #2d1a1a;
  margin-top: 2px;
}

.social-toast__time {
  font-size: 0.7rem;
  color: #a09090;
  margin-top: 3px;
}

/* Transition */
.social-toast-enter-active {
  transition: all 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
}
.social-toast-leave-active {
  transition: all 0.25s ease-in;
}
.social-toast-enter-from {
  opacity: 0;
  transform: translateX(-20px) translateY(10px);
}
.social-toast-leave-to {
  opacity: 0;
  transform: translateX(-20px);
}
</style>
