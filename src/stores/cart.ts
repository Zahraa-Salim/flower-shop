/** cart.ts — Pinia store for shopping cart with localStorage persistence */
import { defineStore } from 'pinia'
import type { Product } from '@/stores/flowers'

export type CartItemId = number | string

export interface CustomBouquetComponent {
  id: number
  name: string
  image_url: string
  price: number
  quantity: number
}

export interface CartItem {
  id: CartItemId
  name: string
  image_url: string
  price: number
  quantity: number
  components?: CustomBouquetComponent[]
}

export const useCartStore = defineStore('cart', {
  state: () => ({
    items: [] as CartItem[]
  }),

  getters: {
    totalPrice: (state) =>
      state.items.reduce((total, item) => total + item.price * item.quantity, 0),
    totalItems: (state) =>
      state.items.reduce((total, item) => total + item.quantity, 0)
  },

  actions: {
    addToCart(product: Product | CartItem) {
      const cartItem: CartItem = {
        id: product.id,
        name: product.name,
        image_url: product.image_url,
        price: product.price,
        quantity: 'quantity' in product ? product.quantity : 1,
        components: 'components' in product ? product.components : undefined
      }

      if (cartItem.id === 'custom-bouquet') {
        this.items = this.items.filter((item) => item.id !== 'custom-bouquet')
        this.items.push(cartItem)
        return
      }

      const existingItem = this.items.find((item) => item.id === cartItem.id)

      if (existingItem) {
        existingItem.quantity += cartItem.quantity
        return
      }

      this.items.push(cartItem)
    },

    removeFromCart(productId: CartItemId) {
      this.items = this.items.filter((item) => item.id !== productId)
    },

    updateQuantity(productId: CartItemId, quantity: number) {
      if (quantity <= 0) {
        this.removeFromCart(productId)
        return
      }

      const item = this.items.find((entry) => entry.id === productId)

      if (item) {
        item.quantity = quantity
      }
    },

    clearCart() {
      this.items = []
    }
  }
})
