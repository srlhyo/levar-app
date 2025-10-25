<template>
    <div class="min-h-screen bg-slate-50 text-slate-900">
        <main class="mx-auto max-w-3xl px-4 py-10 sm:py-12">
            <header class="text-center sm:text-left">
                <div class="inline-flex items-center rounded-full bg-slate-100 px-3 py-1 text-xs font-medium text-slate-700">
                    Mudança UK → Brasil
                </div>
                <h1 class="mt-4 text-2xl font-bold text-slate-800 sm:text-3xl">
                    <slot name="title" />
                </h1>
                <p v-if="hasSubtitle" class="mt-2 text-base leading-relaxed text-slate-600 sm:text-lg">
                    <slot name="subtitle" />
                </p>
                <div class="mt-4 border-t border-slate-200/80 shadow-[0_1px_0_rgba(0,0,0,0.02)]"></div>
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
import ToastHub from '@/Components/ToastHub.vue';

const slots = useSlots();
const hasSubtitle = computed(() => !!slots.subtitle);
</script>
