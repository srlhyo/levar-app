<template>
    <div
        class="swipe-card relative w-[90%] max-w-md cursor-grab select-none sm:max-w-lg"
        :class="{ 'swipe-card--dragging': isDragging }"
        :style="cardStyle"
        @pointerdown="handlePointerDown"
        @pointermove="handlePointerMove"
        @pointerup="handlePointerEnd"
        @pointerleave="handlePointerEnd"
        @pointercancel="handlePointerEnd"
    >
        <div class="overflow-hidden rounded-3xl bg-white/90 shadow-lg/30 shadow-slate-200 ring-1 ring-black/5 backdrop-blur-sm">
            <div class="relative flex h-80 w-full items-center justify-center bg-slate-900/5">
                <img
                    v-if="hasPhoto"
                    :src="itemPhoto"
                    :alt="item.title ?? item.name"
                    class="max-h-full max-w-full select-none object-contain"
                    loading="lazy"
                    decoding="async"
                    draggable="false"
                    @dragstart.prevent
                    @error="handleImageError"
                />
                <Package v-else class="h-24 w-24 text-emerald-400/40" />
                <button
                    v-if="hasPhoto"
                    type="button"
                    class="absolute right-3 top-3 inline-flex h-9 w-9 items-center justify-center rounded-full bg-white/80 text-slate-700 shadow ring-1 ring-white/80 transition hover:bg-white focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-400"
                    @pointerdown.stop
                    @click.stop="openImageModal"
                    aria-label="Ampliar imagem"
                >
                    <ZoomIn class="h-4 w-4" />
                </button>
            </div>

            <div class="space-y-2 p-6">
                <h3 class="text-2xl font-semibold text-slate-900">{{ item.title ?? item.name }}</h3>
                <p v-if="item.weight" class="text-sm text-slate-600">
                    Peso: {{ Number(item.weight).toFixed(2) }} kg
                </p>
                <p v-if="volumeLabel" class="text-sm text-slate-600">
                    Volume: <span class="font-medium text-slate-700">{{ volumeLabel }}</span>
                </p>
                <div class="flex flex-wrap items-center gap-2 text-sm text-slate-600">
                    <span v-if="categoryText" class="inline-flex items-center gap-1 rounded-full bg-slate-100 px-2 py-0.5 text-xs font-medium text-slate-600">
                        {{ categoryText }}
                    </span>
                    <span
                        v-if="props.item.fragile"
                        class="inline-flex items-center gap-1 rounded-full bg-amber-100 px-2 py-0.5 text-xs font-semibold text-amber-700"
                    >
                        <AlertTriangle class="h-3.5 w-3.5" />
                        Frágil
                    </span>
                </div>
                <p v-if="item.notes" class="text-sm text-slate-600">
                    {{ item.notes }}
                </p>
                <div v-if="warningBadges.length" class="flex flex-wrap gap-2 pt-2">
                    <span
                        v-for="warning in warningBadges"
                        :key="warning"
                        class="inline-flex items-center gap-1 rounded-full bg-amber-50 px-2 py-0.5 text-[11px] font-medium text-amber-700 ring-1 ring-amber-200"
                    >
                        <AlertTriangle class="h-3 w-3" />
                        {{ warning }}
                    </span>
                </div>
            </div>
        </div>

        <transition name="fade">
            <div
                v-if="overlay === 'yes'"
                class="pointer-events-none absolute top-8 right-8 rotate-12 rounded-full bg-emerald-500 px-6 py-3 text-lg font-semibold text-white shadow"
            >
                LEVAR
            </div>
        </transition>
        <transition name="fade">
            <div
                v-if="overlay === 'no'"
                class="pointer-events-none absolute top-8 left-8 -rotate-12 rounded-full bg-rose-500 px-6 py-3 text-lg font-semibold text-white shadow"
            >
                NÃO LEVAR
            </div>
        </transition>
        <transition name="fade">
            <div
                v-if="overlay === 'pending'"
                class="pointer-events-none absolute top-8 left-1/2 -translate-x-1/2 rounded-full bg-amber-400 px-4 py-2 text-sm font-semibold text-slate-900 shadow"
            >
                DECIDIR DEPOIS
            </div>
        </transition>
    </div>

    <ImagePreviewModal
        v-if="hasPhoto"
        v-model="showImageModal"
        :src="itemPhoto"
        :alt="props.item.title ?? props.item.name"
    />
</template>

<script setup>
import { computed, defineExpose, ref, watch } from 'vue';
import { AlertTriangle, Package, ZoomIn } from 'lucide-vue-next';
import ImagePreviewModal from '@/Components/ImagePreviewModal.vue';

const props = defineProps({
    item: {
        type: Object,
        required: true,
    },
    disabled: {
        type: Boolean,
        default: false,
    },
});

const emit = defineEmits(['decision']);

const numberFormatter = new Intl.NumberFormat('pt-BR');

const rawPhoto = computed(() => props.item?.photo || props.item?.thumbnail_url || props.item?.photo_url || null);
const sanitizedPhoto = computed(() => {
    if (!rawPhoto.value) {
        return null;
    }
    if (typeof rawPhoto.value !== 'string') {
        return null;
    }
    const trimmed = rawPhoto.value.trim();
    if (!trimmed) {
        return null;
    }
    return trimmed;
});

const imageFailed = ref(false);

const hasPhoto = computed(() => Boolean(sanitizedPhoto.value) && !imageFailed.value);
const itemPhoto = computed(() => (hasPhoto.value ? sanitizedPhoto.value : null));

const handleImageError = () => {
    imageFailed.value = true;
};

watch(
    () => sanitizedPhoto.value,
    () => {
        imageFailed.value = false;
    },
);

const categoryText = computed(() => {
    const raw = props.item.category;
    if (typeof raw !== 'string' || !raw.trim()) return '';
    return raw.replace(/_/g, ' ').replace(/\b\w/g, (char) => char.toUpperCase());
});

const volumeLabel = computed(() => {
    if (!props.item) return null;
    const liters = props.item.volume_liters ?? (props.item.volume_cm3 != null ? props.item.volume_cm3 / 1000 : null);
    if (liters == null || Number.isNaN(liters)) {
        return null;
    }
    const cm3 = props.item.volume_cm3 ?? liters * 1000;
    return `${Number(liters).toFixed(1)} L (${numberFormatter.format(Math.round(cm3))} cm³)`;
});

const warningBadges = computed(() => {
    const badges = [];
    if (!props.item?.weight && !props.item?.weight_kg) {
        badges.push('Sem peso estimado');
    }
    if (!props.item?.volume_cm3) {
        badges.push('Sem volume');
    }
    if (!props.item?.photo_url && !props.item?.thumbnail_url) {
        badges.push('Sem foto');
    }
    return badges;
});

const positionX = ref(0);
const positionY = ref(0);
const dragDeltaX = ref(0);
const dragDeltaY = ref(0);
const isDragging = ref(false);
const startX = ref(0);
const startY = ref(0);
const transitionStyle = ref('transform 0.25s ease-out');
const isAnimating = ref(false);

const HORIZONTAL_THRESHOLD = 80;
const VERTICAL_THRESHOLD = 130;
const VERTICAL_DAMPING = 0.25;
const MAX_VERTICAL_DRIFT = 90;

const handlePointerDown = (event) => {
    if (props.disabled || isAnimating.value) return;
    if (event.cancelable) {
        event.preventDefault();
    }
    isDragging.value = true;
    transitionStyle.value = 'none';
    startX.value = event.clientX;
    startY.value = event.clientY;
    dragDeltaX.value = 0;
    dragDeltaY.value = 0;
    event.currentTarget.setPointerCapture(event.pointerId);
};

const handlePointerMove = (event) => {
    if (!isDragging.value) return;
    const deltaX = event.clientX - startX.value;
    const deltaY = event.clientY - startY.value;
    dragDeltaX.value = deltaX;
    dragDeltaY.value = deltaY;

    if (event.cancelable) {
        event.preventDefault();
    }

    positionX.value = deltaX;
    const dampedY = deltaY * VERTICAL_DAMPING;
    positionY.value = Math.max(Math.min(dampedY, MAX_VERTICAL_DRIFT), -MAX_VERTICAL_DRIFT);
};

const handlePointerEnd = (event) => {
    if (!isDragging.value) return;
    isDragging.value = false;
    transitionStyle.value = 'transform 0.25s ease-out';
    event.currentTarget?.releasePointerCapture?.(event.pointerId);
    const deltaX = dragDeltaX.value;
    const deltaY = dragDeltaY.value;
    const absX = Math.abs(deltaX);
    const absY = Math.abs(deltaY);
    const horizontalSwipe = absX > HORIZONTAL_THRESHOLD && absX > absY;
    const verticalSwipe = deltaY > VERTICAL_THRESHOLD && absY > absX;

    if (horizontalSwipe) {
        triggerDecision(deltaX > 0 ? 'yes' : 'no');
        return;
    }

    if (verticalSwipe) {
        triggerDecision('pending');
        return;
    }

    resetCard();
};

const cardStyle = computed(() => ({
    transform: `translate(${positionX.value}px, ${positionY.value}px) rotate(${positionX.value / 12}deg)`,
    transition: transitionStyle.value,
    opacity: Math.max(0.4, 1 - Math.abs(positionX.value) / 350),
}));

const overlay = computed(() => {
    const deltaX = dragDeltaX.value;
    const deltaY = dragDeltaY.value;
    const absX = Math.abs(deltaX);
    const absY = Math.abs(deltaY);

    if (deltaY > VERTICAL_THRESHOLD * 0.5 && absY > absX) {
        return 'pending';
    }

    if (deltaX > HORIZONTAL_THRESHOLD * 0.4) return 'yes';
    if (deltaX < -HORIZONTAL_THRESHOLD * 0.4) return 'no';
    return null;
});

const resetCard = () => {
    transitionStyle.value = 'transform 0.25s ease-out';
    positionX.value = 0;
    positionY.value = 0;
    dragDeltaX.value = 0;
    dragDeltaY.value = 0;
    isAnimating.value = false;
};

const emitDecision = (decision, options = {}) => {
    emit('decision', { type: decision, options });
};

const triggerDecision = (decision, options = {}) => {
    if (isAnimating.value) return;
    isAnimating.value = true;

    if (decision === 'pending') {
        transitionStyle.value = 'transform 0.18s ease-out';
        positionY.value = 40;
        window.setTimeout(() => {
            resetCard();
            emitDecision('pending', options);
        }, 220);
        return;
    }

    transitionStyle.value = 'transform 0.3s ease-in';
    const width = typeof window === 'undefined' ? 800 : window.innerWidth;
    positionX.value = decision === 'yes' ? width : -width;
    positionY.value = decision === 'yes' ? -20 : 20;
    window.setTimeout(() => {
        resetCard();
        emitDecision(decision, options);
    }, 220);
};

const triggerFromParent = (decision, options = {}) => {
    if (props.disabled) return;
    triggerDecision(decision, options);
};

defineExpose({ triggerDecision: triggerFromParent });

const showImageModal = ref(false);

const openImageModal = () => {
    if (!hasPhoto.value) return;
    showImageModal.value = true;
};

watch(
    () => props.item?.id,
    () => {
        resetCard();
        showImageModal.value = false;
    },
);
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
    transition: opacity 0.18s ease;
}
.fade-enter-from,
.fade-leave-to {
    opacity: 0;
}

.swipe-card {
    touch-action: none;
    user-select: none;
}
.swipe-card--dragging {
    cursor: grabbing;
}
</style>
