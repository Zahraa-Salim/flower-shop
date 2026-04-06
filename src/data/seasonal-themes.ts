/** seasonal-themes.ts — Season-to-color-palette mapping for dynamic theming */
export type Season = 'spring' | 'summer' | 'autumn' | 'winter'

export interface SeasonalTheme {
  season: Season
  label: string
  accentPrimary: string
  accentSecondary: string
  accentGlow: string
  heroGradientFrom: string
  heroGradientTo: string
  featuredOccasion: string
}

export const seasonalThemes: Record<Season, SeasonalTheme> = {
  spring: {
    season: 'spring',
    label: 'Spring Collection',
    accentPrimary: '#c5687a',    // rose pink
    accentSecondary: '#e8a0b4',
    accentGlow: 'rgba(197, 104, 122, 0.15)',
    heroGradientFrom: '#fff1f2',  // rose-50
    heroGradientTo: '#ecfdf5',    // emerald-50
    featuredOccasion: 'birthday',
  },
  summer: {
    season: 'summer',
    label: 'Summer Collection',
    accentPrimary: '#d97706',    // warm amber
    accentSecondary: '#fbbf24',
    accentGlow: 'rgba(217, 119, 6, 0.12)',
    heroGradientFrom: '#fffbeb',  // amber-50
    heroGradientTo: '#fef3c7',    // amber-100
    featuredOccasion: 'anniversary',
  },
  autumn: {
    season: 'autumn',
    label: 'Autumn Collection',
    accentPrimary: '#b45309',    // amber-700
    accentSecondary: '#c2410c',  // orange-700
    accentGlow: 'rgba(180, 83, 9, 0.12)',
    heroGradientFrom: '#fef3c7',
    heroGradientTo: '#fff7ed',    // orange-50
    featuredOccasion: 'sympathy',
  },
  winter: {
    season: 'winter',
    label: 'Winter Collection',
    accentPrimary: '#6366f1',    // indigo
    accentSecondary: '#a5b4fc',
    accentGlow: 'rgba(99, 102, 241, 0.1)',
    heroGradientFrom: '#eef2ff',  // indigo-50
    heroGradientTo: '#f0fdf4',    // green-50
    featuredOccasion: 'wedding',
  },
}
