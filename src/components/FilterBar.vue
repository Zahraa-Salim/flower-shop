<template>
  <div class="filterbar">
    <div class="filterbar__inner">

      <!-- Type filters -->
      <div class="filterbar__group">
        <span class="filterbar__label">Type</span>
        <div class="filterbar__pills">
          <button
            class="filterbar__pill"
            :class="{ 'filterbar__pill--active': filters.type === '' }"
            type="button"
            @click="store.setFilter('type', '')"
          >All</button>
          <button
            v-for="type in flowerTypes"
            :key="type"
            class="filterbar__pill"
            :class="{ 'filterbar__pill--active': filters.type === type }"
            type="button"
            @click="store.setFilter('type', filters.type === type ? '' : type)"
          >{{ type }}</button>
        </div>
      </div>

      <!-- Divider -->
      <div class="filterbar__sep" />

      <!-- Color filters -->
      <div class="filterbar__group">
        <span class="filterbar__label">Color</span>
        <div class="filterbar__pills">
          <button
            class="filterbar__pill"
            :class="{ 'filterbar__pill--active': filters.color === '' }"
            type="button"
            @click="store.setFilter('color', '')"
          >All</button>
          <button
            v-for="color in flowerColors"
            :key="color"
            class="filterbar__color-pill"
            :class="{ 'filterbar__color-pill--active': filters.color === color }"
            type="button"
            :title="color"
            @click="store.setFilter('color', filters.color === color ? '' : color)"
          >
            <span class="filterbar__color-swatch" :style="{ background: colorMap[color] || '#999' }" />
            <span>{{ color }}</span>
          </button>
        </div>
      </div>

      <!-- Clear -->
      <button
        v-if="hasActiveFilters"
        class="filterbar__clear"
        type="button"
        @click="clearAll"
      >
        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
          <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
        </svg>
        Clear
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { storeToRefs } from 'pinia'
import { useFlowerStore } from '@/stores/flowers'

const store = useFlowerStore()
const { flowers, filters } = storeToRefs(store)

const colorMap: Record<string, string> = {
  Red: '#c0392b', Pink: '#e8a0b4', White: '#f0ece8', Yellow: '#f4d03f',
  Purple: '#967bb6', Orange: '#e67e22', Coral: '#e8735a', Blue: '#85b8d4',
  Mixed: 'linear-gradient(135deg,#e91e8c,#f4d03f)', Blush: '#e8b4b8',
  Lavender: '#b39dca', Green: '#7dbb8a',
}

const allTypes  = ['Rose','Tulip','Lily','Hydrangea','Sunflower','Peony','Orchid','Daisy','Lavender','Mixed']
const allColors = ['Pink','White','Red','Yellow','Purple','Orange','Coral','Mixed','Blush','Lavender']

const flowerTypes = computed(() => {
  const dynamic = flowers.value.map(f => f.type).filter(v => v.trim())
  return [...new Set([...allTypes, ...dynamic])]
})

const flowerColors = computed(() => {
  const dynamic = flowers.value.map(f => f.color).filter(v => v.trim())
  return [...new Set([...allColors, ...dynamic])]
})

const hasActiveFilters = computed(() =>
  filters.value.type !== '' || filters.value.color !== '' || filters.value.occasion !== ''
)

const clearAll = () => {
  store.setFilter('type', '')
  store.setFilter('color', '')
  store.setFilter('occasion', '')
}
</script>

<style scoped>
.filterbar {
  position: sticky;
  top: 72px;
  z-index: 30;
  background: rgba(253, 246, 240, 0.92);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border-bottom: 1px solid rgba(197, 104, 122, 0.15);
  padding: 12px 0;
}

.filterbar__inner {
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 40px;
  display: flex;
  align-items: center;
  gap: 20px;
  flex-wrap: wrap;
}

@media (max-width: 768px) {
  .filterbar__inner { padding: 0 20px; }
}

.filterbar__group {
  display: flex;
  align-items: center;
  gap: 10px;
  flex-wrap: wrap;
}

.filterbar__label {
  font-family: 'Inter', sans-serif;
  font-size: 0.68rem;
  font-weight: 700;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: #a07070;
  white-space: nowrap;
}

.filterbar__pills {
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
}

/* Text pills */
.filterbar__pill {
  font-family: 'Inter', sans-serif;
  font-size: 0.78rem;
  font-weight: 500;
  padding: 6px 14px;
  border-radius: 100px;
  border: 1.5px solid rgba(45, 26, 26, 0.15);
  background: transparent;
  color: #5a3535;
  cursor: pointer;
  transition: all 0.2s cubic-bezier(0.34, 1.56, 0.64, 1);
  white-space: nowrap;
}

.filterbar__pill:hover {
  border-color: #c5687a;
  color: #c5687a;
  transform: translateY(-1px);
}

.filterbar__pill--active {
  background: #2d1a1a;
  border-color: #2d1a1a;
  color: #fdf6f0;
  transform: translateY(-1px);
}

/* Color pills */
.filterbar__color-pill {
  display: flex;
  align-items: center;
  gap: 6px;
  font-family: 'Inter', sans-serif;
  font-size: 0.78rem;
  font-weight: 500;
  padding: 5px 12px 5px 8px;
  border-radius: 100px;
  border: 1.5px solid rgba(45, 26, 26, 0.15);
  background: transparent;
  color: #5a3535;
  cursor: pointer;
  transition: all 0.2s cubic-bezier(0.34, 1.56, 0.64, 1);
  white-space: nowrap;
}

.filterbar__color-pill:hover {
  border-color: #c5687a;
  transform: translateY(-1px);
}

.filterbar__color-pill--active {
  background: #2d1a1a;
  border-color: #2d1a1a;
  color: #fdf6f0;
  transform: translateY(-1px);
}

.filterbar__color-swatch {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  flex-shrink: 0;
  border: 1.5px solid rgba(255,255,255,0.5);
  box-shadow: 0 0 0 1px rgba(0,0,0,0.12);
}

/* Separator */
.filterbar__sep {
  width: 1px;
  height: 24px;
  background: rgba(197, 104, 122, 0.2);
  flex-shrink: 0;
}

/* Clear button */
.filterbar__clear {
  display: flex;
  align-items: center;
  gap: 5px;
  font-family: 'Inter', sans-serif;
  font-size: 0.75rem;
  font-weight: 600;
  color: #c5687a;
  background: none;
  border: none;
  cursor: pointer;
  padding: 6px 10px;
  border-radius: 100px;
  transition: all 0.2s ease;
  margin-left: auto;
}

.filterbar__clear:hover {
  background: rgba(197, 104, 122, 0.1);
}
</style>