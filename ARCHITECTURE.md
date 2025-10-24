# Project Architecture

- Laravel 11 + Inertia + Vue 3 + Tailwind + Pinia + Vite PWA.
- Inertia pages live in `resources/js/Pages/**`
  - Home.vue, Catalogar/Index.vue, Decidir/Index.vue, Pick/Index.vue, Resumo/Index.vue, Reciclagem/Index.vue, Share/Inbox.vue
- Reusable components: `resources/js/Components/**`
- The Lovable export (React) is reference-only in `resources/js/lovable-src/**`
- Static assets from Lovable: `public/assets/lovable/**`
- Laravel routes → Inertia:
- GET / -> Pages/Home
- GET /catalogar -> Pages/Catalogar/Index
- GET /decidir -> Pages/Decidir/Index
- GET /pick -> Pages/Pick/Index
- GET /resumo -> Pages/Resumo/Index
- GET /reciclagem -> Pages/Reciclagem/Index
- POST /share-inbox -> Pages/Share/Inbox (placeholder)
- Tailwind: merge Lovable colors (Blue/Green/Yellow/Grey) into `tailwind.config.js`.