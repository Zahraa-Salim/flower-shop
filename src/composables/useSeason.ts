import { seasonalThemes, type Season, type SeasonalTheme } from '@/data/seasonal-themes'

function getCurrentSeason(): Season {
  const month = new Date().getMonth() // 0-11
  if (month >= 2 && month <= 4) return 'spring'
  if (month >= 5 && month <= 7) return 'summer'
  if (month >= 8 && month <= 10) return 'autumn'
  return 'winter'
}

const currentSeason = getCurrentSeason()
const currentTheme = seasonalThemes[currentSeason]

/**
 * Returns the current season and its theme.
 * Applies CSS custom properties to :root for theme-aware components.
 */
export function useSeason(): { season: Season; theme: SeasonalTheme } {
  return { season: currentSeason, theme: currentTheme }
}

/**
 * Call once at app init to set CSS custom properties on :root.
 */
export function applySeasonalTheme() {
  const root = document.documentElement.style
  root.setProperty('--season-accent', currentTheme.accentPrimary)
  root.setProperty('--season-accent-secondary', currentTheme.accentSecondary)
  root.setProperty('--season-glow', currentTheme.accentGlow)
  root.setProperty('--season-gradient-from', currentTheme.heroGradientFrom)
  root.setProperty('--season-gradient-to', currentTheme.heroGradientTo)
}
