import { defineStore } from 'pinia'
import { supabase } from '@/lib/supabase'
import { useAuthStore } from '@/stores/auth'

const STORAGE_KEY = 'flower-shop:wishlist'

export const useWishlistStore = defineStore('wishlist', {
  state: () => ({
    productIds: [] as number[],
    loaded: false
  }),

  getters: {
    isWished: (state) => (productId: number) =>
      state.productIds.includes(productId),
    count: (state) => state.productIds.length
  },

  actions: {
    async fetchWishlist() {
      const auth = useAuthStore()

      if (auth.isLoggedIn && auth.user) {
        const { data } = await supabase
          .from('wishlists')
          .select('product_id')
          .eq('user_id', auth.user.id)

        this.productIds = data?.map(row => row.product_id) ?? []
      } else {
        // Guest fallback: localStorage
        try {
          const stored = localStorage.getItem(STORAGE_KEY)
          this.productIds = stored ? JSON.parse(stored) : []
        } catch {
          this.productIds = []
        }
      }

      this.loaded = true
    },

    async toggleWishlist(productId: number) {
      const auth = useAuthStore()
      const exists = this.productIds.includes(productId)

      if (exists) {
        // Remove
        this.productIds = this.productIds.filter(id => id !== productId)

        if (auth.isLoggedIn && auth.user) {
          await supabase
            .from('wishlists')
            .delete()
            .eq('user_id', auth.user.id)
            .eq('product_id', productId)
        }
      } else {
        // Add
        this.productIds.push(productId)

        if (auth.isLoggedIn && auth.user) {
          await supabase
            .from('wishlists')
            .insert({ user_id: auth.user.id, product_id: productId })
        }
      }

      // Always sync to localStorage as well (for guest mode)
      if (!auth.isLoggedIn) {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(this.productIds))
      }
    }
  }
})
