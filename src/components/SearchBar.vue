<template>
  <div class="search-bar" ref="wrapperRef">
    <!-- Collapsed: icon only (mobile) -->
    <button
      v-if="!expanded"
      class="search-toggle lg:hidden"
      type="button"
      @click="expand"
      title="Search"
    >
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
        <circle cx="11" cy="11" r="8" /><path d="m21 21-4.35-4.35" />
      </svg>
    </button>

    <!-- Expanded input (always visible on desktop) -->
    <div class="search-input-wrap" :class="{ 'search-input-wrap--open': expanded }">
      <svg class="search-icon" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <circle cx="11" cy="11" r="8" /><path d="m21 21-4.35-4.35" />
      </svg>
      <input
        ref="inputRef"
        v-model="query"
        class="search-input"
        type="text"
        placeholder="Search flowers…"
        @focus="isOpen = results.length > 0"
        @keydown.escape="handleEscape"
        @keydown.down.prevent="moveHighlight(1)"
        @keydown.up.prevent="moveHighlight(-1)"
        @keydown.enter.prevent="selectHighlighted"
      />
      <button
        v-if="query"
        class="search-clear"
        type="button"
        @click="clear"
      >
        ✕
      </button>
    </div>

    <!-- Dropdown Results -->
    <Transition name="search-dropdown">
      <div v-if="isOpen && results.length" class="search-dropdown">
        <button
          v-for="(product, i) in results"
          :key="product.id"
          class="search-result"
          :class="{ 'search-result--active': highlightIndex === i }"
          type="button"
          @mouseenter="highlightIndex = i"
          @click="goToProduct(product.id)"
        >
          <img
            :src="product.image_url"
            :alt="product.name"
            class="search-result__img"
          />
          <div class="search-result__info">
            <span class="search-result__name">{{ product.name }}</span>
            <span class="search-result__meta">{{ product.type }} · {{ product.color }}</span>
          </div>
          <span class="search-result__price">${{ product.price.toFixed(2) }}</span>
        </button>
      </div>
    </Transition>
  </div>
</template>

<script setup lang="ts">
import { nextTick, onMounted, onUnmounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useSearch } from '@/composables/useSearch'
import { useFlowerStore } from '@/stores/flowers'

const router = useRouter()
const flowerStore = useFlowerStore()
const { query, results, isOpen, close, clear } = useSearch(() => flowerStore.flowers)

const wrapperRef = ref<HTMLElement | null>(null)
const inputRef = ref<HTMLInputElement | null>(null)
const expanded = ref(false)
const highlightIndex = ref(-1)

const expand = () => {
  expanded.value = true
  nextTick(() => inputRef.value?.focus())
}

const handleEscape = () => {
  if (isOpen.value) {
    close()
  } else {
    expanded.value = false
    clear()
  }
}

const moveHighlight = (delta: number) => {
  if (!results.value.length) return
  highlightIndex.value = (highlightIndex.value + delta + results.value.length) % results.value.length
}

const selectHighlighted = () => {
  if (highlightIndex.value >= 0 && highlightIndex.value < results.value.length) {
    goToProduct(results.value[highlightIndex.value].id)
  }
}

const goToProduct = (id: number) => {
  close()
  clear()
  expanded.value = false
  highlightIndex.value = -1
  router.push(`/product/${id}`)
}

// Click outside to close
const onClickOutside = (e: MouseEvent) => {
  if (wrapperRef.value && !wrapperRef.value.contains(e.target as Node)) {
    close()
    if (window.innerWidth < 1024) expanded.value = false
  }
}

onMounted(() => document.addEventListener('click', onClickOutside))
onUnmounted(() => document.removeEventListener('click', onClickOutside))
</script>

<style scoped>
.search-bar {
  position: relative;
  display: flex;
  align-items: center;
}

.search-toggle {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: transparent;
  border: none;
  color: #5a3535;
  cursor: pointer;
  transition: all 0.25s ease;
}

.search-toggle:hover {
  background: rgba(197, 104, 122, 0.1);
  color: #c5687a;
}

.search-input-wrap {
  display: none;
  align-items: center;
  gap: 8px;
  background: rgba(255, 248, 244, 0.85);
  backdrop-filter: blur(12px);
  border: 1px solid rgba(197, 104, 122, 0.2);
  border-radius: 100px;
  padding: 6px 14px;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}

/* Always visible on desktop */
@media (min-width: 1024px) {
  .search-input-wrap {
    display: flex;
  }
  .search-toggle {
    display: none;
  }
}

/* Open on mobile when expanded */
.search-input-wrap--open {
  display: flex;
  position: absolute;
  right: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 220px;
  z-index: 10;
}

.search-icon {
  color: #a08080;
  flex-shrink: 0;
}

.search-input {
  background: transparent;
  border: none;
  outline: none;
  font-family: 'Cormorant Garamond', Georgia, serif;
  font-size: 0.88rem;
  color: #2d1a1a;
  width: 140px;
}

.search-input::placeholder {
  color: #b09090;
}

.search-clear {
  background: none;
  border: none;
  color: #a08080;
  cursor: pointer;
  font-size: 0.75rem;
  padding: 2px;
  line-height: 1;
  transition: color 0.2s;
}

.search-clear:hover {
  color: #c5687a;
}

/* ── Dropdown ── */
.search-dropdown {
  position: absolute;
  top: calc(100% + 8px);
  right: 0;
  width: 320px;
  max-height: 380px;
  overflow-y: auto;
  background: rgba(255, 252, 248, 0.97);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(197, 104, 122, 0.15);
  border-radius: 20px;
  box-shadow: 0 12px 40px rgba(100, 40, 40, 0.12);
  padding: 6px;
  z-index: 100;
}

.search-result {
  display: flex;
  align-items: center;
  gap: 12px;
  width: 100%;
  padding: 8px 10px;
  border-radius: 14px;
  border: none;
  background: transparent;
  cursor: pointer;
  transition: background 0.15s ease;
  text-align: left;
}

.search-result:hover,
.search-result--active {
  background: rgba(197, 104, 122, 0.08);
}

.search-result__img {
  width: 42px;
  height: 42px;
  border-radius: 10px;
  object-fit: cover;
  flex-shrink: 0;
}

.search-result__info {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.search-result__name {
  font-family: 'Cormorant Garamond', Georgia, serif;
  font-size: 0.92rem;
  font-weight: 600;
  color: #2d1a1a;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.search-result__meta {
  font-size: 0.72rem;
  color: #a08080;
  letter-spacing: 0.04em;
}

.search-result__price {
  font-family: 'Cormorant Garamond', Georgia, serif;
  font-size: 0.88rem;
  font-weight: 600;
  color: #2d6a4f;
  flex-shrink: 0;
}

/* ── Dropdown transition ── */
.search-dropdown-enter-active {
  transition: all 0.25s cubic-bezier(0.34, 1.56, 0.64, 1);
}
.search-dropdown-leave-active {
  transition: all 0.15s ease-in;
}
.search-dropdown-enter-from,
.search-dropdown-leave-to {
  opacity: 0;
  transform: translateY(-8px) scale(0.97);
}
</style>
