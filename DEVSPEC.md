# Decidir o que Levar — DEVSPEC

## Objective
A progressive web app (PWA) to catalog items and decide what to take when moving between homes.  
My wife and I will use it to choose what goes in the luggage before moving from the UK to Brazil.  
There are no boxes, only **two bags (A/B)** of 23 kg each.

The app should help:
- Capture photos of items (Catalogar)
- Swipe to decide “Take / Leave / Maybe” (Decidir)
- Assign items to bags and mark as packed (Embalar)
- See totals and export a PDF/CSV of what to take (Resumo)

The UI is simple, calm and colorful:  
- **Blue** = Catalogar  
- **Green** = Decidir  
- **Yellow** = Embalar  
- **Grey** = Resumo  

## Authentication
- Uses Laravel Breeze (session-based).  
- **No Sanctum** or tokens yet.  
- Login optional; app can run without authentication.  
- Magic link login can be added later if needed.

## Domain model
- bags(name: 'A'|'B', capacity_kg, reserved_kg)
- rooms, sections, categories
- items(section_id, category_id, title, notes, state: pending|take|leave|maybe,
- weight_estimated_g, weight_exact_g, bag_id?, packed_at?, softDeletes)
- item_media(item_id, url_full, url_thumb, is_primary, softDeletes)
- decisions(item_id, decided_by, decision, note, created_at)

## Rules
- Export PDF/CSV only when all items are decided (`pending = 0`)  
  (allow forced export with a warning)
- Weight bar updates in real time and shows A/B remaining
- Pick Mode shows only “take” items, allows toggling A/B and marking “packed”
- Recycle bin keeps deleted items for 60 days, then purges S3
- Default home mode: only **Decidir** active; others unlocked by triple-tap on the “UK → Brazil” text