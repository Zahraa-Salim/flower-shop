<!-- OptimizedImage.vue — Picture element wrapper with WebP source and responsive srcset -->
<template>
  <picture>
    <source
      v-if="isUnsplash"
      :srcset="webpSrcset"
      :sizes="sizes"
      type="image/webp"
    />
    <img
      :src="src"
      :srcset="isUnsplash ? jpegSrcset : undefined"
      :sizes="isUnsplash ? sizes : undefined"
      :alt="alt"
      :class="imgClass"
      :loading="loading"
    />
  </picture>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = withDefaults(defineProps<{
  src: string
  alt: string
  imgClass?: string
  sizes?: string
  loading?: 'lazy' | 'eager'
  widths?: number[]
}>(), {
  imgClass: '',
  sizes: '(max-width: 640px) 100vw, (max-width: 1024px) 50vw, 33vw',
  loading: 'lazy',
  widths: () => [400, 800, 1200]
})

const isUnsplash = computed(() => props.src.includes('unsplash.com'))

function buildSrcset(format: string) {
  return props.widths
    .map(w => {
      const sep = props.src.includes('?') ? '&' : '?'
      return `${props.src}${sep}fm=${format}&w=${w}&q=80 ${w}w`
    })
    .join(', ')
}

const webpSrcset = computed(() => buildSrcset('webp'))
const jpegSrcset = computed(() => buildSrcset('jpg'))
</script>
