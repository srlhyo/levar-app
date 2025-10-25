<template>
    <div
        class="relative w-full max-w-sm cursor-grab select-none"
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
                :alt="item.name"
                class="w-full h-80 object-cover"
            />
            <div
                v-else
                class="flex h-80 w-full items-center justify-center bg-emerald-100"
            >
                <Package class="h-24 w-24 text-emerald-400/40" />
            </div>

            <div class="space-y-2 p-6">
                <h3 class="text-2xl font-semibold text-slate-900">{{ item.name }}</h3>
                <p v-if="item.weight" class="text-sm text-slate-600">
                    Peso: {{ Number(item.weight).toFixed(2) }} kg
                </p>
                <p v-if="item.notes" class="text-sm text-slate-600">
                    {{ item.notes }}
                </p>
            </div>
        </div>

        <div
            v-if="positionX > 50"
            class="absolute top-8 right-8 rotate-12 rounded-full bg-emerald-500 px-6 py-3 text-lg font-semibold text-white shadow"
        >
            LEVAR
        </div>
        <div
            v-if="positionX < -50"
            class="absolute top-8 left-8 -rotate-12 rounded-full bg-rose-500 px-6 py-3 text-lg font-semibold text-white shadow"
        >
            NÃO
        </div>
    </div>
</template>

<script setup>
import { computed, ref } from 'vue';
import { Package } from 'lucide-vue-next';

const props = defineProps({
    item: {
        type: Object,
        required: true,
    },
});

const emit = defineEmits(['swipe']);

const positionX = ref(0);
const isDragging = ref(false);
const startX = ref(0);

const handlePointerDown = (event) => {
    isDragging.value = true;
    startX.value = event.clientX - positionX.value;
    event.currentTarget.setPointerCapture(event.pointerId);
};

const handlePointerMove = (event) => {
    if (!isDragging.value) return;
    positionX.value = event.clientX - startX.value;
};

const handlePointerEnd = (event) => {
    if (!isDragging.value) return;
    isDragging.value = false;
    event.currentTarget?.releasePointerCapture?.(event.pointerId);

    const threshold = 100;
    if (positionX.value > threshold) {
        emit('swipe', 'keep');
    } else if (positionX.value < -threshold) {
        emit('swipe', 'discard');
    }

    positionX.value = 0;
};

const cardStyle = computed(() => ({
    transform: `translateX(${positionX.value}px) rotate(${positionX.value / 10}deg)`,
    transition: isDragging.value ? 'none' : 'transform 0.3s ease-out',
    opacity: Math.max(0.3, 1 - Math.abs(positionX.value) / 200),
    touchAction: 'none',
}));
</script>
