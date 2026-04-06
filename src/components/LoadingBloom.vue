<!--
  LoadingBloom.vue
  Themed loading spinner with animated flower petals and pulsing text.
  Used across pages when data is being fetched from Supabase.
-->
<template>
  <Transition appear name="bloom">
    <div
      class="mx-auto flex max-w-md flex-col items-center justify-center gap-6 rounded-[2rem] bg-white/70 px-6 py-12 text-center"
      aria-live="polite"
    >
      <div class="bloom-spinner" aria-hidden="true">
        <span class="petal petal-1" />
        <span class="petal petal-2" />
        <span class="petal petal-3" />
        <span class="petal petal-4" />
        <span class="petal petal-5" />
        <span class="petal petal-6" />
        <span class="bloom-center" />
      </div>
      <div class="space-y-2">
        <p class="heading-serif text-lg font-semibold text-rose-950">{{ title }}</p>
        <p class="text-sm text-stone-500">{{ description }}</p>
      </div>
    </div>
  </Transition>
</template>

<script setup lang="ts">
withDefaults(
  defineProps<{
    title?: string
    description?: string
  }>(),
  {
    title: 'Loading fresh flowers...',
    description: 'Gathering petals, colors, and hand-tied details for you.'
  }
)
</script>

<style scoped>
.bloom-spinner {
  position: relative;
  width: 64px;
  height: 64px;
  animation: spin-slow 6s linear infinite;
}

.petal {
  position: absolute;
  width: 20px;
  height: 28px;
  top: 50%;
  left: 50%;
  margin-left: -10px;
  margin-top: -28px;
  border-radius: 50% 50% 50% 50% / 60% 60% 40% 40%;
  transform-origin: center bottom;
  opacity: 0.85;
}

.petal-1 { background: #e8a0b4; transform: rotate(0deg); animation: petal-pulse 2s ease-in-out 0s infinite; }
.petal-2 { background: #c5687a; transform: rotate(60deg); animation: petal-pulse 2s ease-in-out 0.33s infinite; }
.petal-3 { background: #e8a0b4; transform: rotate(120deg); animation: petal-pulse 2s ease-in-out 0.66s infinite; }
.petal-4 { background: #c5687a; transform: rotate(180deg); animation: petal-pulse 2s ease-in-out 1s infinite; }
.petal-5 { background: #e8a0b4; transform: rotate(240deg); animation: petal-pulse 2s ease-in-out 1.33s infinite; }
.petal-6 { background: #c5687a; transform: rotate(300deg); animation: petal-pulse 2s ease-in-out 1.66s infinite; }

.bloom-center {
  position: absolute;
  width: 14px;
  height: 14px;
  top: 50%;
  left: 50%;
  margin-left: -7px;
  margin-top: -7px;
  border-radius: 50%;
  background: #f4d03f;
  box-shadow: 0 0 8px rgba(244, 208, 63, 0.5);
  animation: center-glow 2s ease-in-out infinite;
}

@keyframes spin-slow {
  to { transform: rotate(360deg); }
}

@keyframes petal-pulse {
  0%, 100% { opacity: 0.6; transform: rotate(var(--r, 0deg)) scale(0.9); }
  50% { opacity: 1; transform: rotate(var(--r, 0deg)) scale(1.05); }
}

.petal-1 { --r: 0deg; }
.petal-2 { --r: 60deg; }
.petal-3 { --r: 120deg; }
.petal-4 { --r: 180deg; }
.petal-5 { --r: 240deg; }
.petal-6 { --r: 300deg; }

@keyframes center-glow {
  0%, 100% { box-shadow: 0 0 6px rgba(244, 208, 63, 0.4); transform: scale(1); }
  50% { box-shadow: 0 0 14px rgba(244, 208, 63, 0.7); transform: scale(1.15); }
}

@media (prefers-reduced-motion: reduce) {
  .bloom-spinner { animation: none; }
  .petal { animation: none; opacity: 0.8; }
  .bloom-center { animation: none; }
}
</style>
