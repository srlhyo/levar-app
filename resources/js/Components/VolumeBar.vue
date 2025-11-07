<template>
    <div class="space-y-5 rounded-3xl bg-white/80 p-6 shadow-lg/20 shadow-slate-200 ring-1 ring-black/5 backdrop-blur-sm">
        <div class="flex items-center justify-between text-sm font-medium text-slate-600">
            <span>Volume total disponível</span>
            <span class="text-slate-900 font-semibold">{{ formatVolume(totalAvailableLiters, true) }}</span>
        </div>

        <div class="flex h-3 w-full overflow-hidden rounded-full bg-slate-200">
            <div
                v-for="segment in segments"
                :key="segment.key"
                :class="[segment.class, 'h-full flex-none transition-all duration-500 ease-out']"
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
                <p class="text-base font-semibold text-slate-900">{{ formatVolume(bag.usedLiters) }}</p>
                <p class="text-xs text-slate-500">
                    de {{ formatVolume(bag.capacityLiters) }}
                    <span v-if="bag.reservedLiters > 0.01">
                        (inclui {{ formatVolume(bag.reservedLiters) }} reservado)
                    </span>
                </p>
                <p class="text-xs text-slate-500">{{ formatVolume(Math.max(bag.remainingLiters, 0)) }} livres</p>
            </div>

            <div class="rounded-2xl border border-slate-200/70 bg-white/70 px-3 py-3 shadow-inner shadow-slate-100">
                <p class="text-xs font-semibold uppercase tracking-wide text-slate-500">Reservado</p>
                <p class="text-base font-semibold text-slate-900">{{ formatVolume(reservedLiters, true) }}</p>
                <p class="text-xs text-slate-500">volume alocado previamente</p>
            </div>

            <div class="rounded-2xl border border-slate-200/70 bg-white/70 px-3 py-3 shadow-inner shadow-slate-100">
                <p class="text-xs font-semibold uppercase tracking-wide text-slate-500">Restante</p>
                <p :class="remainingClass">{{ formatVolume(remainingLiters, true) }}</p>
                <p class="text-xs text-slate-500">espaço livre</p>
            </div>
        </div>
    </div>
</template>

<script setup>
import { computed } from 'vue';

const colorPalette = ['bg-sky-400', 'bg-emerald-400', 'bg-amber-400', 'bg-rose-400', 'bg-indigo-400'];
const literFormatter = new Intl.NumberFormat('pt-BR', { minimumFractionDigits: 1, maximumFractionDigits: 1 });
const formatNumber = (value) => new Intl.NumberFormat('pt-BR').format(Math.round(value));
const clamp = (value) => Math.max(0, Math.min(100, value));

const props = defineProps({
    bags: {
        type: Array,
        default: () => [],
    },
    totalCapacityCm3: {
        type: Number,
        default: 0,
    },
    usedCm3: {
        type: Number,
        default: 0,
    },
    reservedCm3: {
        type: Number,
        default: 0,
    },
});

const cm3ToLiters = (value) => (Number(value) || 0) / 1000;

const normalizedBags = computed(() => {
    if (!Array.isArray(props.bags)) return [];
    return props.bags.map((bag, index) => {
        const capacityCm3 =
            Number(
                bag.capacityVolumeCm3 ??
                    bag.capacity_volume_cm3 ??
                    bag.capacityVolume ??
                    bag.capacity_volume ??
                    0,
            ) || 0;
        const reservedAppliedCm3 =
            Number(
                bag.reservedVolumeAppliedCm3 ??
                    bag.reserved_volume_cm3 ??
                    bag.reservedVolumeCm3 ??
                    bag.reserved_volume_applied_cm3 ??
                    0,
            ) || 0;

        const projectedCm3 = Number(bag.projectedVolumeCm3 ?? bag.projected_volume_cm3 ?? 0);
        const actualCm3 = Number(bag.volumeCm3 ?? bag.volume_cm3 ?? 0);

        const effectiveCm3Raw =
            bag.volumeWithProjectionCm3 ?? bag.effectiveVolumeCm3 ?? bag.effective_volume_cm3;
        const effectiveCm3 =
            effectiveCm3Raw != null && !Number.isNaN(Number(effectiveCm3Raw))
                ? Number(effectiveCm3Raw)
                : actualCm3 + projectedCm3 + reservedAppliedCm3;

        const actualUsedCm3 = actualCm3 + projectedCm3;

        const remainingCm3 =
            bag.remainingVolumeCm3 != null
                ? Number(bag.remainingVolumeCm3)
                : capacityCm3 > 0
                    ? Math.max(capacityCm3 - effectiveCm3, 0)
                    : 0;

        const capacityLiters = cm3ToLiters(capacityCm3);
        const usedLiters = cm3ToLiters(effectiveCm3);
        const reservedLiters = cm3ToLiters(reservedAppliedCm3);
        const remainingLiters = cm3ToLiters(remainingCm3);

        return {
            key: bag.id ?? `bag-${index}`,
            label: bag.name || `Mala ${index + 1}`,
            capacityLiters,
            usedLiters,
            reservedLiters,
            remainingLiters,
            color: colorPalette[index % colorPalette.length],
        };
    });
});

const totalCapacityCm3 = computed(() => {
    if (props.totalCapacityCm3) return props.totalCapacityCm3;
    return normalizedBags.value.reduce((sum, bag) => sum + bag.capacityLiters * 1000, 0);
});

const reservedCm3 = computed(() => {
    if (props.reservedCm3) return props.reservedCm3;
    return normalizedBags.value.reduce((sum, bag) => sum + bag.reservedLiters * 1000, 0);
});

const usedCm3 = computed(() => {
    if (props.usedCm3) return props.usedCm3;
    return normalizedBags.value.reduce((sum, bag) => sum + bag.usedLiters * 1000, 0);
});

const totalAvailableLiters = computed(() => cm3ToLiters(totalCapacityCm3.value));
const reservedLiters = computed(() => cm3ToLiters(reservedCm3.value));
const usedLiters = computed(() => cm3ToLiters(usedCm3.value));

const remainingLiters = computed(() => Math.max(totalAvailableLiters.value - usedLiters.value, 0));

const safeTotal = computed(() => Math.max(totalAvailableLiters.value, 0.0001));

const segments = computed(() => {
const bagSegments = normalizedBags.value.map((bag) => ({
    key: `bag-${bag.key}`,
    class: bag.color,
    percentage: clamp(((bag.usedLiters ?? 0) / safeTotal.value) * 100),
}));

const remainingPercentage = clamp(((remainingLiters.value || 0) / safeTotal.value) * 100);
const trailingSegments = [];
if (remainingPercentage > 0) {
    trailingSegments.push({ key: 'remaining', class: 'bg-slate-200', percentage: remainingPercentage });
}

return [...bagSegments, ...trailingSegments];
});

const formatVolume = (value, withCm3 = false) => {
    const liters = Number(value) || 0;
    const result = `${literFormatter.format(liters)} L`;
    if (!withCm3) return result;
    return `${result} (${formatNumber(liters * 1000)} cm³)`;
};

const remainingClass = computed(() =>
    remainingLiters.value <= 3 ? 'text-rose-500 font-semibold text-base' : 'text-slate-900 font-semibold text-base',
);
</script>
