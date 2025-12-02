<template>
    <article class="resumo-item-row" :class="{ 'resumo-item-row--selected': selectable && selected }">
        <div class="resumo-item-row__select">
            <label v-if="selectable" class="resumo-item-row__checkbox-wrap">
                <input
                    :checked="selected"
                    type="checkbox"
                    class="resumo-item-row__checkbox"
                    @change="onToggle"
                />
            </label>
        </div>
        <div class="resumo-item-row__card">
            <div class="resumo-item-media" :class="{ 'resumo-item-media--empty': !hasPhoto }">
                <img
                    v-if="hasPhoto"
                    :src="itemPhoto"
                    :alt="item.title ?? item.name"
                    class="resumo-item-media__image"
                    loading="lazy"
                    decoding="async"
                    @error="handleImageError"
                    @click.stop="openPreview"
                />
                <TileIcon3D v-else tone="slate" class="resumo-item-media__placeholder">
                    <Package class="h-5 w-5" />
                </TileIcon3D>
                <button
                    v-if="hasPhoto"
                    type="button"
                    class="resumo-item-media__preview"
                    @click.stop="openPreview"
                    aria-label="Ampliar imagem"
                >
                    <ZoomIn class="h-4 w-4" />
                </button>
            </div>
            <div class="resumo-item-content">
                <div class="resumo-item-head">
                    <div>
                        <p class="resumo-item-title">{{ item.title ?? item.name }}</p>
                        <p v-if="item.notes" class="resumo-item-notes">{{ item.notes }}</p>
                    </div>
                </div>
                <div class="resumo-item-metrics">
                    <span v-if="weightPillLabel" class="resumo-item-chip resumo-item-chip--weight">
                        {{ weightPillLabel }}
                    </span>
                    <span
                        v-if="volumePillLabel"
                        :title="volumeLabel ?? ''"
                        class="resumo-item-chip resumo-item-chip--volume"
                    >
                        {{ volumePillLabel }}
                    </span>
                </div>
                <div class="resumo-item-badges">
                    <span v-if="item.fragile" class="resumo-item-badge resumo-item-badge--warning">Frágil</span>
                </div>
            </div>
            <div v-if="showDelete" class="resumo-item-actions">
                <button
                    type="button"
                    :aria-describedby="tooltipIds.delete"
                    aria-label="Enviar para a Reciclagem"
                    class="resumo-item-actions__delete"
                    @click="emit('delete', item.id)"
                    @touchstart="() => handleHint('delete')"
                >
                    <Trash2 class="h-5 w-5" />
                </button>
                <span :id="tooltipIds.delete" class="resumo-item-tooltip">Enviar para a Reciclagem</span>
                <transition name="fade">
                    <span v-if="hintVisible.delete" class="resumo-item-tooltip resumo-item-tooltip--mobile">
                        Enviar para a Reciclagem
                    </span>
                </transition>
            </div>
        </div>
    </article>
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
import {
    computed,
    onMounted,
    reactive,
    ref,
    watch,
} from 'vue';
import { Package, Trash2, ZoomIn } from 'lucide-vue-next';
import TileIcon3D from '@/Components/home/TileIcon3D.vue';
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
.resumo-item-row {
    display: flex;
    align-items: stretch;
    gap: 0.75rem;
    padding: 1rem;
    border-radius: 1.75rem;
    border: 1px solid rgba(148, 163, 184, 0.35);
    background: rgba(248, 250, 252, 0.9);
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.7),
        0 18px 35px rgba(15, 23, 42, 0.12);
}
.resumo-item-row--selected {
    box-shadow:
        inset 0 0 0 2px rgba(99, 102, 241, 0.45),
        0 22px 44px rgba(79, 70, 229, 0.2);
}
.resumo-item-row__select {
    display: flex;
    align-items: flex-start;
    padding-top: 0.4rem;
}
.resumo-item-row__checkbox-wrap {
    display: inline-flex;
}
.resumo-item-row__checkbox {
    width: 1.1rem;
    height: 1.1rem;
    border-radius: 0.4rem;
    border: 1px solid rgba(148, 163, 184, 0.8);
}
.resumo-item-row__card {
    flex: 1;
    display: flex;
    gap: 0.9rem;
}
.resumo-item-media {
    width: 5rem;
    height: 5rem;
    border-radius: 1.4rem;
    position: relative;
    overflow: hidden;
    background: rgba(15, 23, 42, 0.05);
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.6);
}
.resumo-item-media--empty {
    background: linear-gradient(135deg, rgba(241, 245, 249, 0.95), rgba(203, 213, 225, 0.6));
}
.resumo-item-media__image {
    max-width: 100%;
    max-height: 100%;
    object-fit: contain;
    cursor: zoom-in;
    transition: transform 0.2s ease;
}
.resumo-item-media__image:hover {
    transform: scale(1.05);
}
.resumo-item-media__placeholder {
    --tile-icon-size: 4rem;
}
.resumo-item-media__preview {
    position: absolute;
    right: 0.4rem;
    top: 0.4rem;
    width: 1.9rem;
    height: 1.9rem;
    border-radius: 0.9rem;
    background: rgba(255, 255, 255, 0.95);
    color: #0f172a;
    display: grid;
    place-items: center;
    box-shadow: 0 10px 20px rgba(15, 23, 42, 0.15);
}
.resumo-item-content {
    flex: 1;
    border-radius: 1.5rem;
    padding: 1rem 1.25rem;
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.96), rgba(248, 250, 252, 0.92));
    border: 1px solid rgba(226, 232, 240, 0.8);
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
}
.resumo-item-head {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    gap: 0.8rem;
}
.resumo-item-title {
    font-size: 1.05rem;
    font-weight: 700;
    color: #0f172a;
}
.resumo-item-notes {
    font-size: 0.9rem;
    color: #475569;
    margin-top: 0.1rem;
}
.resumo-item-head__icon {
    --tile-icon-size: 2.6rem;
}
.resumo-item-metrics {
    display: flex;
    flex-wrap: wrap;
    gap: 0.4rem;
}
.resumo-item-chip {
    border-radius: 999px;
    padding: 0.32rem 0.9rem;
    font-size: 0.78rem;
    font-weight: 600;
    border: 1px solid transparent;
}
.resumo-item-chip--weight {
    background: rgba(15, 23, 42, 0.9);
    color: white;
}
.resumo-item-chip--volume {
    background: rgba(191, 219, 254, 0.4);
    color: #0369a1;
    border-color: rgba(59, 130, 246, 0.45);
}
.resumo-item-badges {
    display: flex;
    flex-wrap: wrap;
    gap: 0.35rem;
}
.resumo-item-badge {
    border-radius: 999px;
    padding: 0.25rem 0.75rem;
    font-size: 0.7rem;
    font-weight: 600;
    background: rgba(148, 163, 184, 0.12);
    color: #475569;
}
.resumo-item-badge--warning {
    background: rgba(251, 113, 133, 0.18);
    color: #be185d;
    border: 1px solid rgba(244, 63, 94, 0.4);
}
.resumo-item-actions {
    display: flex;
    align-items: center;
    align-self: stretch;
}
.resumo-item-actions__delete {
    width: 2.6rem;
    height: 2.6rem;
    border-radius: 0.9rem;
    background: rgba(255, 255, 255, 0.95);
    color: #e11d48;
    border: 1px solid rgba(248, 113, 113, 0.45);
    box-shadow: 0 12px 30px rgba(225, 29, 72, 0.18);
    position: relative;
}
.resumo-item-tooltip {
    pointer-events: none;
    position: absolute;
    top: -2.25rem;
    left: 50%;
    transform: translateX(-50%);
    padding: 0.25rem 0.8rem;
    border-radius: 999px;
    background: rgba(15, 23, 42, 0.92);
    color: white;
    font-size: 0.72rem;
    font-weight: 600;
    opacity: 0;
    transition: opacity 0.15s ease;
}
.resumo-item-actions__delete:hover + .resumo-item-tooltip,
.resumo-item-actions__delete:focus-visible + .resumo-item-tooltip {
    opacity: 1;
}
.resumo-item-tooltip--mobile {
    display: inline-block;
    opacity: 1;
    top: -2.5rem;
}

.fade-enter-active,
.fade-leave-active {
    transition: opacity 0.2s ease;
}
.fade-enter-from,
.fade-leave-to {
    opacity: 0;
}
</style>
