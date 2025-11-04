<template>
    <div class="space-y-5 rounded-3xl bg-white/80 p-6 shadow-lg/20 shadow-slate-200 ring-1 ring-black/5 backdrop-blur-sm">
        <div class="flex items-center justify-between text-sm font-medium text-slate-600">
            <span>Peso total disponível</span>
            <span class="text-slate-900 font-semibold">{{ formatKg(totalAvailableKg) }}</span>
        </div>

        <div class="h-3 w-full overflow-hidden rounded-full bg-slate-200">
            <div
                v-for="segment in segments"
                :key="segment.key"
                :class="[segment.class, 'h-full transition-all duration-500 ease-out']"
                :style="{ width: `${segment.percentage}%` }"
            />
        </div>

        <div class="grid gap-4 text-sm text-slate-600 sm:grid-cols-2">
            <div
                v-for="bag in normalizedBags"
                :key="bag.key"
                class="rounded-2xl border border-slate-200/70 bg-white/70 px-3 py-3 shadow-inner shadow-slate-100"
            >
                <p class="text-xs font-semibold uppercase tracking-wide text-slate-500">
                    {{ bag.label }}
                </p>
                <p class="text-base font-semibold text-slate-900">{{ formatKg(bag.displayUsed) }}</p>
                <p class="text-xs text-slate-500">
                    de {{ formatKg(bag.capacity) }}
                    <span v-if="bag.reserved > 0.01">
                        (inclui {{ formatKg(bag.reserved) }} reservado)
                    </span>
                </p>
                <p class="text-xs text-slate-500">{{ formatKg(Math.max(bag.remaining, 0)) }} livres</p>
            </div>

            <div class="rounded-2xl border border-slate-200/70 bg-white/70 px-3 py-3 shadow-inner shadow-slate-100">
                <p class="text-xs font-semibold uppercase tracking-wide text-slate-500">Reservado</p>
                <p class="text-base font-semibold text-slate-900">{{ formatKg(reservedKgNumber) }}</p>
                <p class="text-xs text-slate-500">pesos separados</p>
            </div>

            <div class="rounded-2xl border border-slate-200/70 bg-white/70 px-3 py-3 shadow-inner shadow-slate-100">
                <p class="text-xs font-semibold uppercase tracking-wide text-slate-500">Restante</p>
                <p :class="remainingClass">{{ formatKg(remainingKg) }}</p>
                <p class="text-xs text-slate-500">capacidade livre</p>
            </div>
        </div>

    </div>
</template>

<script setup>
import { computed } from 'vue';

const colorPalette = ['bg-amber-400', 'bg-emerald-400', 'bg-sky-400', 'bg-rose-400', 'bg-indigo-400'];

const props = defineProps({
    bags: {
        type: Array,
        default: () => [],
    },
    reservedKg: {
        type: Number,
        default: 0,
    },
    totalCapacityKg: {
        type: Number,
        default: 0,
    },
    yesWeightKg: {
        type: Number,
        default: 0,
    },
});

const formatKg = (value) => `${Number(value).toFixed(1)} kg`;
const clamp = (value) => Math.max(0, Math.min(100, value));

const normalizedBags = computed(() => {
    if (!Array.isArray(props.bags)) return [];
    return props.bags.map((bag, index) => {
        const capacity = Number(bag.capacity_kg ?? bag.capacity ?? 0) || 0;
        const hasProjected = bag.usedWithProjection != null;
        const actualUsed = hasProjected
            ? Number(bag.used ?? bag.yes_kg ?? bag.total_kg ?? 0) || 0
            : Number(bag.yes_kg ?? bag.total_kg ?? bag.used ?? 0) || 0;
        const reserved = Number(bag.reservedAppliedKg ?? bag.reserved_kg ?? 0) || 0;
        const effectiveUsed = hasProjected
            ? Number(bag.usedWithProjection ?? 0)
            : actualUsed + reserved;
        const remaining =
            bag.remaining_kg != null ? Number(bag.remaining_kg) : Math.max(capacity - effectiveUsed, 0);
        return {
            key: bag.id ?? `bag-${index}`,
            label: bag.name || `Mala ${index + 1}`,
            capacity,
            used: effectiveUsed,
            actualUsed,
            reserved,
            displayUsed: effectiveUsed,
            remaining,
            color: colorPalette[index % colorPalette.length],
        };
    });
});

const totalCapacity = computed(() => {
    if (props.totalCapacityKg) return props.totalCapacityKg;
    return normalizedBags.value.reduce((sum, bag) => sum + bag.capacity, 0);
});

const reservedKgNumber = computed(() => Number(props.reservedKg) || 0);

const actualUsedKg = computed(() => {
    if (props.yesWeightKg) return props.yesWeightKg;
    return normalizedBags.value.reduce((sum, bag) => sum + (bag.actualUsed ?? 0), 0);
});

const usedKg = computed(() => actualUsedKg.value + reservedKgNumber.value);

const remainingKg = computed(() => Math.max(totalCapacity.value - usedKg.value, 0));
const totalAvailableKg = computed(() => totalCapacity.value);

const weightTotals = computed(() => ({
    capacity: totalCapacity.value,
    reserved: reservedKgNumber.value,
    used: usedKg.value,
    remaining: remainingKg.value,
}));

const safeTotal = computed(() => Math.max(totalCapacity.value, 0.0001));

const segments = computed(() => {
    const bagSegments = normalizedBags.value.map((bag) => ({
        key: `bag-${bag.key}`,
        class: bag.color,
        percentage: clamp(((bag.used ?? 0) / safeTotal.value) * 100),
    }));

    const reservedPercentage = clamp((reservedKgNumber.value / safeTotal.value) * 100);
    const remainingPercentage = clamp((remainingKg.value / safeTotal.value) * 100);

    const extraSegments = [];
    if (reservedPercentage > 0) {
        extraSegments.push({ key: 'reserved', class: 'bg-sky-300', percentage: reservedPercentage });
    }
    if (remainingPercentage > 0) {
        extraSegments.push({ key: 'remaining', class: 'bg-slate-200', percentage: remainingPercentage });
    }

    return [...bagSegments, ...extraSegments];
});

const remainingClass = computed(() =>
    remainingKg.value <= 3 ? 'text-rose-500 font-semibold text-base' : 'text-slate-900 font-semibold text-base',
);
</script>
