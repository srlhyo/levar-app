<template>
    <div class="min-h-screen bg-slate-50 text-slate-900 pt-[max(env(safe-area-inset-top),16px)]">
        <main class="mx-auto max-w-3xl px-4 pb-8">
            <header class="space-y-3 text-left">
                <div class="flex items-start gap-3 sm:items-center sm:gap-4">
                    <button
                        v-if="!isHome"
                        type="button"
                        aria-label="Voltar"
                        class="inline-flex items-center gap-2 rounded-2xl bg-white/80 px-3 py-2 text-slate-700 shadow-sm ring-1 ring-black/5 transition hover:bg-white focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-500/40"
                        @click="goHome"
                    >
                        <ArrowLeft class="h-4 w-4" />
                        <span class="text-sm font-medium">Voltar</span>
                    </button>

                    <div class="space-y-2">
                        <div class="inline-flex items-center rounded-full bg-slate-100 px-3 py-1 text-xs font-medium text-slate-700">
                            Mudança UK → Brasil
                        </div>
                        <h1 class="text-2xl font-bold text-slate-800 sm:text-3xl">
                            <slot name="title" />
                        </h1>
                        <p v-if="hasSubtitle" class="text-base leading-relaxed text-slate-600 sm:text-lg">
                            <slot name="subtitle" />
                        </p>
                    </div>
                </div>

                <div class="border-t border-slate-200/80 shadow-[0_1px_0_rgba(0,0,0,0.02)]"></div>
            </header>

            <section class="mt-6 space-y-6 sm:space-y-8">
                <slot />
            </section>
        </main>
        <ToastHub />
    </div>
</template>

<script setup>
import { computed, useSlots } from 'vue';
import { ArrowLeft } from 'lucide-vue-next';
import { router, usePage } from '@inertiajs/vue3';
import { route } from 'ziggy-js';
import ToastHub from '@/Components/ToastHub.vue';

const page = usePage();
const slots = useSlots();

const isHome = computed(() => page.component === 'Home');
const hasSubtitle = computed(() => !!slots.subtitle);

const goHome = () => {
    router.visit(route('home'));
};
</script>
