-- ============================================================
-- FLOWER SHOP — MIGRATION V2
-- Run this AFTER the original schema + seed data.
-- Adds: wishlists, flower meanings, gift scheduling,
--        order tracking (realtime-ready), bouquet price alias.
-- ============================================================
-- ============================================================
-- FLOWER SHOP DATABASE
-- ============================================================

-- USERS
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  full_name TEXT NOT NULL,
  role TEXT DEFAULT 'customer' CHECK (role IN ('customer', 'admin')),
  created_at TIMESTAMP DEFAULT NOW()
);

-- OCCASIONS
CREATE TABLE occasions (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  image_url TEXT
);

-- PRODUCTS
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  price NUMERIC(10, 2) NOT NULL,
  stock INT DEFAULT 0,
  image_url TEXT,
  type TEXT,
  color TEXT,
  is_available BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT NOW()
);

-- PRODUCT OCCASIONS (join table)
CREATE TABLE product_occasions (
  product_id INT REFERENCES products(id) ON DELETE CASCADE,
  occasion_id INT REFERENCES occasions(id) ON DELETE CASCADE,
  PRIMARY KEY (product_id, occasion_id)
);

-- BOUQUET COMPONENTS
CREATE TABLE bouquet_components (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  price NUMERIC(10, 2) NOT NULL,
  image_url TEXT,
  stock INT DEFAULT 0
);

-- ORDERS
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'shipped', 'delivered', 'cancelled')),
  total_price NUMERIC(10, 2) NOT NULL,
  delivery_date DATE,
  delivery_address TEXT,
  message_card TEXT,
  is_surprise BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW()
);

-- ORDER ITEMS
CREATE TABLE order_items (
  id SERIAL PRIMARY KEY,
  order_id INT REFERENCES orders(id) ON DELETE CASCADE,
  product_id INT REFERENCES products(id) ON DELETE SET NULL,
  quantity INT NOT NULL,
  unit_price NUMERIC(10, 2) NOT NULL
);

-- ORDER BOUQUET ITEMS
CREATE TABLE order_bouquet_items (
  id SERIAL PRIMARY KEY,
  order_id INT REFERENCES orders(id) ON DELETE CASCADE,
  component_id INT REFERENCES bouquet_components(id) ON DELETE SET NULL,
  quantity INT NOT NULL
);

-- REVIEWS
CREATE TABLE reviews (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  product_id INT REFERENCES products(id) ON DELETE CASCADE,
  rating INT CHECK (rating BETWEEN 1 AND 5),
  comment TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- REMINDERS
CREATE TABLE reminders (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  occasion_name TEXT NOT NULL,
  reminder_date DATE NOT NULL,
  message TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- CART
CREATE TABLE cart (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  product_id INT REFERENCES products(id) ON DELETE CASCADE,
  quantity INT DEFAULT 1,
  created_at TIMESTAMP DEFAULT NOW()
);


-- ============================================================
-- SEED DATA
-- ============================================================

-- OCCASIONS
INSERT INTO occasions (name, slug, image_url) VALUES
  ('Birthday', 'birthday', 'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400&q=80'),
  ('Anniversary', 'anniversary', 'https://images.unsplash.com/photo-1487530811176-3780de880c2d?w=400&q=80'),
  ('Sympathy', 'sympathy', 'https://images.unsplash.com/photo-1501167786120-b237a1c1eb5a?w=400&q=80'),
  ('Wedding', 'wedding', 'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=400&q=80'),
  ('Valentine', 'valentine', 'https://images.unsplash.com/photo-1490750967868-88df5691cc0e?w=400&q=80'),
  ('Mother''s Day', 'mothers-day', 'https://images.unsplash.com/photo-1562690868-60bbe7293e94?w=400&q=80'),
  ('Graduation', 'graduation', 'https://images.unsplash.com/photo-1551893478-d60cc4042aca?w=400&q=80'),
  ('Just Because', 'just-because', 'https://images.unsplash.com/photo-1444021465936-c6ca81d39b84?w=400&q=80');


-- PRODUCTS (40 flowers)
INSERT INTO products (name, description, price, stock, image_url, type, color) VALUES
  ('Red Rose Bouquet', 'Classic red roses symbolizing deep love and passion. Perfect for romantic occasions.', 45.00, 50, 'https://images.unsplash.com/photo-1490750967868-88df5691cc0e?w=600&q=80', 'Rose', 'Red'),
  ('Pink Rose Bundle', 'Soft pink roses expressing admiration and sweetness. A timeless gift.', 38.00, 60, 'https://images.unsplash.com/photo-1455659817273-f96807779a8a?w=600&q=80', 'Rose', 'Pink'),
  ('White Rose Elegance', 'Pure white roses representing new beginnings and purity. Great for weddings.', 42.00, 45, 'https://images.unsplash.com/photo-1558652093-3685a170faa5?w=600&q=80', 'Rose', 'White'),
  ('Yellow Rose Sunshine', 'Bright yellow roses conveying friendship and joy. Cheer someone up today.', 35.00, 55, 'https://images.unsplash.com/photo-1548460397-fbe0be4e04f5?w=600&q=80', 'Rose', 'Yellow'),
  ('Orange Rose Bouquet', 'Vibrant orange roses full of energy and enthusiasm. A bold statement.', 40.00, 40, 'https://images.unsplash.com/photo-1526047932273-341f2a7631f9?w=600&q=80', 'Rose', 'Orange'),
  ('Lavender Rose Mix', 'Enchanting lavender roses representing love at first sight.', 48.00, 35, 'https://images.unsplash.com/photo-1495231916356-a86217efff12?w=600&q=80', 'Rose', 'Purple'),
  ('Garden Rose Collection', 'A lush mix of garden roses in pastel tones. Romantic and full.', 55.00, 30, 'https://images.unsplash.com/photo-1563241527-3004b7be0ffd?w=600&q=80', 'Rose', 'Mixed'),
  ('Dried Rose Wreath', 'Preserved dried roses that last forever. A unique and lasting gift.', 62.00, 20, 'https://images.unsplash.com/photo-1501004318855-e27dae1715fc?w=600&q=80', 'Rose', 'Blush'),

  ('Purple Tulip Bunch', 'Bold purple tulips representing royalty and elegance.', 32.00, 65, 'https://images.unsplash.com/photo-1520763185298-1b434c919102?w=600&q=80', 'Tulip', 'Purple'),
  ('Pink Tulip Dream', 'Delicate pink tulips with a fresh spring feel. Light and lovely.', 28.00, 70, 'https://images.unsplash.com/photo-1518701005037-d53b1b15b1eb?w=600&q=80', 'Tulip', 'Pink'),
  ('White Tulip Grace', 'Clean white tulips offering a simple and elegant look.', 30.00, 60, 'https://images.unsplash.com/photo-1524386416438-98b9b2d4b433?w=600&q=80', 'Tulip', 'White'),
  ('Red Tulip Passion', 'Fiery red tulips for a bold declaration of love.', 33.00, 55, 'https://images.unsplash.com/photo-1488750423832-5a4b0f37df89?w=600&q=80', 'Tulip', 'Red'),
  ('Yellow Tulip Bright', 'Sunny yellow tulips that radiate happiness and warmth.', 27.00, 75, 'https://images.unsplash.com/photo-1461530927168-44328109da52?w=600&q=80', 'Tulip', 'Yellow'),
  ('Mixed Tulip Garden', 'A colorful mix of tulips in a beautiful spring arrangement.', 36.00, 50, 'https://images.unsplash.com/photo-1517697471339-4aa32003c11a?w=600&q=80', 'Tulip', 'Mixed'),

  ('Blue Hydrangea Cloud', 'Full, fluffy blue hydrangeas that make a stunning visual statement.', 44.00, 40, 'https://images.unsplash.com/photo-1530092285049-1c42085fd395?w=600&q=80', 'Hydrangea', 'Blue'),
  ('Pink Hydrangea Puff', 'Soft pink hydrangeas perfect for feminine and romantic arrangements.', 42.00, 45, 'https://images.unsplash.com/photo-1457089328109-e5d9bd499191?w=600&q=80', 'Hydrangea', 'Pink'),
  ('White Hydrangea Pure', 'Crisp white hydrangeas adding texture and volume to any bouquet.', 40.00, 50, 'https://images.unsplash.com/photo-1561181286-d3fee7d55364?w=600&q=80', 'Hydrangea', 'White'),
  ('Purple Hydrangea Royal', 'Deep purple hydrangeas with a luxurious and rich appearance.', 46.00, 35, 'https://images.unsplash.com/photo-1504567961542-e24d9439a724?w=600&q=80', 'Hydrangea', 'Purple'),

  ('White Lily Serenity', 'Elegant white lilies known for their calming and pure beauty.', 38.00, 55, 'https://images.unsplash.com/photo-1501577316686-62e37ea27c2b?w=600&q=80', 'Lily', 'White'),
  ('Pink Stargazer Lily', 'Dramatic pink stargazer lilies with a powerful fragrance.', 43.00, 40, 'https://images.unsplash.com/photo-1467781687645-c7dc2de49cba?w=600&q=80', 'Lily', 'Pink'),
  ('Orange Tiger Lily', 'Bold tiger lilies with striking orange and black speckled petals.', 36.00, 45, 'https://images.unsplash.com/photo-1592730341797-b8b0b4fb0d5e?w=600&q=80', 'Lily', 'Orange'),
  ('Yellow Lily Joy', 'Cheerful yellow lilies bringing brightness and positivity.', 34.00, 60, 'https://images.unsplash.com/photo-1503431128871-cd250803fa41?w=600&q=80', 'Lily', 'Yellow'),

  ('Sunflower Bundle', 'Tall, vibrant sunflowers symbolizing adoration and loyalty.', 29.00, 80, 'https://images.unsplash.com/photo-1551893478-d60cc4042aca?w=600&q=80', 'Sunflower', 'Yellow'),
  ('Mini Sunflower Bunch', 'Cute mini sunflowers in a compact and charming arrangement.', 24.00, 90, 'https://images.unsplash.com/photo-1543347317-7a0b55e17e7d?w=600&q=80', 'Sunflower', 'Yellow'),
  ('Sunflower & Rose Mix', 'A cheerful mix of sunflowers and roses for a warm feeling.', 47.00, 35, 'https://images.unsplash.com/photo-1469259943454-aa100abba749?w=600&q=80', 'Mixed', 'Mixed'),

  ('White Daisy Field', 'Simple and pure white daisies evoking fields and freshness.', 22.00, 100, 'https://images.unsplash.com/photo-1560717789-0ac7c58ac90a?w=600&q=80', 'Daisy', 'White'),
  ('Pink Daisy Delight', 'Sweet pink daisies with a playful and youthful energy.', 24.00, 85, 'https://images.unsplash.com/photo-1501167786120-b237a1c1eb5a?w=600&q=80', 'Daisy', 'Pink'),
  ('Mixed Daisy Basket', 'A colorful basket of mixed daisies. Bright and cheerful.', 30.00, 60, 'https://images.unsplash.com/photo-1444021465936-c6ca81d39b84?w=600&q=80', 'Daisy', 'Mixed'),

  ('Purple Lavender Stems', 'Fresh lavender stems with a soothing fragrance and rustic charm.', 26.00, 70, 'https://images.unsplash.com/photo-1499561385668-5ebdb06a79bc?w=600&q=80', 'Lavender', 'Purple'),
  ('Lavender & White Bundle', 'A serene mix of lavender and white blooms for a calming gift.', 34.00, 55, 'https://images.unsplash.com/photo-1468327768560-75b778cbb551?w=600&q=80', 'Lavender', 'Purple'),

  ('Pink Peony Lush', 'Full, lush pink peonies — one of the most beloved romantic flowers.', 58.00, 30, 'https://images.unsplash.com/photo-1562690868-60bbe7293e94?w=600&q=80', 'Peony', 'Pink'),
  ('White Peony Grace', 'Soft white peonies for weddings and elegant occasions.', 60.00, 25, 'https://images.unsplash.com/photo-1558691058-55e2c501a790?w=600&q=80', 'Peony', 'White'),
  ('Coral Peony Bliss', 'Coral peonies with a warm, sunset-like glow. Truly stunning.', 62.00, 25, 'https://images.unsplash.com/photo-1528735000313-039e94e06727?w=600&q=80', 'Peony', 'Coral'),

  ('White Orchid Elegance', 'Refined white orchids representing luxury and rare beauty.', 70.00, 20, 'https://images.unsplash.com/photo-1567748157439-651aca2ff4c5?w=600&q=80', 'Orchid', 'White'),
  ('Pink Orchid Romance', 'Delicate pink orchids for a sophisticated and lasting gift.', 72.00, 18, 'https://images.unsplash.com/photo-1463320726281-696a485928c7?w=600&q=80', 'Orchid', 'Pink'),
  ('Purple Orchid Exotic', 'Exotic purple orchids that make a bold and beautiful impression.', 75.00, 15, 'https://images.unsplash.com/photo-1532629345422-7515f3d16bb6?w=600&q=80', 'Orchid', 'Purple'),

  ('Spring Mix Bouquet', 'A seasonal mix of spring flowers in pastel tones. Light and fresh.', 39.00, 50, 'https://images.unsplash.com/photo-1487530811176-3780de880c2d?w=600&q=80', 'Mixed', 'Mixed'),
  ('Wildflower Meadow', 'A natural wildflower arrangement with a bohemian and free-spirited feel.', 35.00, 45, 'https://images.unsplash.com/photo-1508610048659-a06b669e3321?w=600&q=80', 'Mixed', 'Mixed'),
  ('Luxury Grand Bouquet', 'Our most premium arrangement combining roses, peonies, and orchids.', 120.00, 10, 'https://images.unsplash.com/photo-1483794344563-d27a8d18014e?w=600&q=80', 'Mixed', 'Mixed'),
  ('Petite Gift Posy', 'A small but beautiful posy, ideal for a quick and sweet gesture.', 18.00, 120, 'https://images.unsplash.com/photo-1442458017215-285b83f65851?w=600&q=80', 'Mixed', 'Mixed');


-- PRODUCT OCCASIONS
INSERT INTO product_occasions (product_id, occasion_id) VALUES
  -- Red Rose → Valentine, Anniversary, Birthday, Just Because
  (1, 5), (1, 2), (1, 1), (1, 8),
  -- Pink Rose → Birthday, Mother's Day, Just Because
  (2, 1), (2, 6), (2, 8),
  -- White Rose → Wedding, Sympathy, Anniversary
  (3, 4), (3, 3), (3, 2),
  -- Yellow Rose → Birthday, Graduation, Just Because
  (4, 1), (4, 7), (4, 8),
  -- Orange Rose → Birthday, Graduation, Just Because
  (5, 1), (5, 7), (5, 8),
  -- Lavender Rose → Anniversary, Valentine, Just Because
  (6, 2), (6, 5), (6, 8),
  -- Garden Rose → Wedding, Anniversary, Mother's Day
  (7, 4), (7, 2), (7, 6),
  -- Dried Rose → Anniversary, Just Because
  (8, 2), (8, 8),
  -- Purple Tulip → Birthday, Just Because
  (9, 1), (9, 8),
  -- Pink Tulip → Mother's Day, Birthday
  (10, 6), (10, 1),
  -- White Tulip → Wedding, Sympathy
  (11, 4), (11, 3),
  -- Red Tulip → Valentine, Anniversary
  (12, 5), (12, 2),
  -- Yellow Tulip → Birthday, Graduation
  (13, 1), (13, 7),
  -- Mixed Tulip → Birthday, Mother's Day, Just Because
  (14, 1), (14, 6), (14, 8),
  -- Blue Hydrangea → Wedding, Anniversary
  (15, 4), (15, 2),
  -- Pink Hydrangea → Mother's Day, Birthday
  (16, 6), (16, 1),
  -- White Hydrangea → Wedding, Sympathy
  (17, 4), (17, 3),
  -- Purple Hydrangea → Birthday, Just Because
  (18, 1), (18, 8),
  -- White Lily → Sympathy, Wedding
  (19, 3), (19, 4),
  -- Pink Stargazer → Birthday, Valentine
  (20, 1), (20, 5),
  -- Orange Tiger Lily → Birthday, Graduation
  (21, 1), (21, 7),
  -- Yellow Lily → Birthday, Graduation, Just Because
  (22, 1), (22, 7), (22, 8),
  -- Sunflower Bundle → Birthday, Just Because, Graduation
  (23, 1), (23, 8), (23, 7),
  -- Mini Sunflower → Birthday, Just Because
  (24, 1), (24, 8),
  -- Sunflower Rose Mix → Birthday, Valentine, Anniversary
  (25, 1), (25, 5), (25, 2),
  -- White Daisy → Just Because, Sympathy
  (26, 8), (26, 3),
  -- Pink Daisy → Birthday, Mother's Day
  (27, 1), (27, 6),
  -- Mixed Daisy → Birthday, Graduation
  (28, 1), (28, 7),
  -- Lavender Stems → Just Because, Sympathy
  (29, 8), (29, 3),
  -- Lavender White Bundle → Wedding, Sympathy
  (30, 4), (30, 3),
  -- Pink Peony → Valentine, Anniversary, Mother's Day
  (31, 5), (31, 2), (31, 6),
  -- White Peony → Wedding, Anniversary
  (32, 4), (32, 2),
  -- Coral Peony → Birthday, Anniversary
  (33, 1), (33, 2),
  -- White Orchid → Wedding, Anniversary, Just Because
  (34, 4), (34, 2), (34, 8),
  -- Pink Orchid → Valentine, Mother's Day
  (35, 5), (35, 6),
  -- Purple Orchid → Birthday, Just Because
  (36, 1), (36, 8),
  -- Spring Mix → Birthday, Mother's Day, Just Because
  (37, 1), (37, 6), (37, 8),
  -- Wildflower Meadow → Birthday, Graduation, Just Because
  (38, 1), (38, 7), (38, 8),
  -- Luxury Grand → Anniversary, Wedding, Valentine
  (39, 2), (39, 4), (39, 5),
  -- Petite Posy → Just Because, Birthday, Sympathy
  (40, 8), (40, 1), (40, 3);


-- BOUQUET COMPONENTS (unique images matching each flower type)
INSERT INTO bouquet_components (name, price, image_url, stock) VALUES
  ('Single Red Rose', 4.00, 'https://images.unsplash.com/photo-1490750967868-88df5691cc0e?w=300&q=80', 200),
  ('Single Pink Rose', 3.50, 'https://images.unsplash.com/photo-1455659817273-f96807779a8a?w=300&q=80', 200),
  ('Single White Rose', 3.50, 'https://images.unsplash.com/photo-1558652093-3685a170faa5?w=300&q=80', 200),
  ('Single Yellow Rose', 3.00, 'https://images.unsplash.com/photo-1548460397-fbe0be4e04f5?w=300&q=80', 200),
  ('Tulip Stem', 2.50, 'https://images.unsplash.com/photo-1520763185298-1b434c919102?w=300&q=80', 300),
  ('Sunflower Stem', 3.00, 'https://images.unsplash.com/photo-1551893478-d60cc4042aca?w=300&q=80', 250),
  ('Lily Stem', 3.50, 'https://images.unsplash.com/photo-1501577316686-62e37ea27c2b?w=300&q=80', 200),
  ('Hydrangea Head', 5.00, 'https://images.unsplash.com/photo-1530092285049-1c42085fd395?w=300&q=80', 150),
  ('Peony Stem', 6.00, 'https://images.unsplash.com/photo-1562690868-60bbe7293e94?w=300&q=80', 100),
  ('Lavender Sprig', 2.00, 'https://images.unsplash.com/photo-1499561385668-5ebdb06a79bc?w=300&q=80', 300),
  ('Baby''s Breath Filler', 1.50, 'https://images.unsplash.com/photo-1487530811176-3780de880c2d?w=300&q=80', 400),
  ('Green Eucalyptus', 2.00, 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=300&q=80', 350),
  ('Ribbon (Pink)', 1.00, NULL, 500),
  ('Ribbon (White)', 1.00, NULL, 500),
  ('Gift Box Wrap', 3.00, NULL, 200);


-- ──────────────────────────────────────────────────────────────
-- 1. WISHLISTS TABLE (new)
--    Stores user favourites, persisted via Supabase.
-- ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS wishlists (
  id         BIGSERIAL    PRIMARY KEY,
  user_id    UUID         NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  product_id INT          NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ  DEFAULT NOW(),
  UNIQUE (user_id, product_id)
);

-- Index for fast lookups by user
CREATE INDEX IF NOT EXISTS idx_wishlists_user ON wishlists (user_id);


-- ──────────────────────────────────────────────────────────────
-- 2. PRODUCTS — add "meaning" column
--    Per-product flower symbolism. The app has a client-side
--    fallback map by type, so this column is optional/override.
-- ──────────────────────────────────────────────────────────────
ALTER TABLE products
  ADD COLUMN IF NOT EXISTS meaning TEXT DEFAULT NULL;


-- ──────────────────────────────────────────────────────────────
-- 3. ORDERS — gift scheduling columns
--    Stores recurring delivery intent (execution is backend).
-- ──────────────────────────────────────────────────────────────
ALTER TABLE orders
  ADD COLUMN IF NOT EXISTS is_recurring         BOOLEAN DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS recurrence_interval  TEXT    DEFAULT NULL
    CHECK (recurrence_interval IN ('weekly', 'biweekly', 'monthly', NULL)),
  ADD COLUMN IF NOT EXISTS next_delivery_date   DATE    DEFAULT NULL;


-- ──────────────────────────────────────────────────────────────
-- 4. ORDERS — expand status CHECK to include 'preparing'
--    The order tracking page uses: pending → confirmed →
--    preparing → shipped → delivered (also cancelled).
-- ──────────────────────────────────────────────────────────────
-- Drop the old constraint and create an expanded one.
ALTER TABLE orders DROP CONSTRAINT IF EXISTS orders_status_check;
ALTER TABLE orders
  ADD CONSTRAINT orders_status_check
  CHECK (status IN ('pending', 'confirmed', 'preparing', 'shipped', 'delivered', 'cancelled'));


-- ──────────────────────────────────────────────────────────────
-- 5. ORDERS — add status_updated_at for tracking timestamps
-- ──────────────────────────────────────────────────────────────
ALTER TABLE orders
  ADD COLUMN IF NOT EXISTS status_updated_at TIMESTAMPTZ DEFAULT NOW();

-- Auto-update status_updated_at whenever status changes
CREATE OR REPLACE FUNCTION update_order_status_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status IS DISTINCT FROM OLD.status THEN
    NEW.status_updated_at = NOW();
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_order_status_timestamp ON orders;
CREATE TRIGGER trg_order_status_timestamp
  BEFORE UPDATE ON orders
  FOR EACH ROW
  EXECUTE FUNCTION update_order_status_timestamp();


-- ──────────────────────────────────────────────────────────────
-- 6. BOUQUET COMPONENTS — add price_per_stem alias
--    The frontend code checks component.price_per_stem first,
--    then falls back to component.price. Adding the alias
--    keeps both paths working.
-- ──────────────────────────────────────────────────────────────
ALTER TABLE bouquet_components
  ADD COLUMN IF NOT EXISTS price_per_stem NUMERIC(10, 2) DEFAULT NULL;

-- Copy existing price values into price_per_stem
UPDATE bouquet_components
  SET price_per_stem = price
  WHERE price_per_stem IS NULL;


-- ──────────────────────────────────────────────────────────────
-- 7. ENABLE SUPABASE REALTIME for orders table
--    This lets OrderTracking.vue receive live status updates.
--    (Run in Supabase SQL Editor — this is a Supabase extension)
-- ──────────────────────────────────────────────────────────────
ALTER PUBLICATION supabase_realtime ADD TABLE orders;


-- ──────────────────────────────────────────────────────────────
-- 8. ROW LEVEL SECURITY (RLS) for wishlists
--    Users can only read/write their own wishlist rows.
-- ──────────────────────────────────────────────────────────────
ALTER TABLE wishlists ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own wishlists"
  ON wishlists FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own wishlists"
  ON wishlists FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own wishlists"
  ON wishlists FOR DELETE
  USING (auth.uid() = user_id);


-- ──────────────────────────────────────────────────────────────
-- 9. (OPTIONAL) Seed flower meanings into existing products
--    These match the client-side fallback map, but having them
--    in the DB allows per-product customization from the admin.
-- ──────────────────────────────────────────────────────────────
UPDATE products SET meaning = 'Love, passion, and devotion — the timeless language of the heart.'
  WHERE type = 'Rose' AND meaning IS NULL;

UPDATE products SET meaning = 'Perfect love and new beginnings — a declaration of elegance.'
  WHERE type = 'Tulip' AND meaning IS NULL;

UPDATE products SET meaning = 'Purity, renewal, and remembrance — grace in every petal.'
  WHERE type = 'Lily' AND meaning IS NULL;

UPDATE products SET meaning = 'Adoration, loyalty, and vitality — a burst of warm happiness.'
  WHERE type = 'Sunflower' AND meaning IS NULL;

UPDATE products SET meaning = 'Innocence, cheerfulness, and new starts — simple joy in bloom.'
  WHERE type = 'Daisy' AND meaning IS NULL;

UPDATE products SET meaning = 'Serenity, grace, and calm devotion — a soothing embrace.'
  WHERE type = 'Lavender' AND meaning IS NULL;

UPDATE products SET meaning = 'Prosperity, romance, and compassion — lush beauty that captivates.'
  WHERE type = 'Peony' AND meaning IS NULL;

UPDATE products SET meaning = 'Luxury, refinement, and rare beauty — an exotic whisper of elegance.'
  WHERE type = 'Orchid' AND meaning IS NULL;

UPDATE products SET meaning = 'Gratitude, abundance, and heartfelt emotion — generous and full.'
  WHERE type = 'Hydrangea' AND meaning IS NULL;

UPDATE products SET meaning = 'A harmony of sentiments — every stem tells its own story.'
  WHERE type = 'Mixed' AND meaning IS NULL;


-- ============================================================
-- DONE. Summary of changes:
--
--   NEW TABLE:   wishlists (with RLS policies)
--   NEW COLUMNS: products.meaning
--                orders.is_recurring
--                orders.recurrence_interval
--                orders.next_delivery_date
--                orders.status_updated_at
--                bouquet_components.price_per_stem
--   MODIFIED:    orders.status CHECK (added 'preparing')
--   NEW TRIGGER: auto-update status_updated_at on status change
--   REALTIME:    enabled for orders table
--   SEED:        flower meanings populated from type defaults
-- ============================================================
