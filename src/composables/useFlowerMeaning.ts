import { flowerMeanings } from '@/data/flower-meanings'

interface HasMeaning {
  meaning?: string | null
  type?: string
  name?: string
}

const GENERIC_FALLBACK = 'Every flower carries a quiet meaning — a gift of nature\'s poetry.'

/**
 * Resolves the symbolic meaning for a flower product.
 * Priority: product.meaning (DB) > type-based lookup > generic fallback.
 */
export function getFlowerMeaning(product: HasMeaning): string {
  if (product.meaning) return product.meaning

  if (product.type && flowerMeanings[product.type]) {
    return flowerMeanings[product.type]
  }

  // Try matching the product name against known types
  if (product.name) {
    for (const [type, meaning] of Object.entries(flowerMeanings)) {
      if (product.name.toLowerCase().includes(type.toLowerCase())) {
        return meaning
      }
    }
  }

  return GENERIC_FALLBACK
}
