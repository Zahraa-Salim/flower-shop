<template>
  <div v-if="!isTouch" ref="cursorRef" class="custom-cursor">
    <div class="cursor-dot" />
    <div ref="ringRef" class="cursor-ring" />
  </div>
</template>

<script setup lang="ts">
import { onMounted, onUnmounted, ref } from 'vue'
import gsap from 'gsap'
import { prefersReducedMotion } from '@/animations/motion'

const cursorRef = ref<HTMLElement | null>(null)
const ringRef = ref<HTMLElement | null>(null)
const isTouch = ref(false)

let cleanups: (() => void)[] = []

onMounted(() => {
  // Detect touch device
  isTouch.value = 'ontouchstart' in window || navigator.maxTouchPoints > 0
  if (isTouch.value || prefersReducedMotion()) return

  const cursor = cursorRef.value
  const ring = ringRef.value
  if (!cursor || !ring) return

  const onMove = (e: MouseEvent) => {
    gsap.to(cursor, { x: e.clientX, y: e.clientY, duration: 0.15, ease: 'power2.out' })
    gsap.to(ring, { x: e.clientX, y: e.clientY, duration: 0.35, ease: 'power2.out' })
  }

  const onEnterInteractive = () => {
    gsap.to(ring, { scale: 1.8, opacity: 0.5, duration: 0.3, ease: 'power2.out' })
  }

  const onLeaveInteractive = () => {
    gsap.to(ring, { scale: 1, opacity: 0.35, duration: 0.3, ease: 'power2.out' })
  }

  document.addEventListener('mousemove', onMove)

  // Observe for interactive elements
  const addInteractiveListeners = () => {
    document.querySelectorAll('a, button, [role="button"], .pcard').forEach(el => {
      el.addEventListener('mouseenter', onEnterInteractive)
      el.addEventListener('mouseleave', onLeaveInteractive)
    })
  }

  addInteractiveListeners()

  // Re-scan periodically for dynamically added elements
  const observer = new MutationObserver(addInteractiveListeners)
  observer.observe(document.body, { childList: true, subtree: true })

  cleanups.push(() => {
    document.removeEventListener('mousemove', onMove)
    observer.disconnect()
  })
})

onUnmounted(() => {
  cleanups.forEach(fn => fn())
  cleanups = []
})
</script>

<style>
/* Hide default cursor globally when custom cursor is active */
@media (hover: hover) and (pointer: fine) {
  .custom-cursor ~ * {
    cursor: none !important;
  }
}
</style>

<style scoped>
.custom-cursor {
  position: fixed;
  top: 0;
  left: 0;
  z-index: 10000;
  pointer-events: none;
}

.cursor-dot {
  position: absolute;
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: #c5687a;
  transform: translate(-50%, -50%);
}

.cursor-ring {
  position: absolute;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  border: 1.5px solid rgba(197, 104, 122, 0.4);
  transform: translate(-50%, -50%);
  opacity: 0.35;
  transition: border-color 0.2s;
}
</style>
