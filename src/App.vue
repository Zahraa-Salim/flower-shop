<!-- App.vue — Root app shell with conditional navbar, page transitions, and global components -->
<template>
  <div class="min-h-screen">
    <Navbar v-if="!hideNavbar" />
    <RouterView v-slot="{ Component }">
      <Transition
        mode="out-in"
        :name="transitionName"
      >
        <component :is="Component" />
      </Transition>
    </RouterView>
    <QuickViewModal />
    <SocialProofToast />
    <CustomCursor />
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import Navbar from '@/components/Navbar.vue'
import QuickViewModal from '@/components/QuickViewModal.vue'
import SocialProofToast from '@/components/SocialProofToast.vue'
import CustomCursor from '@/components/CustomCursor.vue'
import { useWishlistStore } from '@/stores/wishlist'
import { usePageTransition } from '@/composables/usePageTransition'
import { applySeasonalTheme } from '@/composables/useSeason'

const route = useRoute()
const wishlistStore = useWishlistStore()
const { direction } = usePageTransition()
const hideNavbar = computed(() => !!route.meta.hideNavbar)
const transitionName = computed(() =>
  direction.value === 'forward' ? 'page-slide-left' : 'page-slide-right'
)

onMounted(() => {
  wishlistStore.fetchWishlist()
  applySeasonalTheme()
})
</script>
