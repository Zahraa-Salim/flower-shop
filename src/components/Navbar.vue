<!-- Navbar.vue — Main navigation with search bar, wishlist, reminders, and cart icons -->
<template>
  <header
    class="fixed top-0 left-0 right-0 z-50 transition-all duration-500"
    :class="isScrolled ? 'nav-scrolled' : 'nav-top'"
  >
    <div class="mx-auto flex max-w-7xl items-center justify-between px-6 py-5 lg:px-10">

      <!-- Logo -->
      <RouterLink to="/" class="logo-mark group flex items-center gap-3">
        <span class="logo-icon">✦</span>
        <span class="logo-text">La Fleur</span>
      </RouterLink>

      <!-- Center Nav Links -->
      <nav class="hidden items-center gap-1 lg:flex">
        <RouterLink
          v-for="link in links"
          :key="link.to"
          :to="link.to"
          class="nav-link"
          :class="{ 'nav-link--active': $route.path === link.to }"
        >
          {{ link.label }}
        </RouterLink>
      </nav>

      <!-- Right Actions -->
      <div class="flex items-center gap-3">
        <SearchBar />

        <!-- Reminders -->
        <RouterLink to="/reminders" class="nav-icon-btn" title="Reminders">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
            <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/>
            <path d="M13.73 21a2 2 0 0 1-3.46 0"/>
          </svg>
        </RouterLink>

        <!-- Wishlist -->
        <RouterLink to="/wishlist" class="nav-icon-btn" title="Wishlist">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
            <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
          </svg>
          <span v-if="wishlistCount > 0" class="wish-badge">{{ wishlistCount }}</span>
        </RouterLink>

        <!-- Cart -->
        <RouterLink to="/cart" class="cart-btn" title="Cart">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
            <path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/>
            <line x1="3" y1="6" x2="21" y2="6"/>
            <path d="M16 10a4 4 0 0 1-8 0"/>
          </svg>
          <span v-if="totalItems > 0" class="cart-badge">{{ totalItems }}</span>
        </RouterLink>

        <!-- Mobile Menu Toggle -->
        <button
          class="mobile-menu-btn lg:hidden"
          type="button"
          @click="mobileOpen = !mobileOpen"
        >
          <span class="sr-only">Menu</span>
          <div class="hamburger" :class="{ open: mobileOpen }">
            <span></span><span></span><span></span>
          </div>
        </button>
      </div>
    </div>

    <!-- Mobile Menu -->
    <Transition name="mobile-menu">
      <div v-if="mobileOpen" class="mobile-nav lg:hidden">
        <RouterLink
          v-for="link in links"
          :key="link.to"
          :to="link.to"
          class="mobile-nav-link"
          @click="mobileOpen = false"
        >
          {{ link.label }}
        </RouterLink>
        <RouterLink to="/reminders" class="mobile-nav-link" @click="mobileOpen = false">
          Reminders
        </RouterLink>
        <RouterLink to="/wishlist" class="mobile-nav-link" @click="mobileOpen = false">
          Wishlist <span v-if="wishlistCount > 0" class="mobile-badge">{{ wishlistCount }}</span>
        </RouterLink>
        <RouterLink to="/cart" class="mobile-nav-link" @click="mobileOpen = false">
          Cart <span v-if="totalItems > 0" class="mobile-badge">{{ totalItems }}</span>
        </RouterLink>
      </div>
    </Transition>
  </header>
</template>

<script setup lang="ts">
import { onMounted, onUnmounted, ref } from 'vue'
import { storeToRefs } from 'pinia'
import { useCartStore } from '@/stores/cart'
import { useWishlistStore } from '@/stores/wishlist'
import SearchBar from '@/components/SearchBar.vue'

const links = [
  { label: 'Home', to: '/' },
  { label: 'Shop', to: '/shop' },
  { label: 'Craft Your Bouquet', to: '/bouquet-builder' },
  { label: 'Find Your Bouquet', to: '/recommend' },
]

const cartStore = useCartStore()
const wishlistStore = useWishlistStore()
const { totalItems } = storeToRefs(cartStore)
const { count: wishlistCount } = storeToRefs(wishlistStore)

const isScrolled = ref(false)
const mobileOpen = ref(false)

const handleScroll = () => {
  isScrolled.value = window.scrollY > 40
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll, { passive: true })
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>

<style scoped>
/* ── Navbar states ── */
.nav-top {
  background: transparent;
}

.nav-scrolled {
  background: rgba(255, 248, 244, 0.92);
  backdrop-filter: blur(18px);
  -webkit-backdrop-filter: blur(18px);
  border-bottom: 1px solid rgba(244, 194, 194, 0.25);
  box-shadow: 0 4px 32px rgba(180, 60, 60, 0.06);
}

/* ── Logo ── */
.logo-mark {
  text-decoration: none;
  display: flex;
  align-items: center;
  gap: 10px;
}

.logo-icon {
  font-size: 1.1rem;
  color: #c5687a;
  display: inline-block;
  animation: spin-slow 12s linear infinite;
}

@keyframes spin-slow {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.logo-text {
  font-family: 'Cormorant Garamond', 'Playfair Display', 'Georgia', serif;
  font-size: 1.35rem;
  font-weight: 600;
  letter-spacing: 0.12em;
  color: #2d1a1a;
  text-transform: uppercase;
}

/* ── Nav Links ── */
.nav-link {
  font-family: 'Cormorant Garamond', 'Playfair Display', 'Georgia', serif;
  font-size: 0.9rem;
  font-weight: 500;
  letter-spacing: 0.08em;
  color: #5a3535;
  text-decoration: none;
  padding: 8px 16px;
  border-radius: 100px;
  transition: all 0.25s ease;
  position: relative;
}

.nav-link::after {
  content: '';
  position: absolute;
  bottom: 4px;
  left: 50%;
  transform: translateX(-50%) scaleX(0);
  width: 20px;
  height: 1px;
  background: #c5687a;
  transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.nav-link:hover {
  color: #2d1a1a;
  background: rgba(197, 104, 122, 0.08);
}

.nav-link:hover::after,
.nav-link--active::after {
  transform: translateX(-50%) scaleX(1);
}

.nav-link--active {
  color: #c5687a;
  font-weight: 600;
}

/* ── Icon Buttons ── */
.nav-icon-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  color: #5a3535;
  text-decoration: none;
  transition: all 0.25s ease;
  background: transparent;
}

.nav-icon-btn:hover {
  background: rgba(197, 104, 122, 0.1);
  color: #c5687a;
  transform: scale(1.08);
}

.nav-icon-btn {
  position: relative;
}

.wish-badge {
  position: absolute;
  top: -2px;
  right: -2px;
  background: #c5687a;
  color: white;
  font-size: 0.6rem;
  font-weight: 700;
  width: 16px;
  height: 16px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 2px solid #fff8f4;
  animation: badge-pop 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}

/* ── Cart Button ── */
.cart-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 44px;
  height: 44px;
  border-radius: 50%;
  color: #fff8f4;
  background: #c5687a;
  text-decoration: none;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  position: relative;
  box-shadow: 0 4px 16px rgba(197, 104, 122, 0.35);
}

.cart-btn:hover {
  background: #b05568;
  transform: scale(1.1) translateY(-2px);
  box-shadow: 0 8px 24px rgba(197, 104, 122, 0.45);
}

.cart-badge {
  position: absolute;
  top: -4px;
  right: -4px;
  background: #2d4a2a;
  color: white;
  font-size: 0.65rem;
  font-weight: 700;
  width: 18px;
  height: 18px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 2px solid #fff8f4;
  animation: badge-pop 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}

@keyframes badge-pop {
  from { transform: scale(0); }
  to { transform: scale(1); }
}

/* ── Mobile Menu Button ── */
.mobile-menu-btn {
  background: none;
  border: none;
  cursor: pointer;
  padding: 8px;
}

.hamburger {
  display: flex;
  flex-direction: column;
  gap: 5px;
  width: 22px;
}

.hamburger span {
  display: block;
  height: 1.5px;
  background: #2d1a1a;
  border-radius: 2px;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  transform-origin: center;
}

.hamburger.open span:nth-child(1) {
  transform: translateY(6.5px) rotate(45deg);
}
.hamburger.open span:nth-child(2) {
  opacity: 0;
  transform: scaleX(0);
}
.hamburger.open span:nth-child(3) {
  transform: translateY(-6.5px) rotate(-45deg);
}

/* ── Mobile Nav ── */
.mobile-nav {
  background: rgba(255, 248, 244, 0.97);
  backdrop-filter: blur(20px);
  border-top: 1px solid rgba(197, 104, 122, 0.15);
  padding: 16px 24px 24px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.mobile-nav-link {
  font-family: 'Cormorant Garamond', 'Playfair Display', Georgia, serif;
  font-size: 1.15rem;
  font-weight: 500;
  color: #2d1a1a;
  text-decoration: none;
  padding: 12px 16px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.2s ease;
}

.mobile-nav-link:hover {
  background: rgba(197, 104, 122, 0.08);
  color: #c5687a;
}

.mobile-badge {
  background: #c5687a;
  color: white;
  font-size: 0.7rem;
  font-weight: 700;
  padding: 1px 7px;
  border-radius: 100px;
}

/* ── Mobile Menu Transition ── */
.mobile-menu-enter-active,
.mobile-menu-leave-active {
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
}
.mobile-menu-enter-from,
.mobile-menu-leave-to {
  opacity: 0;
  transform: translateY(-12px);
}
</style>
