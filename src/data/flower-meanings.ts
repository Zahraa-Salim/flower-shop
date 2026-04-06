/** flower-meanings.ts — Static map of flower types to their symbolic meanings */

/**
 * Default flower symbolism keyed by flower type.
 * Used as a fallback when a product doesn't have a custom `meaning` column.
 */
export const flowerMeanings: Record<string, string> = {
  Rose: 'Love, passion, and devotion — the timeless language of the heart.',
  Tulip: 'Perfect love and new beginnings — a declaration of elegance.',
  Lily: 'Purity, renewal, and remembrance — grace in every petal.',
  Sunflower: 'Adoration, loyalty, and vitality — a burst of warm happiness.',
  Peony: 'Prosperity, romance, and compassion — lush beauty that captivates.',
  Orchid: 'Luxury, refinement, and rare beauty — an exotic whisper of elegance.',
  Daisy: 'Innocence, cheerfulness, and new starts — simple joy in bloom.',
  Lavender: 'Serenity, grace, and calm devotion — a soothing embrace.',
  Hydrangea: 'Gratitude, abundance, and heartfelt emotion — generous and full.',
  Mixed: 'A harmony of sentiments — every stem tells its own story.',
  Carnation: 'Fascination, distinction, and deep affection — classic and enduring.',
  Chrysanthemum: 'Longevity, joy, and optimism — a celebration of life.',
  Dahlia: 'Inner strength, creativity, and elegance — bold and unforgettable.',
  Iris: 'Wisdom, hope, and courage — a message of faith and valor.',
  Jasmine: 'Sweet love, sensuality, and grace — an intoxicating fragrance of the soul.',
  Gardenia: 'Secret love, purity, and joy — a hidden treasure of the heart.',
  Ranunculus: 'Radiant charm and attractiveness — you are dazzling.',
  Anemone: 'Anticipation, protection, and fading hope — fragile yet fierce.',
  Freesia: 'Trust, friendship, and thoughtfulness — a bond that endures.',
  Magnolia: 'Dignity, perseverance, and nobility — timeless and majestic.',
}
