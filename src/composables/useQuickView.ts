import { ref } from 'vue'
import type { Product } from '@/stores/flowers'

const product = ref<Product | null>(null)
const isOpen = ref(false)

export function useQuickView() {
  const open = (p: Product) => {
    product.value = p
    isOpen.value = true
  }

  const close = () => {
    isOpen.value = false
    // Allow the leave animation to finish before clearing
    setTimeout(() => { product.value = null }, 300)
  }

  return { product, isOpen, open, close }
}
