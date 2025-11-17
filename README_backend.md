# Backend Integration Guide

This document captures the server-side blueprint for the EasyTrip app after porting the Lovable UI to Laravel + Inertia.

## Environment

Create/update your `.env` with the following baseline for local development:

```
APP_URL=http://localhost
FILESYSTEM_DISK=public
MAIL_MAILER=log
SANCTUM_STATEFUL_DOMAINS=localhost,localhost:8080,127.0.0.1
SESSION_DOMAIN=localhost
```

When deploying to production, configure S3 (or a compatible object store) and optional CDN:

```
FILESYSTEM_DISK=s3
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=your-bucket
# Optional: CloudFront / custom domain for Storage::url()
AWS_URL=https://cdn.example.com
```

Thumbnail generation relies on the GD driver bundled with PHP. Ensure the `gd` and `iconv` extensions are enabled in environments outside the sandbox.

### Login & Registro

- Cadastre-se em `/register` informando nome, email e senha (mínimo 8 caracteres). O app já cria a mudança demo após o cadastro.
- Entre em `/login` usando email/senha. Cookies de sessão vêm configurados para domínios locais (`SANCTUM_STATEFUL_DOMAINS`, `SESSION_DOMAIN`).
- Para ambiente local, o usuário `demo@example.com` (senha `password`) é seeded como admin e pode acessar rotas protegidas como `/share-inbox`.

### ntfy (login/logout push)

If you want ntfy to ping your phone whenever someone logs in or out:

```
NTFY_ENABLED=true
NTFY_BASE_URL=https://ntfy.sh        # or your self-hosted endpoint
NTFY_TOPIC=your-topic-name
# Optional token if the topic is protected
NTFY_TOKEN=ntfy_your_token
```

Once these variables are set and config is cached, the auth controller posts a text/plain payload on successful login/logout, including user email, IP, user-agent and timestamp. We fail silently (errors are logged via `report()`) so authentication flow is never interrupted if ntfy is unreachable.

## Entities

- **Move** — relocation profile tied to a user with dynamic luggage definitions.
- **Bag** — unlimited luggage per move (code, capacity, ordering).
- **Item** — inventory row with decision (`undecided|pending|yes|no`), weight, dimensions, fragile toggle, bag link, packed timestamp, soft delete, and cached media URLs.
- **ItemMedia** — uploaded files per item with original + 400x400 cover thumbnail metadata.
- **DecisionLog** — append-only audit of decision transitions.
- **BagSnapshot** — cached aggregates (total kg, pending/decided counts, per-bag totals) refreshed after mutating actions.

Refer to `ERD.md` for column-level detail.

## Key Routes

All API routes live under `routes/api.php` and are guarded by `auth:sanctum`.

| Route | Purpose |
| --- | --- |
| `GET /moves/{move}/decidir` | Deck payload for Decidir page (pending cards + progress). |
| `POST /items/{item}/decidir` | Apply decision (`pending|yes|no`) and optional bag code. |
| `POST /items/requeue` | Move one or more items to top of the pending queue. |
| `POST /items/pack` | Bulk mark items as packed/unpacked. |
| `GET /moves/{move}/pack` | Packing summary (items + bag totals). |
| `POST /items/{item}/bag` | Assign or clear a bag for a decided item. |
| `GET /moves/{move}/resumo` | Aggregated stats, bag usage, and tabbed lists for Resumo. |
| `POST /moves/{move}/resumo/pending-to-leave` | Batch move pending items to “Não levar”. |
| `GET /moves/{move}/recycle` | Soft-deleted items with restore window metadata. |
| `POST /items/recycle` | Soft delete items. |
| `POST /items/restore` | Restore soft-deleted items. |
| `DELETE /items/{item}` | Force delete item + media. |
| `POST /items/{item}/media` | Upload item media; stores original + thumbnail. |
| `DELETE /media/{media}` | Remove media and update cover thumbnail. |
| `POST /moves/{move}/export/csv` | Stream CSV of “yes” items. |
| `GET /moves/{move}/uploads/inbox` | Mock upload inbox (queued/done/error states). |

All mutating endpoints refresh `BagSnapshot` so Resumo metrics always reflect latest actions.

## Commands & Tooling

Common workflows now have npm shortcuts (see `package.json`):

- `npm run seed:fresh` — `php artisan migrate:fresh --seed`
- `npm run test:php` — `php artisan test --parallel` (uses Pest v3 under the hood)

Individual Composer aliases:

- `composer install --ignore-platform-req=ext-iconv`
- `composer require intervention/image:^3.4`
- `composer require --dev pestphp/pest:^3.0 pestphp/pest-plugin-laravel:^3.0`

## Storage

Media uploads land on the configured default disk:

1. Original file saved under `items/{item_id}/{uuid}.ext`.
2. Thumbnail (400×400 cover crop, JPEG) saved under `items/{item_id}/thumbs/{uuid}.jpg`.
3. `ItemMedia` row records disk/path/thumb metadata, and `items.photo_url` / `items.thumbnail_url` are updated.
4. Deleting media recalculates the cover image from remaining attachments.

Run `php artisan storage:link` locally so `Storage::url()` resolves to `http://localhost/storage/...`.

## Seeding & Fixtures

`DatabaseSeeder` provisions:

- Demo admin user (`demo@example.com` / password `password`).
- One move with two sample bags (Mala A, Mala B).
- 60 items with varied decisions, bag assignments, packed state, media, and decision logs.
- Random placeholder media copied from `resources/seed-images/placeholder.png`.
- Snapshot totals refreshed at the end.

Use `npm run seed:fresh` to rebuild the database at any time.

When um novo usuário conclui o cadastro, criamos automaticamente uma mudança demo completa (malas, itens, mídia, snapshots) para que ele possa explorar o app sem precisar rodar seeds manualmente.

## Testing

Pest test suites (see `tests/Feature/Api`) cover:

- Decision transitions + history logging.
- Requeue ordering guarantees.
- Media upload with thumbnail generation.
- Resumo aggregates.
- CSV export contents.

Run the suite with `npm run test:php` or `vendor/bin/pest`. `RefreshDatabase` reuses whichever connection you configure for `APP_ENV=testing`, so Sail/MySQL works out of the box (set `DB_DATABASE=testing`). SQLite is optional if you prefer an in-memory run.
