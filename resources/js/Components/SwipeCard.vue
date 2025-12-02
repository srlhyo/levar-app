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
        <div class="swipe-card__surface">
            <div class="swipe-card__media">
                <img
                    v-if="hasPhoto"
                    :src="itemPhoto"
                    :alt="item.title ?? item.name"
                    class="swipe-card__photo"
                    loading="lazy"
                    decoding="async"
                    draggable="false"
                    @dragstart.prevent
                    @error="handleImageError"
                />
                <Package v-else class="h-24 w-24 text-indigo-200" />
                <button
                    v-if="hasPhoto"
                    type="button"
                    class="swipe-card__media-button"
                    @pointerdown.stop
                    @click.stop="openImageModal"
                    aria-label="Ampliar imagem"
                >
                    <ZoomIn class="h-4 w-4" />
                </button>
            </div>

            <div class="swipe-card__body">
                <h3 class="swipe-card__title">{{ item.title ?? item.name }}</h3>
                <p v-if="item.weight" class="swipe-card__meta">
                    Peso: {{ Number(item.weight).toFixed(2) }} kg
                </p>
                <p v-if="volumeLabel" class="swipe-card__meta">
                    Volume: <span class="font-medium text-slate-700">{{ volumeLabel }}</span>
                </p>
                <div class="swipe-card__tags">
                    <span v-if="categoryText" class="swipe-card__chip">
                        {{ categoryText }}
                    </span>
                    <span
                        v-if="props.item.fragile"
                        class="swipe-card__chip swipe-card__chip--alert"
                    >
                        <AlertTriangle class="h-3.5 w-3.5" />
                        Frágil
                    </span>
                </div>
                <p v-if="item.notes" class="swipe-card__meta">
                    {{ item.notes }}
                </p>
                <div v-if="warningBadges.length" class="swipe-card__warnings">
                    <span
                        v-for="warning in warningBadges"
                        :key="warning"
                        class="swipe-card__warning"
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
                class="swipe-card__badge swipe-card__badge--yes"
            >
                LEVAR
            </div>
        </transition>
        <transition name="fade">
            <div
                v-if="overlay === 'no'"
                class="swipe-card__badge swipe-card__badge--no"
            >
                NÃO LEVAR
            </div>
        </transition>
        <transition name="fade">
            <div
                v-if="overlay === 'pending'"
                class="swipe-card__badge swipe-card__badge--pending"
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
.swipe-card__surface {
    overflow: hidden;
    border-radius: 1.75rem;
    background: rgba(255, 255, 255, 0.92);
    border: 1px solid rgba(148, 163, 184, 0.35);
    box-shadow:
        0 25px 60px rgba(15, 23, 42, 0.15),
        inset 0 1px 0 rgba(255, 255, 255, 0.5);
    backdrop-filter: blur(12px);
    position: relative;
}
.swipe-card__surface::before {
    content: '';
    position: absolute;
    inset: 0;
    background: linear-gradient(135deg, rgba(79, 70, 229, 0.1), rgba(14, 165, 233, 0.08));
    opacity: 0.8;
    animation: cardAurora 24s ease infinite;
}
.swipe-card__surface > * {
    position: relative;
    z-index: 1;
}
.swipe-card__media {
    position: relative;
    display: flex;
    height: 18rem;
    width: 100%;
    align-items: center;
    justify-content: center;
    background:
        radial-gradient(circle at 30% 20%, rgba(255, 255, 255, 0.35), transparent 55%),
        linear-gradient(140deg, rgba(248, 250, 252, 0.92), rgba(219, 234, 254, 0.9));
}
.swipe-card__photo {
    max-height: 100%;
    max-width: 100%;
    object-fit: contain;
    user-select: none;
}
.swipe-card__media-button {
    position: absolute;
    right: 1rem;
    top: 1rem;
    display: inline-flex;
    width: 2.5rem;
    height: 2.5rem;
    align-items: center;
    justify-content: center;
    border-radius: 999px;
    background: rgba(255, 255, 255, 0.9);
    color: #0f172a;
    box-shadow: 0 8px 20px rgba(15, 23, 42, 0.15);
    border: 1px solid rgba(148, 163, 184, 0.3);
}
.swipe-card__body {
    padding: 1.75rem;
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
}
.swipe-card__title {
    font-size: 1.65rem;
    font-weight: 600;
    color: #0f172a;
}
.swipe-card__meta {
    font-size: 0.95rem;
    color: #475569;
}
.swipe-card__tags {
    display: flex;
    flex-wrap: wrap;
    gap: 0.4rem;
    font-size: 0.85rem;
    color: #475569;
}
.swipe-card__chip {
    display: inline-flex;
    align-items: center;
    gap: 0.35rem;
    padding: 0.2rem 0.75rem;
    border-radius: 999px;
    background: rgba(226, 232, 240, 0.7);
    font-size: 0.75rem;
    font-weight: 600;
}
.swipe-card__chip--alert {
    background: rgba(253, 230, 138, 0.5);
    color: #b45309;
}
.swipe-card__warnings {
    display: flex;
    flex-wrap: wrap;
    gap: 0.6rem;
    padding-top: 0.4rem;
}
.swipe-card__warning {
    display: inline-flex;
    align-items: center;
    gap: 0.35rem;
    border-radius: 999px;
    background: rgba(253, 230, 138, 0.25);
    color: #92400e;
    font-size: 0.72rem;
    font-weight: 600;
    padding: 0.2rem 0.75rem;
    border: 1px solid rgba(251, 191, 36, 0.4);
}
.swipe-card__badge {
    pointer-events: none;
    position: absolute;
    top: 1.5rem;
    padding: 0.65rem 1.5rem;
    border-radius: 999px;
    font-size: 0.95rem;
    font-weight: 700;
    letter-spacing: 0.08em;
    color: #fff;
    box-shadow: 0 15px 35px rgba(15, 23, 42, 0.25);
}
.swipe-card__badge--yes {
    right: 2rem;
    transform: rotate(8deg);
    background: linear-gradient(135deg, #34d399, #10b981);
}
.swipe-card__badge--no {
    left: 2rem;
    transform: rotate(-8deg);
    background: linear-gradient(135deg, #fb7185, #ef4444);
}
.swipe-card__badge--pending {
    left: 50%;
    transform: translateX(-50%);
    background: linear-gradient(135deg, #fcd34d, #fbbf24);
    color: #1f2937;
}
@keyframes cardAurora {
    0% {
        opacity: 0.55;
        transform: translateY(0);
    }
    50% {
        opacity: 0.9;
        transform: translateY(-6px);
    }
    100% {
        opacity: 0.55;
        transform: translateY(0);
    }
}
</style>
