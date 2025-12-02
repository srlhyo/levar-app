<template>
    <div
        class="flex flex-col items-center gap-3 rounded-2xl border border-slate-100 bg-white/80 p-4 text-center shadow-sm transition hover:-translate-y-0.5 hover:shadow-md sm:p-5"
    >
        <div
            class="suitcase-3d"
            @pointermove="handlePointerMove"
            @pointerleave="handlePointerLeave"
            @touchmove.prevent="handleTouchMove"
            @touchend="handlePointerLeave"
        >
            <div class="suitcase-3d__shadow" aria-hidden="true" />
            <div
                :class="[
                    'suitcase-3d__body relative mx-auto w-28 h-40 sm:w-32 sm:h-44',
                    { 'suitcase-3d__body--active': pointerActive, 'suitcase-3d__body--locked': status === 'Fechado' },
                ]"
                :style="bodyStyle"
            >
                <div class="suitcase-3d__face suitcase-3d__face--back" />
                <div class="suitcase-3d__side suitcase-3d__side--left" />
                <div class="suitcase-3d__side suitcase-3d__side--right" />
                <div class="suitcase-3d__side suitcase-3d__side--top" />
                <div class="suitcase-3d__side suitcase-3d__side--bottom" />

                <div
                    class="suitcase-3d__face suitcase-3d__face--front"
                    role="img"
                    :aria-label="`${name}, ${dims}, ${current.toFixed(1)} de ${max} quilos, status ${status}`"
                >
                    <div class="absolute -top-3 left-1/2 h-2 w-8 -translate-x-1/2 rounded-full bg-slate-400" />
                    <div class="absolute -top-1 left-1/2 h-4 w-[2px] -translate-x-1/2 bg-slate-300" />

                    <div
                        class="absolute inset-0 rounded-[14px] border shadow-inner transition"
                        :class="[shellClass, pulseClass]"
                    >
                        <div class="absolute top-6 left-2 right-2 h-[2px] rounded bg-white/60" />
                        <div class="absolute top-[30%] left-3 right-3 h-[1.5px] rounded bg-white/50" />
                        <div class="absolute top-[55%] left-3 right-3 h-[1.5px] rounded bg-white/50" />
                        <div class="absolute top-[75%] left-3 right-3 h-[1.5px] rounded bg-white/60" />
                        <div class="absolute bottom-3 left-3 right-3 h-[6px] rounded-full bg-white/60" />

                        <div class="absolute top-2 left-2 h-2 w-2 rounded-full bg-white/70" />
                        <div class="absolute top-2 right-2 h-2 w-2 rounded-full bg-white/70" />
                        <div class="absolute bottom-2 left-2 h-2 w-2 rounded-full bg-white/70" />
                        <div class="absolute bottom-2 right-2 h-2 w-2 rounded-full bg-white/70" />

                        <div
                            class="absolute bottom-[10px] left-[6px] right-[6px] rounded-b-[10px] bg-amber-400/45 transition-all duration-700 ease-in-out"
                            :style="{ height: `${Math.min(Math.max(ratio, 0), 1.2) * 60}%` }"
                        />

                        <div class="absolute -bottom-2 left-6 right-6 mx-auto flex w-16 justify-between sm:left-8 sm:right-8 sm:w-20">
                            <span class="h-3.5 w-3.5 rounded-full bg-slate-400 ring-2 ring-yellow-100" />
                            <span class="h-3.5 w-3.5 rounded-full bg-slate-400 ring-2 ring-yellow-100" />
                        </div>

                        <Lock
                            v-if="status === 'Fechado'"
                            class="absolute right-2 top-2 h-4 w-4 text-red-500"
                        />
                    </div>
                </div>
            </div>
        </div>

        <div class="space-y-1">
            <p class="text-sm font-semibold text-slate-800">
                {{ name }} — {{ dims }}
            </p>
            <p class="text-xs text-slate-500">
                {{ weightSummary }}
            </p>
            <p v-if="volumeSummary" class="text-xs text-slate-500">
                {{ volumeSummary }}
            </p>
            <p class="text-sm font-semibold" :class="statusLabelClass">
                {{ status }}
            </p>
            <p
                v-if="hasNotes"
                class="flex items-center justify-center gap-1 text-xs font-medium text-amber-600"
            >
                <span aria-hidden="true">📝</span>
                Notas salvas
            </p>
        </div>
    </div>
</template>

<script setup>
import { computed, ref } from 'vue';
import { Lock } from 'lucide-vue-next';

const numberFormatter = new Intl.NumberFormat('pt-BR');

const props = defineProps({
    name: {
        type: String,
        required: true,
    },
    dims: {
        type: String,
        required: true,
    },
    current: {
        type: Number,
        required: true,
    },
    max: {
        type: Number,
        required: true,
    },
    status: {
        type: String,
        required: true,
        validator: (value) => ['Normal', 'Lotado', 'Fechado'].includes(value),
    },
    ratio: {
        type: Number,
        default: 0,
    },
    weight: {
        type: Object,
        default: null,
    },
    volume: {
        type: Object,
        default: null,
    },
    hasNotes: {
        type: Boolean,
        default: false,
    },
});

const shellClass = computed(() => {
    switch (props.status) {
        case 'Lotado':
            return 'from-yellow-50 to-yellow-100 border-yellow-300';
        case 'Fechado':
            return 'from-red-50 to-red-100 border-red-300';
        default:
            return 'from-slate-50 to-slate-100 border-slate-200';
    }
});


const parseDimensions = (raw) => {
    if (typeof raw !== 'string') return null;
    const parts = raw
        .split(/[x×]/i)
        .map((part) => parseFloat(part.replace(/[^\d.,]/g, '').replace(',', '.')))
        .filter((value) => !Number.isNaN(value) && value > 0);

    if (parts.length < 3) return null;

    const [length, width, height] = parts;
    return {
        length,
        width,
        height,
        volume: length * width * height,
    };
};

const capacityFromProps = computed(() => {
    if (props.volume?.capacity != null) {
        return Number(props.volume.capacity);
    }

    if (props.dims) {
        const parsed = parseDimensions(props.dims);
        return parsed?.volume ?? null;
    }

    return null;
});

const statusLabelClass = computed(() => {
    switch (props.status) {
        case 'Lotado':
            return 'text-yellow-600';
        case 'Fechado':
            return 'text-red-600';
        default:
            return 'text-slate-600';
    }
});

const pulseClass = computed(() => (props.status === 'Lotado' || props.status === 'Fechado' ? 'animate-[pulse_1.4s_ease-in-out_1]' : ''));

const formatKg = (value) => `${value.toFixed(1)} kg`;

const toLiters = (value) => `${(value / 1000).toFixed(1)} L`;
const formatCm3 = (value) => `${numberFormatter.format(Math.round(value))} cm³`;

const weightSummary = computed(() => {
    const capacity = Number(props.max ?? 0) || 0;
    const effective = Number(props.weight?.effective ?? props.current ?? 0);
    const reserved = Number(props.weight?.reserved ?? 0);
    const remaining = props.weight?.remaining != null ? Number(props.weight.remaining) : null;

    let summary = `${formatKg(effective)} / ${formatKg(capacity)}`;
    if (reserved > 0.01) {
        summary += ` (inclui ${formatKg(reserved)} reservado)`;
    }

    if (remaining != null) {
        summary += ` • ${formatKg(Math.max(remaining, 0))} livres`;
    }

    return summary;
});

const pointerActive = ref(false);
const tiltX = ref(0);
const tiltY = ref(0);

const bodyStyle = computed(() => (pointerActive.value
    ? { transform: `rotateX(${tiltX.value}deg) rotateY(${tiltY.value}deg)` }
    : undefined));

const handlePointerMove = (event) => {
    const target = event.currentTarget;
    if (!target) return;
    const rect = target.getBoundingClientRect();
    const x = (event.clientX - rect.left) / rect.width;
    const y = (event.clientY - rect.top) / rect.height;
    tiltY.value = (x - 0.5) * 16;
    tiltX.value = (0.5 - y) * 12;
    pointerActive.value = true;
};

const handleTouchMove = (event) => {
    if (!event.touches?.length) return;
    const touch = event.touches[0];
    handlePointerMove({
        currentTarget: event.currentTarget,
        clientX: touch.clientX,
        clientY: touch.clientY,
    });
};

const handlePointerLeave = () => {
    pointerActive.value = false;
    tiltX.value = 0;
    tiltY.value = 0;
};

const volumeSummary = computed(() => {
    const capacityCm3 = capacityFromProps.value;
    const actualCm3 = Number(props.volume?.actual ?? 0);
    const reservedCm3 = Number(props.volume?.reserved ?? 0);
    const projectedCm3 = Number(props.volume?.projected ?? 0);
    const effectiveCm3 = Number(props.volume?.effective ?? props.volume?.current ?? actualCm3 + reservedCm3 + projectedCm3);
    const usedCm3 = Math.max(effectiveCm3, actualCm3 + reservedCm3);
    const remainingCm3 = props.volume?.remaining != null
        ? Number(props.volume.remaining)
        : capacityCm3 != null
            ? Math.max(capacityCm3 - usedCm3, 0)
            : null;

    if (capacityCm3 == null && usedCm3 <= 0) {
        return '';
    }

    const usedText = `${toLiters(Math.max(usedCm3, 0))} (${formatCm3(Math.max(usedCm3, 0))})`;

    if (capacityCm3 != null) {
        const capacityText = `${toLiters(capacityCm3)} (${formatCm3(capacityCm3)})`;
        const remainingText =
            remainingCm3 != null ? ` • ${toLiters(Math.max(remainingCm3, 0))} livres` : '';
        return `Volume: ${usedText} / ${capacityText}${remainingText}`;
    }

    return `Volume: ${usedText}`;
});
</script>

<style scoped>
.suitcase-3d {
    position: relative;
    perspective: 1400px;
    width: min(10rem, 100%);
}
.suitcase-3d__body {
    --suit-depth: 18px;
    width: 7rem;
    height: 10rem;
    transform-style: preserve-3d;
    animation: suitcaseSpin 12s ease-in-out infinite;
}
.suitcase-3d__body--active {
    animation: none;
    transition: transform 0.2s ease;
}
.suitcase-3d__body--locked {
    animation-duration: 16s;
}
.suitcase-3d__face {
    position: absolute;
    inset: 0;
    border-radius: 16px;
    transform-style: preserve-3d;
}
.suitcase-3d__face--front {
    background: linear-gradient(140deg, #fef3c7, #fde68a);
    transform: translateZ(calc(var(--suit-depth) / 2));
}
.suitcase-3d__face--back {
    background: linear-gradient(140deg, #fdba74, #fb923c);
    transform: translateZ(calc(var(--suit-depth) * -0.5)) rotateY(180deg);
}
.suitcase-3d__side {
    position: absolute;
    background: linear-gradient(180deg, #fb923c, #f97316);
    opacity: 0.8;
}
.suitcase-3d__side--left,
.suitcase-3d__side--right {
    top: 0;
    bottom: 0;
    width: var(--suit-depth);
}
.suitcase-3d__side--left {
    left: 0;
    transform-origin: left;
    transform: rotateY(90deg) translateZ(calc(var(--suit-depth) / 2 * -1));
}
.suitcase-3d__side--right {
    right: 0;
    transform-origin: right;
    transform: rotateY(-90deg) translateZ(calc(var(--suit-depth) / 2 * -1));
}
.suitcase-3d__side--top,
.suitcase-3d__side--bottom {
    left: 0;
    right: 0;
    height: var(--suit-depth);
}
.suitcase-3d__side--top {
    top: 0;
    transform-origin: top;
    transform: rotateX(-90deg) translateZ(calc(var(--suit-depth) / 2));
}
.suitcase-3d__side--bottom {
    bottom: 0;
    transform-origin: bottom;
    transform: rotateX(90deg) translateZ(calc(var(--suit-depth) / 2));
}
.suitcase-3d__shadow {
    position: absolute;
    inset: auto 0 -8px 0;
    margin: 0 auto;
    width: 60%;
    height: 14px;
    border-radius: 50%;
    background: radial-gradient(circle, rgba(15, 23, 42, 0.25), transparent 70%);
    filter: blur(8px);
    opacity: 0.6;
    animation: suitcaseShadow 12s ease-in-out infinite;
}
@keyframes suitcaseSpin {
    0% {
        transform: rotateY(-6deg) translateY(0);
    }
    25% {
        transform: rotateY(3deg) translateY(-3px);
    }
    50% {
        transform: rotateY(6deg) translateY(-6px);
    }
    75% {
        transform: rotateY(-3deg) translateY(-3px);
    }
    100% {
        transform: rotateY(-6deg) translateY(0);
    }
}
@keyframes suitcaseShadow {
    0%,
    100% {
        transform: scaleX(1);
        opacity: 0.55;
    }
    50% {
        transform: scaleX(0.9);
        opacity: 0.4;
    }
}
@media (prefers-reduced-motion: reduce) {
    .suitcase-3d__body,
    .suitcase-3d__shadow {
        animation: none;
    }
}
</style>
