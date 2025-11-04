# ERD & Backend Integration Plan

## 1. Domain Overview (updated)
The frontend currently manages all moving data in Pinia/localStorage. To persist the same experience on the server we will materialise the entities below:

- **Users** (existing Laravel auth users).
- **Moves** – one active relocation per household/user with dynamic bags & settings.
- **Bags** – per-move luggage definitions (any count, e.g. “Mala A/B/C”).
- **Items** – assets being catalogued/decided/packed.
- **Item Media** – uploaded photos/videos per item (primary + gallery, with thumbnails).
- **Decisions Log** – immutable audit trail of decision transitions.
- **Bags Snapshot** *(optional analytics)* – cached aggregates per move (used for fast dashboards/export).

All entities use soft deletes where the UI exposes a recycle bin. All weight units stay in **kilograms** to match the UI.

## 2. Entities & Columns

### `users`
Existing Laravel table. Relation reference only.

### `moves`
| Column | Type | Null | Default | Notes |
| --- | --- | --- | --- | --- |
| id | bigint PK | no | | |
| user_id | bigint FK → users.id | no | | cascade on delete |
| origin_country | string(2) | yes | null | ISO country code |
| destination_country | string(2) | yes | null | |
| reserved_weight_kg | decimal(5,2) | no | 4.00 | reserved for contingencies |
| settings | json | yes | NULL | arbitrary UI feature flags |
| created_at/updated_at | timestamps | no | | |
| deleted_at | softDeletes | yes | null | move archive |

> **Migration note**: during backfill we will drop `bag_a_capacity_kg`, `bag_b_capacity_kg` after migrating data into the new `bags` table.

### `bags`
| Column | Type | Null | Default | Notes |
| --- | --- | --- | --- | --- |
| id | bigint PK | no | | |
| move_id | bigint FK → moves.id | no | | cascade on delete |
| name | string(80) | no | | display name (e.g. “Mala A”) |
| code | string(10) | no | | short unique per move (`A`, `B`, `CarryOn`) |
| capacity_kg | decimal(5,2) | no | 23.00 | weight limit |
| sort_order | integer | no | 0 | ordering for UI |
| created_at/updated_at | timestamps | no | | |

No soft delete (bags removed explicitly). Unique composite index on `(move_id, code)`.

### `items`
| Column | Type | Null | Default | Notes |
| --- | --- | --- | --- | --- |
| id | bigint PK | no | | |
| move_id | bigint FK → moves.id | no | | cascade on delete |
| bag_id | bigint FK → bags.id | yes | null | dynamic bag linkage |
| title | string(160) | no | | UI “name” |
| notes | text | yes | null | UI "notes" / subtitle |
| weight_kg | decimal(5,2) | yes | null | UI `weight` (kg) |
| dimensions | string(80) | yes | null | UI `dimensions` string |
| section | enum(`living_room`,`kitchen`,`bedroom`,`office`,`bathroom`,`storage`,`other`) | yes | 'other' | room/section filters |
| category | string(80) | yes | null | UI category drop-down |
| fragile | boolean | no | false | UI fragile toggle |
| decision | enum(`pending`,`yes`,`no`) | no | 'pending' | UI decision chips |
| packed_at | timestamp | yes | null | packed checkbox (derived boolean) |
| sort_order | integer | no | 0 | deck ordering (lower = top) |
| location_hint | string(120) | yes | null | recycle bin display text |
| photo_url | string(255) | yes | null | cached primary media URL |
| thumbnail_url | string(255) | yes | null | cached thumb |
| deleted_at | softDeletes | yes | null | recycle bin |
| created_at/updated_at | timestamps | no | | |

Indexes: `(move_id)`, `(decision)`, `(bag_id)`, `(move_id, sort_order)`.

### `item_media`
| Column | Type | Null | Default | Notes |
| --- | --- | --- | --- | --- |
| id | bigint PK | no | | |
| item_id | bigint FK → items.id | no | | cascade on delete |
| disk | string(32) | no | | storage disk name |
| path | string(255) | no | | original asset path |
| thumb_path | string(255) | yes | null | generated thumb |
| status | enum(`queued`,`uploading`,`done`,`error`) | no | 'done' | inbox status badges |
| bytes | unsigned bigint | yes | null | file size |
| width | unsigned integer | yes | null | image width |
| height | unsigned integer | yes | null | image height |
| mime | string(100) | yes | null | MIME type |
| uploaded_by | bigint FK → users.id | yes | null | uploader |
| created_at/updated_at | timestamps | no | | |

### `decisions_log`
| Column | Type | Null | Default | Notes |
| --- | --- | --- | --- | --- |
| id | bigint PK | no | | |
| item_id | bigint FK → items.id | no | | cascade on delete |
| from_decision | enum(`pending`,`yes`,`no`) | yes | null | previous value |
| to_decision | enum(`pending`,`yes`,`no`) | no | | target value |
| context | json | yes | null | payload (e.g. trigger, bag info) |
| decided_by | bigint FK → users.id | yes | null | actor |
| created_at | timestamp | no | now() | immutable |

### `bags_snapshot` *(optional, denormalised)*
| Column | Type | Null | Default | Notes |
| --- | --- | --- | --- | --- |
| id | bigint PK | no | | |
| move_id | bigint FK → moves.id | no | | cascade on delete |
| total_kg | decimal(6,2) | no | 0 | |
| pending_count | integer | no | 0 | |
| decided_count | integer | no | 0 | |
| meta | json | yes | null | store per-bag `[{bag_id, bag_name, total_kg}]` |
| updated_at | timestamp | no | now() | |

## 3. Relations & Cascades
- `users` 1→* `moves` (cascade delete moves when user deleted).
- `moves` 1→* `bags` (cascade).
- `moves` 1→* `items` (cascade).
- `bags` 1→* `items` (null bag on bag delete or restrict? we will cascade to set NULL).
- `items` 1→* `item_media` (cascade) and 1→* `decisions_log`.
- `moves` 1→1 `bags_snapshot` (latest aggregate per move).

Every `items` record is scoped to one `move`; optional bag link allows unlimited luggage. Soft deleting an item keeps its media/logs for restore.

## 4. Enumerations
- **Item decision**: `pending`, `yes`, `no`.
- **Sections**: `living_room`, `kitchen`, `bedroom`, `office`, `bathroom`, `storage`, `other`.
- **Upload status**: `queued`, `uploading`, `done`, `error`.

## 5. Frontend Field Mapping (no change)
| Frontend | Backend | Notes |
| --- | --- | --- |
| `item.id` | items.id | stringified in JS |
| `title/name` | items.title | |
| `notes/subtitle` | items.notes | |
| `weight` | items.weight_kg | decimals preserved |
| `dimensions` | items.dimensions | formatted string |
| `category` | items.category | |
| `fragile` | items.fragile | |
| `decision` | items.decision | |
| `bag` | items.bag_id → bags.code when serialising | controllers will send `bag` (code) to match existing UI |
| `packed` | items.packed_at != null | |
| `deleted` | items.deleted_at != null | |
| `location` (reciclagem) | items.location_hint | |
| `queue` order | items.sort_order | lower = top |
| `photo`/`thumbnail` | items.thumbnail_url / first media thumb |

Derived aggregates (unchanged): `stats.*`, bag totals from `bags` join, “Embalados” counts from `packed_at`.

## 6. Image Storage Strategy

### Disks
- **Development**: `FILESYSTEM_DISK=public` (local `storage/app/public`) → `Storage::url()` generates `http://localhost/storage/...` (ensure `php artisan storage:link`).
- **Production**: `FILESYSTEM_DISK=s3`; optionally configure `AWS_URL` / CloudFront CDN. `Storage::url()` returns CDN or S3 URL.

### Upload flow
1. Client POSTs multipart `file` to `/api/items/{item}/media`.
2. Controller validates, stores original via `Storage::disk(config('filesystems.default'))->putFile`.
3. Generate 400×400 cover thumbnail using Intervention Image (cover crop), store alongside original (e.g. append `_thumb`).
4. Record metadata in `item_media` (disk, path, thumb_path, bytes, width/height, mime, status=done).
5. Update item’s `photo_url`/`thumbnail_url` with `Storage::url()` of first media.

### Deletion
- `DELETE /api/media/{media}` removes original & thumb via `Storage::disk(media.disk)->delete([path, thumb_path])` then deletes the record.
- Deleting an item (soft delete) keeps files; purging (force delete) removes all associated media.

### Future enhancements
- Presigned direct uploads via S3 could replace server upload later. Current implementation remains server-driven for simplicity.

## 7. Backfill/Migration Notes
- Create migration to build new `bags` table.
- Seed existing moves with two defaults: `Mala A` (code `A`, capacity 23) and `Mala B` (code `B`, capacity 23).
- During migration, map existing local-storage `bag` values (`'A'`, `'B'`, null) to the new bags (matching codes). After populating `bag_id`, drop legacy bag enum column.
- Update calculations (WeightBar, Resumo suitcases) to iterate bags instead of fixed columns.

## 8. UI Touchpoints (same as previous phase)
Refer to Phase 1 list for Decidir, Embalar, Resumo, Reciclagem, Uploads. All now consume bag data dynamically (bag code/name from API).

## 9. API Endpoints (unchanged structurally)
Endpoints now emit bag info as `{ bag: { id, code, name, capacity_kg } }` or map to existing UI `bag` (code) for backwards compatibility.

## 10. Summary
The ERD now supports unlimited bags per move and robust media storage. We will:
1. Migrate existing data into the new bag structure.
2. Implement S3/public-aware uploads with thumbnail generation and cleanup.
3. Maintain frontend contracts by serialising `bag` as the original code string while storing `bag_id` internally.

