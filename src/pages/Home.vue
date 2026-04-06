<template>
  <div class="home">

    <!-- ════ HERO ════════════════════════════════════════════════ -->
    <section class="hero">
      <canvas ref="petalCanvas" class="petal-canvas" aria-hidden="true" />
      <div class="orb orb-1" /><div class="orb orb-2" /><div class="orb orb-3" />
      <div class="hero-grid">
        <div class="hero-left">
          <div ref="eyebrowRef" class="eyebrow">
            <span class="eyebrow-line" /><span class="eyebrow-txt">Atelier Floral · Est. 2018</span>
          </div>
          <h1 ref="headlineRef" class="hero-h1">
            <span class="h1-row">Every petal</span>
            <span class="h1-row h1-italic">whispers</span>
            <span class="h1-row">a love story.</span>
          </h1>
          <p ref="bodyRef" class="hero-body">Handcrafted bouquets for the moments that deserve something extraordinary. Seasonal stems. Same-day gifting. Pure floral artistry.</p>
          <div ref="ctaRef" class="hero-ctas">
            <button class="btn-dark" type="button" @click="goShop">Explore Collection <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12,5 19,12 12,19"/></svg></button>
            <button class="btn-ghost" type="button" @click="goBuilder">Craft Your Bouquet</button>
          </div>
          <div ref="badgesRef" class="hero-badges">
            <span class="badge-item"><span class="badge-dot"/>Hand-tied daily</span>
            <span class="badge-sep"/><span class="badge-item"><span class="badge-dot"/>Same-day delivery</span>
            <span class="badge-sep"/><span class="badge-item"><span class="badge-dot"/>Free gifting wrap</span>
          </div>
        </div>
        <div ref="heroImgRef" class="hero-right">
          <div ref="tag1Ref" class="float-tag float-tag--tl">
            <span class="ft-icon">🌹</span>
            <div><p class="ft-title">This Week</p><p class="ft-sub">Red Rose Bouquet</p></div>
          </div>
          <div ref="tag2Ref" class="float-tag float-tag--br">
            <span class="ft-icon">✦</span>
            <div><p class="ft-title">Est. 2018</p><p class="ft-sub">1,200+ bouquets</p></div>
          </div>
          <div class="hero-frame">
            <div class="hero-frame__ring" />
            <div class="hero-frame__inner">
              <img :src="heroArt" alt="Handcrafted bouquet" class="hero-img" />
              <div class="hero-img__shimmer" :class="{ gone: imgLoaded }" />
            </div>
            <span class="hero-frame__corner">✿</span>
          </div>
          <div ref="scrollIndRef" class="scroll-ind"><div class="scroll-ind__line"/><span>Scroll</span></div>
        </div>
      </div>
    </section>

    <!-- ════ MARQUEE ══════════════════════════════════════════════ -->
    <div class="marquee-strip" aria-hidden="true">
      <div class="marquee-track">
        <span v-for="i in 14" :key="i" class="marquee-item">✦ La Fleur Atelier &nbsp;·&nbsp; Handcrafted with Love &nbsp;·&nbsp; Same-Day Delivery &nbsp;&nbsp;</span>
      </div>
    </div>

    <!-- ════ OCCASIONS ════════════════════════════════════════════ -->
    <section ref="occasionsRef" class="occasions">
      <div class="w-inner">
        <div class="section-head">
          <div class="section-label">Occasions</div>
          <h2 class="section-title">Styled for the moments that matter</h2>
        </div>
        <div class="occasions-grid">
          <article v-for="(occ, i) in occasions" :key="occ.title" class="occ-card" :style="{ '--i': i }" @click="occ.action">
            <div class="occ-icon-wrap">
              <svg :ref="(el) => { if (el) svgMap.set(i, el as SVGSVGElement); else svgMap.delete(i) }" class="occ-svg" viewBox="0 0 60 60" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" v-html="occ.svgPaths" />
            </div>
            <div class="occ-tag" :class="occ.tagCls">{{ occ.tag }}</div>
            <h3 class="occ-title">{{ occ.title }}</h3>
            <p class="occ-desc">{{ occ.desc }}</p>
            <span class="occ-arrow">→</span>
          </article>
        </div>
      </div>
    </section>

    <!-- ════ HOW IT WORKS ═════════════════════════════════════════ -->
    <section ref="howRef" class="how">
      <div class="w-inner">
        <div class="section-head">
          <div class="section-label">The Process</div>
          <h2 class="section-title">From stem to doorstep</h2>
        </div>
        <div class="how-grid">
          <div v-for="(step, i) in steps" :key="step.title" class="how-step">
            <div class="how-num">0{{ i + 1 }}</div>
            <div class="how-icon">{{ step.icon }}</div>
            <h3 class="how-title">{{ step.title }}</h3>
            <p class="how-desc">{{ step.desc }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- ════ FEATURED ════════════════════════════════════════════ -->
    <section ref="featuredRef" class="featured">
      <div class="w-inner">
        <div class="featured-head">
          <div><div class="section-label">Featured</div><h2 class="section-title">Favorites blooming this week</h2></div>
          <button class="btn-outline" type="button" @click="goShop">View Full Shop</button>
        </div>
        <div v-if="featured.length" class="featured-grid">
          <ProductCard v-for="p in featured" :key="p.id" :product="p" />
        </div>
        <div v-else class="featured-empty"><p class="fe-icon">🌸</p><p>Fresh bouquets loading...</p></div>
      </div>
    </section>

    <!-- ════ TESTIMONIALS ════════════════════════════════════════ -->
    <section ref="testiRef" class="testi">
      <div class="w-inner">
        <div class="section-head">
          <div class="section-label">Customer Love</div>
          <h2 class="section-title">Words from our garden</h2>
        </div>
        <div class="testi-grid">
          <div v-for="t in testimonials" :key="t.name" class="testi-card" :style="{ '--rot': t.rot }">
            <div class="testi-quote">"</div>
            <div class="testi-stars">★★★★★</div>
            <p class="testi-text">{{ t.text }}</p>
            <div class="testi-author">
              <span class="testi-avatar">{{ t.name[0] }}</span>
              <div><p class="testi-name">{{ t.name }}</p><p class="testi-meta">{{ t.meta }}</p></div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- ════ GALLERY ══════════════════════════════════════════════ -->
    <section ref="galleryRef" class="gallery">
      <div class="gallery-head">
        <div class="section-label" style="color:rgba(197,104,122,.7)">Follow the Bloom</div>
        <h2 class="section-title" style="color:#fdf6f0">@lafleur.atelier</h2>
      </div>
      <div class="gallery-grid">
        <div v-for="(img, i) in galleryImgs" :key="i" class="gallery-item">
          <img :src="img" alt="La Fleur bouquet" loading="lazy" class="gallery-img" />
          <div class="gallery-overlay"><span class="gallery-icon">✿</span></div>
        </div>
      </div>
    </section>

    <!-- ════ ABOUT ════════════════════════════════════════════════ -->
    <section ref="aboutRef" class="about">
      <div class="about-inner">
        <div class="about-left">
          <div class="section-label" style="color:#c5687a">About La Fleur</div>
          <h2 class="about-title">A flower shop built for heartfelt gifting.</h2>
          <p class="about-body">We pair graceful stems with a warm digital ordering experience so you can browse, build, and send flowers with total confidence. Every bouquet feels lush, expressive, and easy to gift.</p>
          <button class="btn-cream" type="button" @click="goShop">Start Shopping</button>
        </div>
        <div class="about-stats">
          <div v-for="stat in stats" :key="stat.label" class="stat-card" :class="stat.cls">
            <p class="stat-num">{{ stat.num }}<span>{{ stat.suffix }}</span></p>
            <p class="stat-lbl">{{ stat.label }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- ════ FOOTER ═══════════════════════════════════════════════ -->
    <footer class="footer">
      <div class="footer-inner">
        <div class="footer-brand">
          <p class="footer-logo">La Fleur</p>
          <p class="footer-tagline">Crafted with love, delivered with care.</p>
        </div>
        <div class="footer-cols">
          <div class="footer-col">
            <p class="footer-col-title">Shop</p>
            <a class="footer-link" @click="goShop">All Flowers</a>
            <a class="footer-link" @click="goBuilder">Bouquet Builder</a>
            <a class="footer-link" @click="() => router.push('/cart')">Cart</a>
          </div>
          <div class="footer-col">
            <p class="footer-col-title">Help</p>
            <a class="footer-link">Delivery Info</a>
            <a class="footer-link">Care Guide</a>
            <a class="footer-link">Contact Us</a>
          </div>
          <div class="footer-col">
            <p class="footer-col-title">Follow</p>
            <a class="footer-link">Instagram</a>
            <a class="footer-link">Facebook</a>
            <a class="footer-link">Pinterest</a>
          </div>
        </div>
      </div>
      <div class="footer-bottom">© {{ new Date().getFullYear() }} La Fleur Atelier. All rights reserved.</div>
    </footer>

  </div>
</template>

<script setup lang="ts">
import { computed, nextTick, onMounted, onUnmounted, ref } from 'vue'
import { storeToRefs } from 'pinia'
import { useRouter } from 'vue-router'
import gsap from 'gsap'
import ScrollTrigger from 'gsap/ScrollTrigger'
import heroArt from '@/assets/hero.png'
import { prefersReducedMotion } from '@/animations/motion'
import ProductCard from '@/components/ProductCard.vue'
import { useFlowerStore } from '@/stores/flowers'

gsap.registerPlugin(ScrollTrigger)

const router = useRouter()
const store  = useFlowerStore()
const { flowers } = storeToRefs(store)

const petalCanvas  = ref<HTMLCanvasElement | null>(null)
const eyebrowRef   = ref<HTMLElement | null>(null)
const headlineRef  = ref<HTMLElement | null>(null)
const bodyRef      = ref<HTMLElement | null>(null)
const ctaRef       = ref<HTMLElement | null>(null)
const badgesRef    = ref<HTMLElement | null>(null)
const heroImgRef   = ref<HTMLElement | null>(null)
const tag1Ref      = ref<HTMLElement | null>(null)
const tag2Ref      = ref<HTMLElement | null>(null)
const scrollIndRef = ref<HTMLElement | null>(null)
const occasionsRef = ref<HTMLElement | null>(null)
const howRef       = ref<HTMLElement | null>(null)
const featuredRef  = ref<HTMLElement | null>(null)
const testiRef     = ref<HTMLElement | null>(null)
const galleryRef   = ref<HTMLElement | null>(null)
const aboutRef     = ref<HTMLElement | null>(null)
const svgMap = new Map<number, SVGSVGElement>()
const imgLoaded    = ref(false)

let animCtx: gsap.Context | null = null
let petalRAF = 0

const goShop    = () => void router.push('/shop')
const goBuilder = () => void router.push('/bouquet-builder')
const featured  = computed(() => flowers.value.filter(f => f.is_available).slice(0, 3))

const occasions = [
  { tag:'Birthday', tagCls:'tag-amber', title:'Birthdays & Joy', desc:'Bright, festive bouquets that feel celebratory without losing elegance.', action:()=>goShop(),
    svgPaths:`<rect x="15" y="32" width="30" height="20" rx="2" stroke-width="1.5"/><path d="M20 32V28" stroke-width="1.5"/><path d="M30 32V26" stroke-width="1.5"/><path d="M40 32V28" stroke-width="1.5"/><path d="M20 26 Q20 22 24 24 Q20 20 20 16 Q20 20 16 24 Q20 22 20 26Z" stroke-width="1.2"/><path d="M30 24 Q30 20 34 22 Q30 18 30 14 Q30 18 26 22 Q30 20 30 24Z" stroke-width="1.2"/><path d="M40 26 Q40 22 44 24 Q40 20 40 16 Q40 20 36 24 Q40 22 40 26Z" stroke-width="1.2"/><line x1="15" y1="38" x2="45" y2="38" stroke-width="1.2"/>` },
  { tag:'Romance', tagCls:'tag-rose', title:'Anniversaries & Love', desc:'Velvety roses and rich blush textures made to feel intimate.', action:()=>goShop(),
    svgPaths:`<path d="M30 46 C30 46 12 34 12 22 C12 16 17 11 23 13 C26 14 28 16 30 18 C32 16 34 14 37 13 C43 11 48 16 48 22 C48 34 30 46 30 46Z" stroke-width="1.5"/><path d="M30 18 C28 22 25 25 25 29" stroke-width="1.2"/>` },
  { tag:'Wedding', tagCls:'tag-cream', title:'Weddings & Celebrations', desc:'Elegant white and blush arrangements for the most important day.', action:()=>goShop(),
    svgPaths:`<circle cx="22" cy="28" r="8" stroke-width="1.5"/><circle cx="38" cy="28" r="8" stroke-width="1.5"/><path d="M28 22 Q30 16 32 22" stroke-width="1.2"/><path d="M25 36 Q22 44 18 42" stroke-width="1.2"/><path d="M35 36 Q38 44 42 42" stroke-width="1.2"/>` },
  { tag:"Mother's Day", tagCls:'tag-green', title:"Mother's Day", desc:"Soft peonies and pastel gardens for the woman who deserves everything.", action:()=>goShop(),
    svgPaths:`<circle cx="30" cy="24" r="6" stroke-width="1.5"/><circle cx="20" cy="28" r="5" stroke-width="1.5"/><circle cx="40" cy="28" r="5" stroke-width="1.5"/><circle cx="24" cy="36" r="4" stroke-width="1.5"/><circle cx="36" cy="36" r="4" stroke-width="1.5"/><path d="M30 30 L30 46" stroke-width="1.5"/>` },
  { tag:'Sympathy', tagCls:'tag-slate', title:'Sympathy & Comfort', desc:'Peaceful white lilies and soft greens offering calm and care.', action:()=>goShop(),
    svgPaths:`<path d="M30 14 Q36 20 36 28 Q36 38 30 46 Q24 38 24 28 Q24 20 30 14Z" stroke-width="1.5"/><path d="M30 22 Q38 24 42 32" stroke-width="1.2"/><path d="M30 22 Q22 24 18 32" stroke-width="1.2"/>` },
  { tag:'Graduation', tagCls:'tag-amber', title:'Graduation & Milestones', desc:'Bold bouquets for achievements that deserve real celebration.', action:()=>goShop(),
    svgPaths:`<polygon points="30,14 46,22 30,30 14,22" stroke-width="1.5"/><path d="M22 26 L22 38 Q30 44 38 38 L38 26" stroke-width="1.5"/><line x1="46" y1="22" x2="46" y2="34" stroke-width="1.5"/><circle cx="46" cy="36" r="2" stroke-width="1.5"/>` },
  { tag:'Valentine', tagCls:'tag-rose', title:"Valentine's Day", desc:"Deep reds and passionate blooms that speak louder than words.", action:()=>goShop(),
    svgPaths:`<path d="M30 42 L14 26 C10 20 14 12 20 12 C24 12 27 15 30 18 C33 15 36 12 40 12 C46 12 50 20 46 26 Z" stroke-width="1.5"/>` },
  { tag:'Just Because', tagCls:'tag-green', title:'Just Because', desc:'Sometimes a bouquet needs no reason — just love and spontaneity.', action:()=>goShop(),
    svgPaths:`<circle cx="30" cy="22" r="8" stroke-width="1.5"/><path d="M24 18 Q26 14 30 16 Q34 14 36 18" stroke-width="1.2"/><path d="M30 30 L30 46" stroke-width="1.5"/><path d="M22 38 Q18 34 18 30 Q22 28 26 32" stroke-width="1.2"/><path d="M38 38 Q42 34 42 30 Q38 28 34 32" stroke-width="1.2"/>` },
]

const steps = [
  { icon:'🌸', title:'Browse the Collection', desc:'Explore 40+ handcrafted bouquets filtered by type, color, and occasion.' },
  { icon:'✂️', title:'Customize or Build', desc:'Choose from ready arrangements or build your own stem by stem in our bouquet builder.' },
  { icon:'🚚', title:'Delivered with Care', desc:'Same-day delivery available. Every order wrapped and tagged by hand.' },
]

const testimonials = [
  { name:'Sophie Laurent', meta:'Anniversary order', rot:'-2deg', text:"The roses arrived absolutely perfect — still fresh three days later. La Fleur made our anniversary feel like a fairytale." },
  { name:'Mia Chen', meta:'Birthday surprise', rot:'0deg', text:"I built my mum's bouquet using the builder and it came out even more beautiful than I imagined. She cried happy tears." },
  { name:'James Harlow', meta:'First-time customer', rot:'2deg', text:"I've never felt so confident ordering flowers online. The photos matched exactly. Will be ordering every month." },
]

const galleryImgs = [
  'https://images.unsplash.com/photo-1487530811015-780f4d5b8b7e?w=400&q=80',
  'https://images.unsplash.com/photo-1490750967868-88df5691cc0e?w=400&q=80',
  'https://images.unsplash.com/photo-1559563362-c667ba5f5480?w=400&q=80',
  'https://images.unsplash.com/photo-1518895949257-7621c3c786d7?w=400&q=80',
  'https://images.unsplash.com/photo-1548094990-c16ca90f1f0d?w=400&q=80',
  'https://images.unsplash.com/photo-1508610048659-a06b669e3321?w=400&q=80',
]

const stats = [
  { num:'1,200', suffix:'+', label:'Bouquets crafted', cls:'stat-rose' },
  { num:'Same',  suffix:'-day', label:'Delivery available', cls:'stat-green' },
  { num:'100',   suffix:'%',   label:'Hand-tied fresh', cls:'stat-amber' },
]

// ── Petal canvas ───────────────────────────────────────────────
interface Petal { x:number;y:number;size:number;speedY:number;speedX:number;rot:number;rotSpeed:number;opacity:number;hue:number }
function freshPetal(w:number):Petal {
  return {x:Math.random()*w,y:-20-Math.random()*200,size:5+Math.random()*9,
    speedY:.4+Math.random()*.8,speedX:-.3+Math.random()*.6,
    rot:Math.random()*Math.PI*2,rotSpeed:(Math.random()-.5)*.025,
    opacity:.15+Math.random()*.3,hue:340+Math.random()*20}
}
function initPetals(){
  const cv=petalCanvas.value;if(!cv)return
  const ctx=cv.getContext('2d');if(!ctx)return
  // Capture as non-null constants so the inner draw closure can use them safely
  const canvas: HTMLCanvasElement = cv
  const context: CanvasRenderingContext2D = ctx
  const resize=()=>{canvas.width=window.innerWidth;canvas.height=window.innerHeight}
  resize();window.addEventListener('resize',resize)
  const petals:Petal[]=Array.from({length:18},()=>freshPetal(canvas.width))
  function draw(){
    context.clearRect(0,0,canvas.width,canvas.height)
    petals.forEach(p=>{
      context.save();context.translate(p.x,p.y);context.rotate(p.rot);context.globalAlpha=p.opacity
      context.beginPath()
      context.moveTo(0,-p.size);context.bezierCurveTo(p.size*.8,-p.size*.4,p.size*.8,p.size*.4,0,p.size)
      context.bezierCurveTo(-p.size*.8,p.size*.4,-p.size*.8,-p.size*.4,0,-p.size)
      context.fillStyle=`hsl(${p.hue},60%,80%)`;context.fill();context.restore()
      p.y+=p.speedY;p.x+=p.speedX+Math.sin(p.y*.01)*.4;p.rot+=p.rotSpeed
      if(p.y>canvas.height+30){const f=freshPetal(canvas.width);p.x=f.x;p.y=f.y;p.size=f.size;p.speedY=f.speedY;p.speedX=f.speedX;p.rot=f.rot;p.rotSpeed=f.rotSpeed;p.opacity=f.opacity;p.hue=f.hue}
    })
    petalRAF=requestAnimationFrame(draw)
  }
  draw()
}

// ── SVG self-draw ──────────────────────────────────────────────
function animateSVGs(){
  svgMap.forEach((svg, i) => {
    svg.querySelectorAll('path,line,rect,circle,polygon').forEach((el,j)=>{
      const ge=el as SVGGeometryElement
      let len=60
      try{ if(ge.getTotalLength) len=ge.getTotalLength() }catch{ /* ok */ }
      gsap.set(ge,{strokeDasharray:len,strokeDashoffset:len})
      gsap.to(ge,{strokeDashoffset:0,duration:1.3,ease:'power2.inOut',
        delay:i*.08+j*.1,
        scrollTrigger:{trigger:svg,start:'top 88%',once:true}})
    })
  })
}

// ── Main animations ────────────────────────────────────────────
async function initAnim(){
  await nextTick()
  animCtx?.revert()
  ScrollTrigger.getAll().forEach(t=>t.kill())
  if(prefersReducedMotion())return

  animCtx=gsap.context(()=>{
    const tl=gsap.timeline({defaults:{ease:'power3.out'}})
    if(eyebrowRef.value)  tl.from(eyebrowRef.value, {x:-30,opacity:0,duration:.7},0.2)
    if(headlineRef.value) tl.from(headlineRef.value.querySelectorAll('.h1-row'),{y:60,opacity:0,duration:.9,stagger:.12,ease:'power4.out'},0.4)
    if(bodyRef.value)     tl.from(bodyRef.value,  {y:30,opacity:0,duration:.7},'-=0.4')
    if(ctaRef.value)      tl.from(ctaRef.value,   {y:20,opacity:0,duration:.6},'-=0.3')
    if(badgesRef.value)   tl.from(badgesRef.value,{y:15,opacity:0,duration:.5},'-=0.2')
    if(heroImgRef.value)  tl.from(heroImgRef.value,{scale:.88,opacity:0,duration:1.1,ease:'back.out(1.3)'},0.5)
    if(tag1Ref.value)     tl.from(tag1Ref.value,  {x:20,opacity:0,duration:.6,ease:'back.out(1.7)'},1.1)
    if(tag2Ref.value)     tl.from(tag2Ref.value,  {x:-20,opacity:0,duration:.6,ease:'back.out(1.7)'},1.25)
    if(scrollIndRef.value)tl.from(scrollIndRef.value,{opacity:0,duration:.5},1.5)

    if(tag1Ref.value) gsap.to(tag1Ref.value,{y:-10,duration:3,ease:'sine.inOut',repeat:-1,yoyo:true})
    if(tag2Ref.value) gsap.to(tag2Ref.value,{y:8,duration:3.5,ease:'sine.inOut',repeat:-1,yoyo:true,delay:.5})

    ;[occasionsRef,howRef,featuredRef,testiRef,galleryRef,aboutRef].forEach(r=>{
      if(!r.value)return
      gsap.from(r.value,{y:50,autoAlpha:0,duration:.85,ease:'power2.out',immediateRender:false,scrollTrigger:{trigger:r.value,start:'top 82%',invalidateOnRefresh:true}})
    })

    gsap.from('.occ-card',{y:40,autoAlpha:0,scale:.95,duration:.7,stagger:.09,ease:'back.out(1.4)',immediateRender:false,
      scrollTrigger:{trigger:'.occasions-grid',start:'top 85%',invalidateOnRefresh:true}})
    gsap.from('.how-step',{x:-40,opacity:0,duration:.7,stagger:.18,ease:'power2.out',
      scrollTrigger:{trigger:'.how-grid',start:'top 80%'}})
    gsap.from('.testi-card',{y:50,opacity:0,duration:.85,stagger:.14,ease:'back.out(1.4)',
      scrollTrigger:{trigger:'.testi-grid',start:'top 80%'}})
    gsap.from('.gallery-item',{scale:.85,opacity:0,duration:.6,stagger:.07,ease:'back.out(1.4)',
      scrollTrigger:{trigger:'.gallery-grid',start:'top 82%'}})

    animateSVGs()
  })
}

onMounted(async()=>{
  if(!flowers.value.length) await store.fetchFlowers()
  initPetals()
  await initAnim()
  setTimeout(()=>{imgLoaded.value=true},400)
})
onUnmounted(()=>{
  cancelAnimationFrame(petalRAF)
  svgMap.clear()
  animCtx?.revert()
  ScrollTrigger.getAll().forEach(t=>t.kill())
})
</script>

<style scoped>
.home{font-family:'Cormorant Garamond','Playfair Display',Georgia,serif}

/* HERO */
.hero{position:relative;min-height:100svh;display:flex;align-items:center;overflow:hidden;padding-top:90px;background:linear-gradient(135deg,#fdf6f0 0%,#fef0ee 30%,#fdf4f0 60%,#f5ede8 100%)}
.petal-canvas{position:absolute;inset:0;width:100%;height:100%;pointer-events:none;z-index:0}
.orb{position:absolute;border-radius:50%;filter:blur(80px);pointer-events:none;z-index:0}
.orb-1{width:600px;height:600px;background:radial-gradient(circle,rgba(229,149,149,.22) 0%,transparent 70%);top:-100px;left:-100px;animation:orb 18s ease-in-out infinite alternate}
.orb-2{width:500px;height:500px;background:radial-gradient(circle,rgba(155,195,155,.18) 0%,transparent 70%);bottom:-80px;right:-80px;animation:orb 22s ease-in-out infinite alternate-reverse}
.orb-3{width:300px;height:300px;background:radial-gradient(circle,rgba(240,190,140,.18) 0%,transparent 70%);top:40%;left:40%;animation:orb 14s ease-in-out infinite alternate}
@keyframes orb{from{transform:translate(0,0) scale(1)}to{transform:translate(40px,30px) scale(1.08)}}
.hero-grid{position:relative;z-index:1;width:100%;max-width:1280px;margin:0 auto;padding:60px 40px 80px;display:grid;grid-template-columns:1fr 1fr;gap:60px;align-items:center}
@media(max-width:900px){.hero-grid{grid-template-columns:1fr;padding:40px 24px 60px;gap:40px}}
.eyebrow{display:flex;align-items:center;gap:14px;margin-bottom:28px}
.eyebrow-line{display:block;width:40px;height:1px;background:#c5687a}
.eyebrow-txt{font-family:'Inter',sans-serif;font-size:.72rem;font-weight:600;letter-spacing:.22em;text-transform:uppercase;color:#c5687a}
.hero-h1{display:flex;flex-direction:column;font-size:clamp(2.8rem,5.5vw,5rem);font-weight:400;line-height:1.08;letter-spacing:-.01em;color:#1e0f0f;margin:0 0 28px}
.h1-row{display:block}
.h1-italic{font-style:italic;color:#c5687a;font-weight:300}
.hero-body{font-family:'Inter',sans-serif;font-size:1rem;line-height:1.75;color:#6b4a4a;max-width:440px;margin:0 0 36px}
.hero-ctas{display:flex;gap:14px;flex-wrap:wrap;margin-bottom:36px}
.btn-dark{display:inline-flex;align-items:center;gap:10px;padding:14px 28px;background:#2d1a1a;color:#fdf6f0;border:none;border-radius:100px;font-family:'Inter',sans-serif;font-size:.88rem;font-weight:500;letter-spacing:.04em;cursor:pointer;transition:all .3s cubic-bezier(.34,1.56,.64,1);box-shadow:0 6px 24px rgba(45,26,26,.25)}
.btn-dark:hover{background:#c5687a;transform:translateY(-3px) scale(1.02);box-shadow:0 12px 32px rgba(197,104,122,.4)}
.btn-ghost{display:inline-flex;align-items:center;padding:14px 28px;background:transparent;color:#2d1a1a;border:1.5px solid rgba(45,26,26,.25);border-radius:100px;font-family:'Inter',sans-serif;font-size:.88rem;font-weight:500;letter-spacing:.04em;cursor:pointer;transition:all .3s ease}
.btn-ghost:hover{border-color:#c5687a;color:#c5687a}
.hero-badges{display:flex;align-items:center;gap:16px;flex-wrap:wrap}
.badge-item{display:flex;align-items:center;gap:7px;font-family:'Inter',sans-serif;font-size:.78rem;color:#8a6060}
.badge-dot{width:5px;height:5px;border-radius:50%;background:#c5687a;opacity:.7}
.badge-sep{width:1px;height:14px;background:rgba(197,104,122,.25)}
.hero-right{position:relative;display:flex;align-items:center;justify-content:center}
.float-tag{position:absolute;z-index:10;display:flex;align-items:center;gap:10px;background:rgba(255,252,250,.92);backdrop-filter:blur(16px);-webkit-backdrop-filter:blur(16px);border:1px solid rgba(197,104,122,.2);border-radius:14px;padding:10px 16px;box-shadow:0 8px 32px rgba(197,104,122,.15)}
.float-tag--tl{top:12%;right:-10%}
.float-tag--br{bottom:14%;left:-8%}
@media(max-width:900px){.float-tag--tl{top:8%;right:4%}.float-tag--br{bottom:8%;left:4%}}
.ft-icon{font-size:1.3rem}
.ft-title{font-family:'Inter',sans-serif;font-size:.68rem;font-weight:600;letter-spacing:.1em;text-transform:uppercase;color:#a07070;margin:0}
.ft-sub{font-size:.9rem;font-weight:500;color:#2d1a1a;margin:0}
.hero-frame{position:relative;width:100%;max-width:500px}
.hero-frame__ring{position:absolute;inset:-16px;border-radius:40px;border:1.5px solid rgba(197,104,122,.2);pointer-events:none;animation:ring-breathe 5s ease-in-out infinite}
@keyframes ring-breathe{0%,100%{transform:scale(1);opacity:.6}50%{transform:scale(1.012);opacity:1}}
.hero-frame__inner{position:relative;border-radius:32px;overflow:hidden;aspect-ratio:4/5;box-shadow:0 40px 100px rgba(45,26,26,.22),0 10px 30px rgba(197,104,122,.18)}
.hero-img{width:100%;height:100%;object-fit:cover;display:block;transition:transform 8s ease}
.hero-img:hover{transform:scale(1.04)}
.hero-img__shimmer{position:absolute;inset:0;background:linear-gradient(135deg,#fdf6f0 0%,rgba(253,246,240,.5) 50%,transparent 100%);transition:opacity .8s ease;pointer-events:none}
.hero-img__shimmer.gone{opacity:0}
.hero-frame__corner{position:absolute;top:-18px;left:-18px;font-size:2rem;color:#c5687a;opacity:.5;animation:spin-slow 20s linear infinite}
@keyframes spin-slow{from{transform:rotate(0deg)}to{transform:rotate(360deg)}}
.scroll-ind{position:absolute;bottom:-30px;right:10px;display:flex;flex-direction:column;align-items:center;gap:6px;font-family:'Inter',sans-serif;font-size:.65rem;letter-spacing:.14em;text-transform:uppercase;color:#a07070;opacity:.7}
.scroll-ind__line{width:1px;height:40px;background:linear-gradient(to bottom,#c5687a,transparent);animation:scroll-pulse 2s ease-in-out infinite}
@keyframes scroll-pulse{0%,100%{opacity:.3;transform:scaleY(.5);transform-origin:top}50%{opacity:1;transform:scaleY(1)}}

/* MARQUEE */
.marquee-strip{background:#1e0f0f;overflow:hidden;padding:14px 0;border-top:1px solid rgba(197,104,122,.15)}
.marquee-track{display:flex;animation:marquee 32s linear infinite;width:max-content}
.marquee-item{font-family:'Cormorant Garamond',Georgia,serif;font-size:1rem;font-style:italic;color:rgba(253,246,240,.5);white-space:nowrap;letter-spacing:.04em}
@keyframes marquee{from{transform:translateX(0)}to{transform:translateX(-50%)}}

/* SHARED */
.w-inner{max-width:1280px;margin:0 auto;padding:80px 40px}
@media(max-width:768px){.w-inner{padding:60px 24px}}
.section-label{font-family:'Inter',sans-serif;font-size:.7rem;font-weight:700;letter-spacing:.25em;text-transform:uppercase;color:#c5687a;margin-bottom:12px}
.section-title{font-size:clamp(1.8rem,3.5vw,2.8rem);font-weight:400;color:#1e0f0f;line-height:1.15;margin:0}
.section-head{margin-bottom:48px}

/* OCCASIONS */
.occasions{background:#fff8f4;border-top:1px solid rgba(197,104,122,.1)}
.occasions-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:18px}
@media(max-width:1100px){.occasions-grid{grid-template-columns:repeat(2,1fr)}}
@media(max-width:580px){.occasions-grid{grid-template-columns:1fr}}
.occ-card{background:white;border:1px solid rgba(197,104,122,.12);border-radius:22px;padding:26px 20px;cursor:pointer;transition:all .35s cubic-bezier(.34,1.56,.64,1);position:relative;overflow:hidden}
.occ-card::before{content:'';position:absolute;inset:0;background:linear-gradient(135deg,rgba(197,104,122,.04),transparent);opacity:0;transition:opacity .3s}
.occ-card:hover{transform:translateY(-10px);box-shadow:0 24px 60px rgba(197,104,122,.2);border-color:rgba(197,104,122,.35)}
.occ-card:hover::before{opacity:1}
.occ-icon-wrap{width:56px;height:56px;margin-bottom:16px}
.occ-svg{width:100%;height:100%;color:#c5687a}
.occ-tag{display:inline-block;font-family:'Inter',sans-serif;font-size:.63rem;font-weight:700;letter-spacing:.15em;text-transform:uppercase;padding:3px 10px;border-radius:100px;margin-bottom:12px}
.tag-amber{background:#fef3c7;color:#92400e}
.tag-rose{background:#fce7f3;color:#9d174d}
.tag-green{background:#d1fae5;color:#065f46}
.tag-cream{background:#fdf6f0;color:#7c5a3a}
.tag-slate{background:#f1f5f9;color:#475569}
.occ-title{font-size:1.05rem;font-weight:500;color:#1e0f0f;margin:0 0 8px;line-height:1.3}
.occ-desc{font-family:'Inter',sans-serif;font-size:.8rem;line-height:1.6;color:#8a6060;margin:0 0 16px}
.occ-arrow{font-size:1rem;color:#c5687a;transition:transform .3s ease}
.occ-card:hover .occ-arrow{transform:translateX(6px)}

/* HOW IT WORKS */
.how{background:linear-gradient(180deg,#fdf6f0 0%,#fff8f4 100%)}
.how-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:0;position:relative}
@media(max-width:768px){.how-grid{grid-template-columns:1fr;gap:40px}}
.how-step{position:relative;padding:0 32px;text-align:center}
.how-step:not(:last-child)::after{content:'';position:absolute;top:28px;right:0;width:1px;height:60px;background:linear-gradient(to bottom,rgba(197,104,122,.3),transparent)}
@media(max-width:768px){.how-step::after{display:none}}
.how-num{font-size:3.5rem;font-weight:300;color:rgba(197,104,122,.18);line-height:1;margin-bottom:12px}
.how-icon{font-size:2rem;margin-bottom:14px}
.how-title{font-size:1.2rem;font-weight:500;color:#1e0f0f;margin:0 0 10px}
.how-desc{font-family:'Inter',sans-serif;font-size:.85rem;line-height:1.65;color:#8a6060;margin:0}

/* FEATURED */
.featured{background:#fdf6f0}
.featured-head{display:flex;align-items:flex-end;justify-content:space-between;margin-bottom:48px;gap:20px;flex-wrap:wrap}
.btn-outline{font-family:'Inter',sans-serif;font-size:.82rem;font-weight:500;padding:10px 22px;border-radius:100px;border:1.5px solid rgba(45,26,26,.2);background:transparent;color:#2d1a1a;cursor:pointer;transition:all .25s ease;white-space:nowrap}
.btn-outline:hover{border-color:#c5687a;color:#c5687a}
.featured-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:24px}
@media(max-width:900px){.featured-grid{grid-template-columns:repeat(2,1fr)}}
@media(max-width:580px){.featured-grid{grid-template-columns:1fr}}
.featured-empty{text-align:center;padding:60px 20px;background:white;border-radius:24px;border:1px dashed rgba(197,104,122,.25)}
.fe-icon{font-size:2.5rem;margin-bottom:12px}
.featured-empty p{font-family:'Inter',sans-serif;color:#a07070;font-size:.9rem}

/* TESTIMONIALS */
.testi{background:#fff8f4;border-top:1px solid rgba(197,104,122,.1)}
.testi-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:24px}
@media(max-width:900px){.testi-grid{grid-template-columns:1fr}}
.testi-card{background:white;border:1px solid rgba(197,104,122,.12);border-radius:24px;padding:32px 28px;position:relative;transition:transform .4s cubic-bezier(.34,1.56,.64,1),box-shadow .4s ease;transform:rotate(var(--rot,0deg))}
.testi-card:hover{transform:rotate(0deg) translateY(-8px);box-shadow:0 24px 60px rgba(197,104,122,.16)}
.testi-quote{position:absolute;top:16px;right:22px;font-size:5rem;color:rgba(197,104,122,.1);line-height:1;pointer-events:none}
.testi-stars{color:#c5687a;font-size:.9rem;margin-bottom:16px;letter-spacing:.08em}
.testi-text{font-style:italic;font-size:1.05rem;line-height:1.7;color:#3a2020;margin:0 0 24px}
.testi-author{display:flex;align-items:center;gap:12px}
.testi-avatar{width:38px;height:38px;border-radius:50%;background:linear-gradient(135deg,#e8a0b4,#c5687a);display:flex;align-items:center;justify-content:center;color:white;font-size:.95rem;font-weight:600;font-family:'Inter',sans-serif;flex-shrink:0}
.testi-name{font-size:.95rem;font-weight:500;color:#1e0f0f;margin:0}
.testi-meta{font-family:'Inter',sans-serif;font-size:.75rem;color:#a07070;margin:0}

/* GALLERY */
.gallery{background:#1e0f0f;padding:80px 0 0}
.gallery-head{text-align:center;padding:0 40px 48px}
.gallery-grid{display:grid;grid-template-columns:repeat(6,1fr)}
@media(max-width:900px){.gallery-grid{grid-template-columns:repeat(3,1fr)}}
@media(max-width:500px){.gallery-grid{grid-template-columns:repeat(2,1fr)}}
.gallery-item{position:relative;aspect-ratio:1;overflow:hidden;cursor:pointer}
.gallery-img{width:100%;height:100%;object-fit:cover;display:block;transition:transform .6s ease}
.gallery-item:hover .gallery-img{transform:scale(1.08)}
.gallery-overlay{position:absolute;inset:0;background:rgba(197,104,122,0);display:flex;align-items:center;justify-content:center;transition:background .3s ease}
.gallery-item:hover .gallery-overlay{background:rgba(197,104,122,.4)}
.gallery-icon{font-size:1.8rem;color:white;opacity:0;transform:scale(.6);transition:all .3s cubic-bezier(.34,1.56,.64,1)}
.gallery-item:hover .gallery-icon{opacity:1;transform:scale(1)}

/* ABOUT */
.about{background:#1e0f0f}
.about-inner{max-width:1280px;margin:0 auto;padding:100px 40px;display:grid;grid-template-columns:1fr 1fr;gap:80px;align-items:center}
@media(max-width:900px){.about-inner{grid-template-columns:1fr;padding:70px 24px;gap:48px}}
.about-title{font-size:clamp(1.8rem,3vw,2.6rem);font-weight:400;color:#fdf6f0;line-height:1.2;margin:12px 0 20px}
.about-body{font-family:'Inter',sans-serif;font-size:.95rem;line-height:1.8;color:rgba(253,246,240,.6);margin:0 0 36px;max-width:440px}
.btn-cream{display:inline-flex;align-items:center;padding:13px 28px;background:#fdf6f0;color:#1e0f0f;border:none;border-radius:100px;font-family:'Inter',sans-serif;font-size:.88rem;font-weight:600;cursor:pointer;transition:all .3s cubic-bezier(.34,1.56,.64,1)}
.btn-cream:hover{background:#e8a0b4;transform:translateY(-2px)}
.about-stats{display:flex;flex-direction:column;gap:20px}
.stat-card{border-radius:20px;padding:28px 32px}
.stat-rose{background:rgba(197,104,122,.15);border:1px solid rgba(197,104,122,.25)}
.stat-green{background:rgba(52,120,80,.15);border:1px solid rgba(52,120,80,.25)}
.stat-amber{background:rgba(210,150,60,.15);border:1px solid rgba(210,150,60,.25)}
.stat-num{font-size:2.2rem;font-weight:400;color:#fdf6f0;margin:0 0 4px;line-height:1}
.stat-num span{font-size:1.2rem;color:#c5687a}
.stat-lbl{font-family:'Inter',sans-serif;font-size:.8rem;color:rgba(253,246,240,.5);letter-spacing:.06em;margin:0}

/* FOOTER */
.footer{background:#150909;border-top:1px solid rgba(197,104,122,.12)}
.footer-inner{max-width:1280px;margin:0 auto;padding:70px 40px 40px;display:grid;grid-template-columns:1fr 2fr;gap:80px;align-items:start}
@media(max-width:768px){.footer-inner{grid-template-columns:1fr;gap:48px;padding:50px 24px 30px}}
.footer-logo{font-size:2rem;font-weight:400;color:#fdf6f0;letter-spacing:.12em;text-transform:uppercase;margin:0 0 8px;cursor:default;transition:color .3s ease}
.footer-logo:hover{color:#c5687a}
.footer-tagline{font-family:'Inter',sans-serif;font-size:.82rem;color:rgba(253,246,240,.4);margin:0;letter-spacing:.04em}
.footer-cols{display:grid;grid-template-columns:repeat(3,1fr);gap:40px}
@media(max-width:500px){.footer-cols{grid-template-columns:1fr;gap:32px}}
.footer-col{display:flex;flex-direction:column;gap:10px}
.footer-col-title{font-family:'Inter',sans-serif;font-size:.68rem;font-weight:700;letter-spacing:.2em;text-transform:uppercase;color:rgba(253,246,240,.4);margin:0 0 6px}
.footer-link{font-family:'Inter',sans-serif;font-size:.85rem;color:rgba(253,246,240,.55);text-decoration:none;cursor:pointer;transition:color .2s ease;padding:2px 0}
.footer-link:hover{color:#c5687a}
.footer-bottom{border-top:1px solid rgba(197,104,122,.1);padding:20px 40px;text-align:center;font-family:'Inter',sans-serif;font-size:.75rem;color:rgba(253,246,240,.3)}
@media(max-width:768px){.footer-bottom{padding:20px 24px}}
</style>