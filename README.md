# La Fleur — Artisan Flower Boutique

> A premium flower shop built with Vue 3, TypeScript, Supabase, GSAP & Tailwind CSS.

## Features

- **40+ handcrafted bouquets** with filtering by type, color, and occasion
- **Custom bouquet builder** — craft stem-by-stem arrangements with a progress ring
- **AI bouquet recommender** — guided Q&A to find the perfect bouquet
- **Flower language & symbolism** displayed on every product
- **Wishlist** with Supabase persistence (localStorage fallback for guests)
- **Fuzzy search** with autocomplete dropdown
- **Real-time order tracking** via Supabase Realtime
- **Recurring gift scheduling** (weekly, biweekly, monthly)
- **Admin dashboard** for product and order management
- **Seasonal color themes** (auto-detects by month)
- **GSAP animations** with `prefers-reduced-motion` support
- **Responsive design** (mobile → desktop)
- **Image optimization** with WebP `<picture>` elements and responsive `srcset`

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Vue 3 + TypeScript + Vite |
| Styling | Tailwind CSS v4 + scoped CSS + GSAP animations |
| Backend | Supabase (Auth, Database, Realtime) |
| State | Pinia stores |
| Fonts | Cormorant Garamond (headings) + Inter (body) |

## Prerequisites

- **Node.js** 18+ ([download](https://nodejs.org/))
- **npm** or **pnpm**
- A **Supabase** project ([free tier works](https://supabase.com))

## Setup

### 1. Clone & install

```bash
git clone https://github.com/YOUR_USERNAME/la-fleur.git
cd la-fleur
npm install
```

### 2. Supabase setup

1. Create a new project at [supabase.com](https://supabase.com)
2. Go to **SQL Editor → New Query** and paste the contents of `database/migration.sql`
3. Click **Run** — this creates all tables, seed data (40 products, 8 occasions, 15 bouquet components), wishlists, order tracking, and flower meanings
4. Go to **Authentication → Settings → Email Auth** and disable "Confirm email" for development (or keep it enabled for production)
5. Go to **Database → Replication** and enable Realtime for the `orders` table (required for live order tracking)

### 3. Environment variables

Create a `.env` file in the project root:

```env
VITE_SUPABASE_URL=https://YOUR_PROJECT_ID.supabase.co
VITE_SUPABASE_ANON_KEY=your_anon_key_here
```

You can find these values in **Supabase → Settings → API**.

### 4. Run the dev server

```bash
npm run dev
```

The app will be available at `http://localhost:5173`.

### 5. Create an admin user

1. Register a new account through the app UI
2. In Supabase **SQL Editor**, run:
   ```sql
   UPDATE users SET role = 'admin' WHERE email = 'your@email.com';
   ```
3. Log out and log back in — you'll be redirected to `/admin`

## Project Structure

```
src/
├── pages/           # Route pages (Home, Shop, Cart, Checkout, etc.)
│   └── admin/       # Admin dashboard
├── components/      # Reusable UI (Navbar, ProductCard, SearchBar, etc.)
├── stores/          # Pinia stores (auth, cart, flowers, wishlist)
├── composables/     # Vue composables (search, meanings, seasons, etc.)
├── data/            # Static data (flower meanings, seasonal themes)
├── animations/      # GSAP motion utilities, easings, CSS keyframes
├── lib/             # Supabase client initialization
└── router/          # Vue Router with lazy loading and auth guards

database/
└── migration.sql    # Complete DB schema + seed data + extensions
```

## Available Scripts

| Command | Description |
|---------|------------|
| `npm run dev` | Start Vite dev server with HMR |
| `npm run build` | Production build (type-check + bundle) |
| `npm run preview` | Preview the production build locally |

## Database Schema

The migration file creates these tables:

| Table | Purpose |
|-------|---------|
| `users` | User accounts with role (customer/admin) |
| `products` | 40 flower products with type, color, meaning |
| `occasions` | 8 occasions (Birthday, Wedding, Valentine, etc.) |
| `product_occasions` | Many-to-many join table |
| `bouquet_components` | 15 stems/accessories for the bouquet builder |
| `orders` | Orders with delivery scheduling and recurrence |
| `order_items` | Line items per order |
| `reviews` | Product reviews with 1-5 star ratings |
| `reminders` | Personal occasion reminders |
| `wishlists` | Saved favorite products (with RLS) |
| `cart` | Server-side cart persistence |

## License

MIT
