<template>
    <div
        class="flex flex-col gap-3 rounded-3xl bg-white/80 p-4 ring-1 ring-black/5 backdrop-blur-sm sm:flex-row sm:items-center sm:gap-6"
    >
        <label v-if="selectable" class="flex items-start">
            <input
                :checked="selected"
                type="checkbox"
                class="mt-1 h-5 w-5 rounded border-slate-300 text-emerald-500 focus:ring-emerald-400"
                @change="onToggle"
            />
        </label>

        <div class="flex flex-1 items-start gap-4">
            <div
                class="relative flex h-14 w-14 flex-shrink-0 items-center justify-center overflow-hidden rounded-2xl bg-slate-200/80 sm:h-16 sm:w-16"
            >
                <img
                    v-if="hasPhoto"
                    :src="itemPhoto"
                    :alt="item.title ?? item.name"
                    class="max-h-full max-w-full cursor-zoom-in object-contain transition hover:scale-[1.02]"
                    loading="lazy"
                    decoding="async"
                    @error="handleImageError"
                    @click.stop="openPreview"
                />
                <Package v-else class="h-6 w-6 text-slate-500" />
                <button
                    v-if="hasPhoto"
                    type="button"
                    class="absolute right-1 top-1 inline-flex h-7 w-7 items-center justify-center rounded-xl bg-white/85 text-slate-700 shadow ring-1 ring-slate-100 transition hover:bg-white focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-400"
                    @click.stop="openPreview"
                    aria-label="Ampliar imagem"
                >
                    <ZoomIn class="h-4 w-4" />
                </button>
            </div>
            <div class="space-y-1">
                <p class="text-base font-semibold text-slate-900 sm:text-lg">{{ item.title ?? item.name }}</p>
                <p v-if="item.notes" class="text-sm text-slate-600">{{ item.notes }}</p>
                <div class="flex flex-wrap items-center gap-2 text-xs font-semibold text-slate-600">
                    <span v-if="weightPillLabel" class="rounded-full bg-slate-900 px-3 py-1 text-white">
                        {{ weightPillLabel }}
                    </span>
                    <span
                        v-if="volumePillLabel"
                        :title="volumeLabel ?? ''"
                        class="rounded-full bg-emerald-50 px-3 py-1 text-emerald-700 ring-1 ring-emerald-200"
                    >
                        {{ volumePillLabel }}
                    </span>
                </div>
            </div>
        </div>

        <div v-if="showDelete" class="flex items-center gap-2 self-stretch sm:self-center">
            <div class="relative group">
                <button
                    type="button"
                    :aria-describedby="tooltipIds.delete"
                    aria-label="Enviar para a Reciclagem"
                    class="inline-flex h-11 w-11 items-center justify-center rounded-2xl bg-white/80 text-rose-600 ring-1 ring-rose-200 shadow-sm transition hover:bg-rose-50 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-rose-300"
                    @click="emit('delete', item.id)"
                    @touchstart="() => handleHint('delete')"
                >
                    <Trash2 class="h-5 w-5" />
                </button>
                <span
                    :id="tooltipIds.delete"
                    class="pointer-events-none absolute -top-9 left-1/2 hidden -translate-x-1/2 rounded-full bg-slate-900 px-3 py-1 text-xs font-semibold text-white opacity-0 transition group-hover:opacity-100 group-focus-within:opacity-100 sm:block"
                >
                    Enviar para a Reciclagem
                </span>
                <transition name="fade">
                    <span
                        v-if="hintVisible.delete"
                        class="pointer-events-none absolute -top-10 left-1/2 -translate-x-1/2 rounded-full bg-slate-900/90 px-3 py-1 text-xs font-semibold text-white sm:hidden"
                    >
                        Enviar para a Reciclagem
                    </span>
                </transition>
            </div>
        </div>
    </div>
    <Teleport to="body">
        <ImagePreviewModal
            v-if="hasPhoto && showPreview"
            v-model="showPreview"
            :src="itemPhoto"
            :alt="item.title ?? item.name"
        />
    </Teleport>
</template>

<script setup>
import { computed, onMounted, reactive, ref, watch } from 'vue';
import { Package, Trash2, ZoomIn } from 'lucide-vue-next';
import ImagePreviewModal from '@/Components/ImagePreviewModal.vue';

const props = defineProps({
    item: {
        type: Object,
        required: true,
    },
    selectable: {
        type: Boolean,
        default: true,
    },
    selected: {
        type: Boolean,
        default: false,
    },
    showDelete: {
        type: Boolean,
        default: true,
    },
});

const emit = defineEmits(['toggle-select', 'delete']);

const isTouchDevice = ref(false);
const hintVisible = reactive({ delete: false });
const hintSeen = reactive({ delete: false });

const numberFormatter = new Intl.NumberFormat('pt-BR');
const decimalFormatter = new Intl.NumberFormat('pt-BR', {
    minimumFractionDigits: 1,
    maximumFractionDigits: 1,
});

const tooltipIds = computed(() => ({
    delete: `tooltip-delete-${props.item.id}`,
}));

const rawPhoto = computed(() => props.item?.photo || props.item?.thumbnail_url || props.item?.photo_url || null);
const sanitizedPhoto = computed(() => {
    if (!rawPhoto.value) return null;
    if (typeof rawPhoto.value !== 'string') return null;
    const trimmed = rawPhoto.value.trim();
    return trimmed || null;
});

const imageFailed = ref(false);
const showPreview = ref(false);

const hasPhoto = computed(() => Boolean(sanitizedPhoto.value) && !imageFailed.value);
const itemPhoto = computed(() => (hasPhoto.value ? sanitizedPhoto.value : null));

const handleImageError = () => {
    imageFailed.value = true;
};

watch(
    () => sanitizedPhoto.value,
    () => {
        imageFailed.value = false;
        showPreview.value = false;
    },
);

const volumeInfo = computed(() => {
    if (!props.item) return null;

    const rawLiters = props.item.volume_liters;
    const rawCm3 = props.item.volume_cm3;

    let litersValue = null;
    if (rawLiters != null) {
        const numeric = Number(rawLiters);
        litersValue = Number.isNaN(numeric) ? null : numeric;
    } else if (rawCm3 != null) {
        const numeric = Number(rawCm3);
        litersValue = Number.isNaN(numeric) ? null : numeric / 1000;
    }

    if (litersValue == null) {
        return null;
    }

    const cm3Value =
        rawCm3 != null && !Number.isNaN(Number(rawCm3))
            ? Number(rawCm3)
            : Math.round(litersValue * 1000);

    return {
        litersValue,
        litersFormatted: decimalFormatter.format(litersValue),
        cm3Value,
        cm3Formatted: numberFormatter.format(Math.round(cm3Value)),
    };
});

const volumeLabel = computed(() => {
    const info = volumeInfo.value;
    if (!info) return null;
    return `${info.litersFormatted} L (${info.cm3Formatted} cm³)`;
});

const weightPillLabel = computed(() => {
    const weight = props.item?.weight ?? props.item?.weight_kg ?? null;
    if (weight == null) return null;
    const numeric = Number(weight);
    if (Number.isNaN(numeric)) return null;
    return `Peso • ${decimalFormatter.format(numeric)} kg`;
});

const volumePillLabel = computed(() => {
    const info = volumeInfo.value;
    if (!info) return null;
    return `Volume • ${info.litersFormatted} L`;
});

const onToggle = (event) => {
    emit('toggle-select', { id: props.item.id, value: event.target.checked });
};

const handleHint = (key) => {
    if (!isTouchDevice.value || hintSeen[key] || hintVisible[key]) return;
    hintVisible[key] = true;
    hintSeen[key] = true;
    window.setTimeout(() => {
        hintVisible[key] = false;
    }, 1200);
};

const openPreview = () => {
    if (!hasPhoto.value) return;
    showPreview.value = true;
};

watch(
    () => props.item?.id,
    () => {
        showPreview.value = false;
    },
);

onMounted(() => {
    if (typeof window !== 'undefined') {
        isTouchDevice.value = 'ontouchstart' in window || navigator.maxTouchPoints > 0;
    }
});
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
    transition: opacity 0.2s ease;
}
.fade-enter-from,
.fade-leave-to {
    opacity: 0;
}
</style>
