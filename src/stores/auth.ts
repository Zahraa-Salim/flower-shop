/** auth.ts — Pinia store for authentication state and admin role detection */
import { defineStore } from 'pinia'
import type { User } from '@supabase/supabase-js'
import { supabase } from '@/lib/supabase'

const resolveAdminFlag = (user: User | null, dbRole: string | null) => {
  if (!user) {
    return false
  }

  const appRole = String(user.app_metadata?.role ?? '').toLowerCase()
  const userRole = String(user.user_metadata?.role ?? '').toLowerCase()

  return appRole === 'admin' || userRole === 'admin' || dbRole === 'admin'
}

export const useAuthStore = defineStore('auth', {
  state: () => ({
    user: null as User | null,
    dbRole: null as string | null
  }),

  getters: {
    isLoggedIn: (state) => state.user !== null,
    isAdmin: (state) => resolveAdminFlag(state.user, state.dbRole)
  },

  actions: {
    async fetchUser() {
      const { data } = await supabase.auth.getUser()
      this.user = data.user

      // Also check the users table for the role (more reliable than app_metadata)
      if (data.user) {
        const { data: dbUser } = await supabase
          .from('users')
          .select('role')
          .eq('id', data.user.id)
          .single()
        this.dbRole = dbUser?.role ?? null
      }
    },

    async logout() {
      await supabase.auth.signOut()
      this.user = null
    }
  }
})
