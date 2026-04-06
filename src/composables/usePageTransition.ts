/** usePageTransition.ts — Tracks navigation direction for page slide transitions */
import { ref } from 'vue'

export type TransitionDirection = 'forward' | 'backward'

const direction = ref<TransitionDirection>('forward')

/**
 * Tracks navigation direction for directional page transitions.
 * Call setDirection('forward') or setDirection('backward') from router guards.
 */
export function usePageTransition() {
  const setDirection = (dir: TransitionDirection) => {
    direction.value = dir
  }

  return { direction, setDirection }
}
