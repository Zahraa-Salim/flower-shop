/** index.ts — Route definitions with lazy loading, auth guards, and transition direction */
import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { usePageTransition } from '@/composables/usePageTransition'
import Home from '@/pages/Home.vue'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/',
      name: 'home',
      component: Home
    },
    {
      path: '/shop',
      name: 'shop',
      component: () => import('@/pages/Shop.vue')
    },
    {
      path: '/bouquet-builder',
      name: 'bouquet-builder',
      component: () => import('@/pages/BouquetBuilder.vue')
    },
    {
      path: '/admin',
      name: 'admin',
      component: () => import('@/pages/admin/Dashboard.vue'),
      meta: { requiresAdmin: true, hideNavbar: true }
    },
    {
      path: '/product/:id',
      name: 'product-detail',
      component: () => import('@/pages/ProductDetail.vue')
    },
    {
      path: '/cart',
      name: 'cart',
      component: () => import('@/pages/Cart.vue')
    },
    {
      path: '/checkout',
      name: 'checkout',
      component: () => import('@/pages/Checkout.vue')
    },
    {
      path: '/order-success',
      name: 'order-success',
      component: () => import('@/pages/OrderSuccess.vue')
    },
    {
      path: '/reminders',
      name: 'reminders',
      component: () => import('@/pages/Reminders.vue')
    },
    {
      path: '/recommend',
      name: 'recommender',
      component: () => import('@/pages/Recommender.vue')
    },
    {
      path: '/orders/:id/track',
      name: 'order-tracking',
      component: () => import('@/pages/OrderTracking.vue')
    },
    {
      path: '/wishlist',
      name: 'wishlist',
      component: () => import('@/pages/Wishlist.vue')
    },
    {
      path: '/login',
      name: 'login',
      component: () => import('@/pages/Login.vue'),
      meta: { hideNavbar: true }
    },
    {
      path: '/register',
      name: 'register',
      component: () => import('@/pages/Register.vue'),
      meta: { hideNavbar: true }
    }
  ]
})

// Page order for directional transitions
const pageOrder = ['/', '/shop', '/bouquet-builder', '/product', '/cart', '/checkout', '/order-success']

router.beforeEach(async (to, from) => {
  const { setDirection } = usePageTransition()
  const fromIndex = pageOrder.findIndex(p => from.path.startsWith(p))
  const toIndex = pageOrder.findIndex(p => to.path.startsWith(p))
  setDirection(toIndex >= fromIndex ? 'forward' : 'backward')

  const authStore = useAuthStore()

  if (to.meta.requiresAuth || to.meta.requiresAdmin) {
    await authStore.fetchUser()
  }

  if (to.meta.requiresAdmin) {
    if (!authStore.isLoggedIn) {
      return '/login'
    }

    return authStore.isAdmin ? true : '/shop'
  }

  if (!to.meta.requiresAuth) {
    return true
  }

  if (authStore.isLoggedIn) {
    return true
  }

  return '/login'
})

export default router
