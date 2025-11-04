<template>
    <teleport to="body">
        <TransitionGroup
            appear
            tag="div"
            enter-active-class="transition duration-200 ease-out"
            enter-from-class="opacity-0 translate-y-2"
            enter-to-class="opacity-100 translate-y-0"
            leave-active-class="transition duration-150 ease-in"
            leave-from-class="opacity-100 translate-y-0"
            leave-to-class="opacity-0 -translate-y-2"
            class="pointer-events-none fixed inset-x-4 top-6 z-50 flex flex-col items-center gap-3 sm:items-end"
            aria-live="assertive"
        >
            <div
                v-for="toast in toasts"
                :key="toast.id"
                class="pointer-events-auto w-full max-w-sm overflow-hidden rounded-2xl border shadow-lg ring-1 ring-black/5 backdrop-blur"
                :class="variantContainer(toast.variant)"
                role="status"
            >
                <div class="flex items-start gap-3 px-4 py-3">
                    <div
                        class="mt-1 inline-flex h-8 w-8 items-center justify-center rounded-full"
                        :class="variantBadge(toast.variant)"
                    >
                        <component
                            :is="variantIcon(toast.variant)"
                            class="h-4 w-4"
                            aria-hidden="true"
                        />
                    </div>

                    <div class="flex-1 space-y-1 text-sm leading-relaxed text-slate-800">
                        <p v-if="toast.title" class="font-semibold text-slate-900">
                            {{ toast.title }}
                        </p>
                        <p>{{ toast.message }}</p>
                    </div>

                    <button
                        type="button"
                        class="mt-1 inline-flex h-7 w-7 items-center justify-center rounded-full text-slate-400 transition hover:bg-slate-100 hover:text-slate-600 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-400/60"
                        @click="dismiss(toast.id)"
                        aria-label="Fechar aviso"
                    >
                        <X class="h-4 w-4" aria-hidden="true" />
                    </button>
                </div>
            </div>
        </TransitionGroup>
    </teleport>
</template>

<script setup>
import { useToastStore } from '@/utils/toast';
import { AlertTriangle, CheckCircle2, Info, X } from 'lucide-vue-next';

const { toasts, dismiss } = useToastStore();

const variantContainer = (variant) => {
    switch (variant) {
        case 'success':
            return 'border-emerald-200/70 bg-white/90';
        case 'error':
            return 'border-rose-200/70 bg-white/90';
        default:
            return 'border-slate-200/80 bg-white/90';
    }
};

const variantBadge = (variant) => {
    switch (variant) {
        case 'success':
            return 'bg-emerald-500/15 text-emerald-600';
        case 'error':
            return 'bg-rose-500/15 text-rose-600';
        default:
            return 'bg-sky-500/15 text-sky-600';
    }
};

const variantIcon = (variant) => {
    switch (variant) {
        case 'success':
            return CheckCircle2;
        case 'error':
            return AlertTriangle;
        default:
            return Info;
    }
};
</script>
