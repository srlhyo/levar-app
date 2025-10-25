<template>
    <div class="rounded-3xl bg-white/80 p-6 shadow-lg/20 shadow-slate-200 ring-1 ring-black/5 backdrop-blur-sm space-y-5">
        <div class="flex items-center justify-between text-sm text-slate-600 font-medium">
            <span>Peso total disponível</span>
            <span class="text-slate-900 font-semibold">{{ formattedTotal }}</span>
        </div>

        <div class="h-3 w-full overflow-hidden rounded-full bg-slate-200">
            <div
                v-for="segment in segments"
                :key="segment.key"
                :class="[segment.class, 'h-full transition-all duration-500 ease-out']"
                :style="{ width: `${segment.percentage}%` }"
            />
        </div>

        <div class="grid grid-cols-2 gap-4 text-sm text-slate-600">
            <div class="space-y-1">
                <p class="uppercase tracking-wide text-xs">Mala A</p>
                <p class="text-base font-semibold text-slate-900">{{ formatKg(bagAUsed) }}</p>
                <p class="text-xs">de {{ formatKg(capacityPerBag) }}</p>
            </div>
            <div class="space-y-1">
                <p class="uppercase tracking-wide text-xs">Mala B</p>
                <p class="text-base font-semibold text-slate-900">{{ formatKg(bagBUsed) }}</p>
                <p class="text-xs">de {{ formatKg(capacityPerBag) }}</p>
            </div>
            <div class="space-y-1">
                <p class="uppercase tracking-wide text-xs">Reservado</p>
                <p class="text-base font-semibold text-slate-900">{{ formatKg(reservedKg) }}</p>
                <p class="text-xs">pesos separados</p>
            </div>
            <div class="space-y-1">
                <p class="uppercase tracking-wide text-xs">Restante</p>
                <p :class="remainingClass">{{ formatKg(remainingKg) }}</p>
                <p class="text-xs">ainda livre</p>
            </div>
        </div>
    </div>
</template>

<script setup>
import { computed } from 'vue';

const props = defineProps({
    totalKg: {
        type: Number,
        default: 46,
    },
    bagAUsed: {
        type: Number,
        default: 0,
    },
    bagBUsed: {
        type: Number,
        default: 0,
    },
    reservedKg: {
        type: Number,
        default: 0,
    },
});

const safeTotal = computed(() => Math.max(props.totalKg, 0.0001));
const capacityPerBag = computed(() => props.totalKg / 2);

const clamp = (value) => Math.max(0, Math.min(100, value));

const bagAPercentage = computed(() => clamp((props.bagAUsed / safeTotal.value) * 100));
const bagBPercentage = computed(() => clamp((props.bagBUsed / safeTotal.value) * 100));
const reservedPercentage = computed(() => clamp((props.reservedKg / safeTotal.value) * 100));

const remainingKg = computed(() => Math.max(props.totalKg - (props.bagAUsed + props.bagBUsed + props.reservedKg), 0));
const remainingPercentage = computed(() => clamp((remainingKg.value / safeTotal.value) * 100));

const segments = computed(() => [
    { key: 'bagA', percentage: bagAPercentage.value, class: 'bg-amber-400' },
    { key: 'bagB', percentage: bagBPercentage.value, class: 'bg-emerald-400' },
    { key: 'reserved', percentage: reservedPercentage.value, class: 'bg-sky-300' },
    { key: 'remaining', percentage: remainingPercentage.value, class: 'bg-slate-200' },
]);

const formattedTotal = computed(() => `${props.totalKg.toFixed(1)} kg`);

const formatKg = (value) => `${value.toFixed(1)} kg`;

const remainingClass = computed(() =>
    remainingKg.value <= 3 ? 'text-rose-500 font-semibold text-base' : 'text-slate-900 font-semibold text-base',
);
</script>
