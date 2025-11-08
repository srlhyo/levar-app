<template>
    <OverlayModal :model-value="modelValue" @close="handleClose">
        <template #header>
            <div class="space-y-1">
                <p class="text-xs font-semibold uppercase tracking-wide text-slate-400">Visualizar item</p>
                <h3 class="text-xl font-semibold text-slate-900">{{ altText }}</h3>
            </div>
        </template>

        <div class="space-y-4 sm:space-y-6 -mx-2 sm:mx-0">
            <div
                v-if="src"
                class="relative h-[72vh] overflow-hidden rounded-2xl bg-slate-50 ring-1 ring-slate-100 sm:max-h-[70vh]"
            >
                <img
                    :src="src"
                    :alt="altText"
                    class="mx-auto block h-full w-auto max-w-full object-contain transition-transform duration-150 sm:max-h-[70vh]"
                    :style="{ transform: `scale(${zoomLevel})` }"
                    draggable="false"
                />
                <p class="absolute bottom-3 right-4 rounded-full bg-slate-900/70 px-3 py-1 text-xs font-semibold text-white shadow">
                    {{ Math.round(zoomLevel * 100) }}%
                </p>
            </div>

            <div class="flex flex-wrap items-center gap-2 px-2 sm:px-0">
                <button
                    type="button"
                    class="inline-flex items-center gap-1 rounded-full border border-slate-200 px-3 py-1 text-sm font-semibold text-slate-600 transition hover:bg-slate-100 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-400 disabled:cursor-not-allowed disabled:opacity-40"
                    :disabled="zoomLevel <= MIN_ZOOM"
                    @click="adjustZoom(-0.2)"
                >
                    <ZoomOut class="h-4 w-4" />
                    Menos
                </button>
                <button
                    type="button"
                    class="inline-flex items-center gap-1 rounded-full border border-slate-200 px-3 py-1 text-sm font-semibold text-slate-600 transition hover:bg-slate-100 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-400 disabled:cursor-not-allowed disabled:opacity-40"
                    :disabled="zoomLevel >= MAX_ZOOM"
                    @click="adjustZoom(0.2)"
                >
                    <ZoomIn class="h-4 w-4" />
                    Mais
                </button>
                <button
                    type="button"
                    class="inline-flex items-center gap-1 rounded-full border border-slate-200 px-3 py-1 text-sm font-semibold text-slate-600 transition hover:bg-slate-100 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-400"
                    @click="resetZoom"
                >
                    <RefreshCcw class="h-4 w-4" />
                    Resetar
                </button>
            </div>
        </div>
    </OverlayModal>
</template>

<script setup>
import { computed, ref, watch } from 'vue';
import { RefreshCcw, ZoomIn, ZoomOut } from 'lucide-vue-next';
import OverlayModal from '@/Components/OverlayModal.vue';

const props = defineProps({
    modelValue: {
        type: Boolean,
        default: false,
    },
    src: {
        type: String,
        default: null,
    },
    alt: {
        type: String,
        default: '',
    },
});

const emit = defineEmits(['update:modelValue']);

const MIN_ZOOM = 0.5;
const MAX_ZOOM = 4;
const zoomLevel = ref(1);

const altText = computed(() => props.alt?.trim() || 'Item');

watch(
    () => props.modelValue,
    (visible) => {
        if (!visible) {
            zoomLevel.value = 1;
        }
    },
);

watch(
    () => props.src,
    () => {
        zoomLevel.value = 1;
    },
);

const handleClose = () => {
    emit('update:modelValue', false);
};

const adjustZoom = (delta) => {
    const next = Math.min(MAX_ZOOM, Math.max(MIN_ZOOM, zoomLevel.value + delta));
    zoomLevel.value = Number(next.toFixed(2));
};

const resetZoom = () => {
    zoomLevel.value = 1;
};
</script>
