import { onMounted, onUnmounted, type Ref } from 'vue'
import gsap from 'gsap'
import { prefersReducedMotion } from '@/animations/motion'

/**
 * Makes an element subtly follow the cursor within a threshold,
 * then spring back on mouse leave.
 */
export function useMagneticButton(
  elRef: Ref<HTMLElement | null>,
  strength = 0.3,
  radius = 40
) {
  let cleanups: (() => void)[] = []

  onMounted(() => {
    const el = elRef.value
    if (!el || prefersReducedMotion()) return

    const onMove = (e: MouseEvent) => {
      const rect = el.getBoundingClientRect()
      const cx = rect.left + rect.width / 2
      const cy = rect.top + rect.height / 2
      const dx = e.clientX - cx
      const dy = e.clientY - cy
      const dist = Math.sqrt(dx * dx + dy * dy)

      if (dist < radius) {
        gsap.to(el, {
          x: dx * strength,
          y: dy * strength,
          duration: 0.3,
          ease: 'power2.out'
        })
      }
    }

    const onLeave = () => {
      gsap.to(el, {
        x: 0,
        y: 0,
        duration: 0.5,
        ease: 'elastic.out(1, 0.4)'
      })
    }

    el.addEventListener('mousemove', onMove)
    el.addEventListener('mouseleave', onLeave)

    cleanups.push(() => {
      el.removeEventListener('mousemove', onMove)
      el.removeEventListener('mouseleave', onLeave)
    })
  })

  onUnmounted(() => {
    cleanups.forEach(fn => fn())
    cleanups = []
  })
}
