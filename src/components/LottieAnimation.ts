import { computed, defineComponent, h, onMounted, onUnmounted, ref, watch } from 'vue'
import type { PropType } from 'vue'
import '@lottiefiles/lottie-player/dist/lottie-player.js'

interface LottiePlayerElement extends HTMLElement {
  load: (src: string | object) => void
  stop?: () => void
}

const bindObjectSource = (
  element: LottiePlayerElement | null,
  source: object
) => {
  if (!element) {
    return
  }

  element.load(source)
}

const LottieAnimation = defineComponent({
  name: 'LottieAnimation',
  inheritAttrs: false,
  props: {
    src: {
      type: [String, Object] as PropType<string | object>,
      required: true
    },
    autoplay: {
      type: Boolean,
      default: false
    },
    loop: {
      type: Boolean,
      default: false
    },
    controls: {
      type: Boolean,
      default: false
    },
    speed: {
      type: Number,
      default: 1
    },
    mode: {
      type: String,
      default: 'normal'
    },
    background: {
      type: String,
      default: undefined
    },
    fallbackTitle: {
      type: String,
      default: 'Animation unavailable'
    },
    fallbackDescription: {
      type: String,
      default: 'This floral motion will appear once the Lottie JSON file is available.'
    }
  },
  emits: ['complete', 'error', 'load', 'loop', 'ready'],
  setup(props, { attrs, emit }) {
    const playerRef = ref<LottiePlayerElement | null>(null)
    const hasError = ref(false)
    let activeRequestId = 0
    const containerClass = computed(() => attrs.class)
    const containerStyle = computed(() => attrs.style)

    const syncSource = async () => {
      const requestId = ++activeRequestId

      if (!playerRef.value) {
        return
      }

      if (typeof props.src !== 'string') {
        hasError.value = false
        bindObjectSource(playerRef.value, props.src)
        return
      }

      try {
        const response = await fetch(props.src, {
          headers: {
            Accept: 'application/json'
          }
        })

        if (!response.ok) {
          throw new Error(`Failed to load Lottie JSON from ${props.src} (${response.status})`)
        }

        const animationData = (await response.json()) as object

        if (requestId !== activeRequestId) {
          return
        }

        hasError.value = false
        bindObjectSource(playerRef.value, animationData)
      } catch (error) {
        if (requestId !== activeRequestId) {
          return
        }

        hasError.value = true
        playerRef.value.stop?.()
        emit('error', error)
      }
    }

    onMounted(() => {
      void syncSource()
    })

    watch(
      () => props.src,
      () => {
        void syncSource()
      }
    )

    onUnmounted(() => {
      activeRequestId += 1
    })

    return () =>
      h(
        'div',
        {
          class: containerClass.value,
          style: containerStyle.value
        },
        hasError.value
          ? [
              h(
                'div',
                {
                  class:
                    'flex h-full w-full min-h-[10rem] flex-col items-center justify-center rounded-[1.75rem] border border-dashed border-rose-200 bg-gradient-to-br from-rose-50 to-white px-6 py-8 text-center'
                },
                [
                  h(
                    'div',
                    {
                      class:
                        'mb-4 h-14 w-14 rounded-full bg-rose-100/90',
                      style: 'animation: float 4s ease-in-out infinite;'
                    },
                    [
                      h(
                        'div',
                        {
                          class:
                            'mx-auto mt-3 h-8 w-8 rounded-full border-2 border-rose-300 border-t-rose-500'
                        }
                      )
                    ]
                  ),
                  h(
                    'p',
                    {
                      class: 'text-sm font-semibold uppercase tracking-[0.24em] text-rose-500'
                    },
                    props.fallbackTitle
                  ),
                  h(
                    'p',
                    {
                      class: 'mt-2 max-w-xs text-sm leading-6 text-stone-500'
                    },
                    props.fallbackDescription
                  )
                ]
              )
            ]
          : [
              h('lottie-player', {
                ref: playerRef,
                class: 'h-full w-full',
                autoplay: props.autoplay,
                loop: props.loop,
                controls: props.controls,
                speed: props.speed,
                mode: props.mode,
                background: props.background,
                onComplete: (event: Event) => emit('complete', event),
                onError: (event: Event) => {
                  hasError.value = true
                  emit('error', event)
                },
                onLoad: (event: Event) => emit('load', event),
                onLoop: (event: Event) => emit('loop', event),
                onReady: (event: Event) => emit('ready', event)
              })
            ]
      )
  }
})

export default LottieAnimation
