-- ============================================================
-- UPDATE PHOTOS ONLY
-- Run this in Supabase SQL Editor to update all image URLs
-- on existing products, bouquet_components, and occasions.
-- No tables are created or dropped — just image_url UPDATEs.
-- ============================================================

-- ── PRODUCTS ─────────────────────────────────────────────────
-- Roses (id 1-8)
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1490750967868-88df5691cc0e?w=600&q=80' WHERE id = 1;
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1455659817273-f96807779a8a?w=600&q=80' WHERE id = 2;
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1558652093-3685a170faa5?w=600&q=80' WHERE id = 3;
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1548460397-fbe0be4e04f5?w=600&q=80' WHERE id = 4;
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1526047932273-341f2a7631f9?w=600&q=80' WHERE id = 5;
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1495231916356-a86217efff12?w=600&q=80' WHERE id = 6;
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1563241527-3004b7be0ffd?w=600&q=80' WHERE id = 7;
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1501004318855-e27dae1715fc?w=600&q=80' WHERE id = 8;

-- Tulips (id 9-14)
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1520763185298-1b434c919102?w=600&q=80' WHERE id = 9;
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1518701005037-d53b1b15b1eb?w=600&q=80' WHERE id = 10;
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1524386416438-98b9b2d4b433?w=600&q=80' WHERE id = 11;
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1488750423832-5a4b0f37df89?w=600&q=80' WHERE id = 12;
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1461530927168-44328109da52?w=600&q=80' WHERE id = 13;
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1517697471339-4aa32003c11a?w=600&q=80' WHERE id = 14;

-- Hydrangeas (id 15-18)
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1530092285049-1c42085fd395?w=600&q=80' WHERE id = 15;
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1457089328109-e5d9bd499191?w=600&q=80' WHERE id = 16;
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1561181286-d3fee7d55364?w=600&q=80' WHERE id = 17;
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1504567961542-e24d9439a724?w=600&q=80' WHERE id = 18;

-- Lilies (id 19-22)
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1501577316686-62e37ea27c2b?w=600&q=80' WHERE id = 19;
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1467781687645-c7dc2de49cba?w=600&q=80' WHERE id = 20;
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1592730341797-b8b0b4fb0d5e?w=600&q=80' WHERE id = 21;
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1503431128871-cd250803fa41?w=600&q=80' WHERE id = 22;

-- Sunflowers (id 23-24) + Sunflower & Rose Mix (id 25)
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1551893478-d60cc4042aca?w=600&q=80' WHERE id = 23;
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1543347317-7a0b55e17e7d?w=600&q=80' WHERE id = 24;
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1469259943454-aa100abba749?w=600&q=80' WHERE id = 25;

-- Daisies (id 26-28)
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1560717789-0ac7c58ac90a?w=600&q=80' WHERE id = 26;
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1501167786120-b237a1c1eb5a?w=600&q=80' WHERE id = 27;
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1444021465936-c6ca81d39b84?w=600&q=80' WHERE id = 28;

-- Lavender (id 29-30)
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1499561385668-5ebdb06a79bc?w=600&q=80' WHERE id = 29;
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1468327768560-75b778cbb551?w=600&q=80' WHERE id = 30;

-- Peonies (id 31-33)
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1562690868-60bbe7293e94?w=600&q=80' WHERE id = 31;
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1558691058-55e2c501a790?w=600&q=80' WHERE id = 32;
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1528735000313-039e94e06727?w=600&q=80' WHERE id = 33;

-- Orchids (id 34-36)
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1567748157439-651aca2ff4c5?w=600&q=80' WHERE id = 34;
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1463320726281-696a485928c7?w=600&q=80' WHERE id = 35;
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1532629345422-7515f3d16bb6?w=600&q=80' WHERE id = 36;

-- Mixed bouquets (id 37-40)
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1487530811176-3780de880c2d?w=600&q=80' WHERE id = 37;
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1508610048659-a06b669e3321?w=600&q=80' WHERE id = 38;
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1483794344563-d27a8d18014e?w=600&q=80' WHERE id = 39;
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1442458017215-285b83f65851?w=600&q=80' WHERE id = 40;


-- ── OCCASIONS ────────────────────────────────────────────────
UPDATE occasions SET image_url = 'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400&q=80' WHERE slug = 'birthday';
UPDATE occasions SET image_url = 'https://images.unsplash.com/photo-1487530811176-3780de880c2d?w=400&q=80' WHERE slug = 'anniversary';
UPDATE occasions SET image_url = 'https://images.unsplash.com/photo-1501167786120-b237a1c1eb5a?w=400&q=80' WHERE slug = 'sympathy';
UPDATE occasions SET image_url = 'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=400&q=80' WHERE slug = 'wedding';
UPDATE occasions SET image_url = 'https://images.unsplash.com/photo-1490750967868-88df5691cc0e?w=400&q=80' WHERE slug = 'valentine';
UPDATE occasions SET image_url = 'https://images.unsplash.com/photo-1562690868-60bbe7293e94?w=400&q=80' WHERE slug = 'mothers-day';
UPDATE occasions SET image_url = 'https://images.unsplash.com/photo-1551893478-d60cc4042aca?w=400&q=80' WHERE slug = 'graduation';
UPDATE occasions SET image_url = 'https://images.unsplash.com/photo-1444021465936-c6ca81d39b84?w=400&q=80' WHERE slug = 'just-because';


-- ── BOUQUET COMPONENTS ───────────────────────────────────────
UPDATE bouquet_components SET image_url = 'https://images.unsplash.com/photo-1490750967868-88df5691cc0e?w=300&q=80' WHERE id = 1;
UPDATE bouquet_components SET image_url = 'https://images.unsplash.com/photo-1455659817273-f96807779a8a?w=300&q=80' WHERE id = 2;
UPDATE bouquet_components SET image_url = 'https://images.unsplash.com/photo-1558652093-3685a170faa5?w=300&q=80' WHERE id = 3;
UPDATE bouquet_components SET image_url = 'https://images.unsplash.com/photo-1548460397-fbe0be4e04f5?w=300&q=80' WHERE id = 4;
UPDATE bouquet_components SET image_url = 'https://images.unsplash.com/photo-1520763185298-1b434c919102?w=300&q=80' WHERE id = 5;
UPDATE bouquet_components SET image_url = 'https://images.unsplash.com/photo-1551893478-d60cc4042aca?w=300&q=80' WHERE id = 6;
UPDATE bouquet_components SET image_url = 'https://images.unsplash.com/photo-1501577316686-62e37ea27c2b?w=300&q=80' WHERE id = 7;
UPDATE bouquet_components SET image_url = 'https://images.unsplash.com/photo-1530092285049-1c42085fd395?w=300&q=80' WHERE id = 8;
UPDATE bouquet_components SET image_url = 'https://images.unsplash.com/photo-1562690868-60bbe7293e94?w=300&q=80' WHERE id = 9;
UPDATE bouquet_components SET image_url = 'https://images.unsplash.com/photo-1499561385668-5ebdb06a79bc?w=300&q=80' WHERE id = 10;
UPDATE bouquet_components SET image_url = 'https://images.unsplash.com/photo-1487530811176-3780de880c2d?w=300&q=80' WHERE id = 11;
UPDATE bouquet_components SET image_url = 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=300&q=80' WHERE id = 12;
