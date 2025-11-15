<template>
    <transition name="fade">
        <div
            v-if="modelValue"
            class="fixed inset-0 z-[12000] flex items-start justify-center overflow-y-auto bg-slate-950/60 px-4 py-6 backdrop-blur-sm sm:items-center"
            role="dialog"
            aria-modal="true"
        >
            <div
                class="relative w-full max-w-2xl space-y-4 overflow-y-auto rounded-3xl bg-white p-6 text-slate-700 shadow-2xl ring-1 ring-black/5 max-h-[90vh] sm:max-h-[85vh] sm:p-8"
            >
                <button
                    type="button"
                    class="absolute right-4 top-4 inline-flex h-9 w-9 items-center justify-center rounded-full bg-slate-100 text-slate-500 transition hover:bg-slate-200 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-400"
                    @click="$emit('close')"
                    aria-label="Fechar"
                >
                    <slot name="close-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="h-5 w-5">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </slot>
                </button>

                <div class="space-y-3">
                    <header v-if="$slots.header" class="space-y-2">
                        <slot name="header" />
                    </header>

                    <section class="space-y-3 text-sm leading-relaxed text-slate-600 sm:text-base">
                        <slot />
                    </section>
                </div>

                <footer v-if="$slots.footer" class="flex flex-wrap items-center justify-between gap-3">
                    <slot name="footer" />
                </footer>
            </div>
        </div>
    </transition>
</template>

<script setup>
defineProps({
    modelValue: {
        type: Boolean,
        default: false,
    },
});

defineEmits(['close']);
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
    transition: opacity 0.2s ease, transform 0.2s ease;
}
.fade-enter-from,
.fade-leave-to {
    opacity: 0;
    transform: scale(0.98);
}
</style>
