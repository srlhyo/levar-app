<template>
    <div
        class="relative w-[90%] max-w-md cursor-grab select-none sm:max-w-lg"
        :style="cardStyle"
        @pointerdown="handlePointerDown"
        @pointermove="handlePointerMove"
        @pointerup="handlePointerEnd"
        @pointerleave="handlePointerEnd"
        @pointercancel="handlePointerEnd"
    >
        <div class="overflow-hidden rounded-3xl bg-white/90 shadow-lg/30 shadow-slate-200 ring-1 ring-black/5 backdrop-blur-sm">
            <img
                v-if="item.photo"
                :src="item.photo"
                :alt="item.title ?? item.name"
                class="h-80 w-full object-cover"
            />
            <div v-else class="flex h-80 w-full items-center justify-center bg-emerald-100">
                <Package class="h-24 w-24 text-emerald-400/40" />
            </div>

            <div class="space-y-2 p-6">
                <h3 class="text-2xl font-semibold text-slate-900">{{ item.title ?? item.name }}</h3>
                <p v-if="item.weight" class="text-sm text-slate-600">
                    Peso: {{ Number(item.weight).toFixed(2) }} kg
                </p>
                <p v-if="item.notes" class="text-sm text-slate-600">
                    {{ item.notes }}
                </p>
            </div>
        </div>

        <transition name="fade">
            <div
                v-if="overlay === 'yes'"
                class="absolute top-8 right-8 rotate-12 rounded-full bg-emerald-500 px-6 py-3 text-lg font-semibold text-white shadow"
            >
                LEVAR
            </div>
        </transition>
        <transition name="fade">
            <div
                v-if="overlay === 'no'"
                class="absolute top-8 left-8 -rotate-12 rounded-full bg-rose-500 px-6 py-3 text-lg font-semibold text-white shadow"
            >
                NÃO LEVAR
            </div>
        </transition>
        <transition name="fade">
            <div
                v-if="overlay === 'pending'"
                class="absolute bottom-8 left-1/2 -translate-x-1/2 rounded-full bg-amber-400 px-4 py-2 text-sm font-semibold text-slate-900 shadow"
            >
                DECIDIR DEPOIS
            </div>
        </transition>
    </div>
</template>

<script setup>
import { computed, defineExpose, ref, watch } from 'vue';
import { Package } from 'lucide-vue-next';

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

const positionX = ref(0);
const positionY = ref(0);
const isDragging = ref(false);
const startX = ref(0);
const startY = ref(0);
const transitionStyle = ref('transform 0.25s ease-out');
const isAnimating = ref(false);

const HORIZONTAL_THRESHOLD = 80;
const VERTICAL_THRESHOLD = 60;

const handlePointerDown = (event) => {
    if (props.disabled || isAnimating.value) return;
    isDragging.value = true;
    transitionStyle.value = 'none';
    startX.value = event.clientX;
    startY.value = event.clientY;
    event.currentTarget.setPointerCapture(event.pointerId);
};

const handlePointerMove = (event) => {
    if (!isDragging.value) return;
    positionX.value = event.clientX - startX.value;
    positionY.value = event.clientY - startY.value;
};

const handlePointerEnd = (event) => {
    if (!isDragging.value) return;
    isDragging.value = false;
    transitionStyle.value = 'transform 0.25s ease-out';
    event.currentTarget?.releasePointerCapture?.(event.pointerId);

    const deltaX = event.clientX - startX.value;
    const deltaY = event.clientY - startY.value;
    const absX = Math.abs(deltaX);
    const absY = Math.abs(deltaY);

    if (absX > HORIZONTAL_THRESHOLD && absX > absY) {
        triggerDecision(deltaX > 0 ? 'yes' : 'no');
        return;
    }

    if (deltaY > VERTICAL_THRESHOLD && absY > absX) {
        triggerDecision('pending');
        return;
    }

    resetCard();
};

const cardStyle = computed(() => ({
    transform: `translate(${positionX.value}px, ${positionY.value}px) rotate(${positionX.value / 12}deg)`,
    transition: transitionStyle.value,
    opacity: Math.max(0.4, 1 - Math.abs(positionX.value) / 350),
    touchAction: 'none',
}));

const overlay = computed(() => {
    if (positionY.value > VERTICAL_THRESHOLD) return 'pending';
    if (positionX.value > HORIZONTAL_THRESHOLD) return 'yes';
    if (positionX.value < -HORIZONTAL_THRESHOLD) return 'no';
    return null;
});

const resetCard = () => {
    transitionStyle.value = 'transform 0.25s ease-out';
    positionX.value = 0;
    positionY.value = 0;
    isAnimating.value = false;
};

const triggerDecision = (decision) => {
    if (isAnimating.value) return;
    isAnimating.value = true;

    if (decision === 'pending') {
        transitionStyle.value = 'transform 0.18s ease-out';
        positionY.value = 40;
        window.setTimeout(() => {
            resetCard();
            emit('decision', 'pending');
        }, 220);
        return;
    }

    transitionStyle.value = 'transform 0.3s ease-in';
    const width = typeof window === 'undefined' ? 800 : window.innerWidth;
    positionX.value = decision === 'yes' ? width : -width;
    positionY.value = decision === 'yes' ? -20 : 20;
    window.setTimeout(() => {
        resetCard();
        emit('decision', decision);
    }, 220);
};

const triggerFromParent = (decision) => {
    if (props.disabled) return;
    triggerDecision(decision);
};

defineExpose({ triggerDecision: triggerFromParent });

watch(
    () => props.item?.id,
    () => {
        resetCard();
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
</style>
