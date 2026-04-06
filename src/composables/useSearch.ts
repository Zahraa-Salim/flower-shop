import { ref, watch } from 'vue'
import type { Product } from '@/stores/flowers'

/**
 * Fuzzy-ish search: checks if all query characters appear in order in the target.
 * Returns a score (lower = better match). -1 = no match.
 */
function fuzzyScore(query: string, target: string): number {
  const q = query.toLowerCase()
  const t = target.toLowerCase()

  // Exact substring match gets best score
  if (t.includes(q)) return 0

  // Ordered character match
  let qi = 0
  let score = 0
  for (let ti = 0; ti < t.length && qi < q.length; ti++) {
    if (t[ti] === q[qi]) {
      qi++
    } else {
      score++
    }
  }

  return qi === q.length ? score : -1
}

export function useSearch(getProducts: () => Product[], maxResults = 8) {
  const query = ref('')
  const results = ref<Product[]>([])
  const isOpen = ref(false)

  let debounceTimer: ReturnType<typeof setTimeout> | null = null

  const performSearch = () => {
    const q = query.value.trim()
    if (q.length < 2) {
      results.value = []
      isOpen.value = false
      return
    }

    const products = getProducts()
    const scored: { product: Product; score: number }[] = []

    for (const product of products) {
      // Match against name, type, and color
      const nameScore = fuzzyScore(q, product.name)
      const typeScore = fuzzyScore(q, product.type)
      const colorScore = fuzzyScore(q, product.color)

      const best = Math.min(
        nameScore >= 0 ? nameScore : Infinity,
        typeScore >= 0 ? typeScore + 5 : Infinity,
        colorScore >= 0 ? colorScore + 10 : Infinity
      )

      if (best < Infinity) {
        scored.push({ product, score: best })
      }
    }

    scored.sort((a, b) => a.score - b.score)
    results.value = scored.slice(0, maxResults).map(s => s.product)
    isOpen.value = results.value.length > 0
  }

  watch(query, () => {
    if (debounceTimer) clearTimeout(debounceTimer)
    debounceTimer = setTimeout(performSearch, 200)
  })

  const close = () => {
    isOpen.value = false
  }

  const clear = () => {
    query.value = ''
    results.value = []
    isOpen.value = false
  }

  return { query, results, isOpen, close, clear }
}
