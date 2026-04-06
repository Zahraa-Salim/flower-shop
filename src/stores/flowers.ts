/** flowers.ts — Pinia store for product catalog fetching and filtering */
import { defineStore } from 'pinia'
import { supabase } from '@/lib/supabase'

interface ProductOccasion {
  slug: string
}

interface ProductOccasionJoin {
  occasions: ProductOccasion | ProductOccasion[] | null
}

export interface Product {
  id: number
  name: string
  description: string
  price: number
  stock: number
  image_url: string
  type: string
  color: string
  is_available: boolean
  created_at: string
  meaning?: string | null
  product_occasions?: ProductOccasionJoin[]
}

interface FlowerFilters {
  type: string
  color: string
  occasion: string
}

type FilterKey = keyof FlowerFilters

const normalizeValue = (value: string) => value.trim().toLowerCase()

export const useFlowerStore = defineStore('flowers', {
  state: () => ({
    flowers: [] as Product[],
    loading: false,
    filters: {
      type: '',
      color: '',
      occasion: ''
    } as FlowerFilters
  }),

  getters: {
    filteredFlowers: (state) =>
      state.flowers.filter((flower) => {
        const matchesType =
          !state.filters.type ||
          normalizeValue(flower.type) === normalizeValue(state.filters.type)
        const matchesColor =
          !state.filters.color ||
          normalizeValue(flower.color) === normalizeValue(state.filters.color)
        const occasionSlugs =
          flower.product_occasions?.flatMap((entry) => {
            if (!entry.occasions) {
              return []
            }

            const occasions = Array.isArray(entry.occasions)
              ? entry.occasions
              : [entry.occasions]

            return occasions.map((occasion) => normalizeValue(occasion.slug))
          }) ?? []
        const matchesOccasion =
          !state.filters.occasion ||
          occasionSlugs.includes(normalizeValue(state.filters.occasion))

        return matchesType && matchesColor && matchesOccasion
      })
  },

  actions: {
    async fetchFlowers() {
      this.loading = true
      const { data } = await supabase.from('products').select('*')
      if (data) {
        this.flowers = data
      }
      this.loading = false
    },

    async fetchByOccasion(occasionSlug: string) {
      this.loading = true
      const { data } = await supabase
        .from('products')
        .select('*, product_occasions(occasions(slug))')
        .eq('product_occasions.occasions.slug', occasionSlug)
      if (data) {
        this.flowers = data as Product[]
        this.filters.occasion = occasionSlug
      }
      this.loading = false
    },

    setFilter(key: FilterKey, value: string) {
      this.filters[key] = value
    }
  }
})
