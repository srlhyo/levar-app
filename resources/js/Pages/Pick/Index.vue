<template>
    <Head title="Embalar" />
    <AppLayout>
        <template #title>Embalar</template>
        <template #subtitle>Distribua os itens nas malas A e B e marque o que já está pronto.</template>

        <Card tone="slate" class="space-y-5">
            <div class="flex flex-wrap items-center justify-between gap-3">
                <div>
                    <p class="text-base font-semibold text-slate-900">Resumo das malas</p>
                    <p class="text-sm text-slate-600">
                        Embale cada mala com cuidado. Quando o peso ou volume chegar em 100%, ela trava automaticamente.
                    </p>
                </div>
                <button
                    type="button"
                    class="inline-flex items-center gap-2 rounded-full bg-white/80 px-3 py-1 text-xs font-semibold text-slate-700 ring-1 ring-black/5 transition hover:bg-white focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-400"
                    @click="showLegend = !showLegend"
                    aria-expanded="showLegend ? 'true' : 'false'"
                >
                    <span class="inline-flex h-5 w-5 items-center justify-center rounded-full bg-slate-100 text-[11px] font-semibold text-slate-500">?</span>
                    Como funciona
                </button>
            </div>
            <transition name="fade">
                <div
                    v-if="showLegend"
                    class="space-y-2 rounded-2xl bg-white/80 px-4 py-3 text-xs text-slate-600 ring-1 ring-black/5 sm:text-sm"
                >
                    <p class="font-semibold text-slate-800">Dicas rápidas</p>
                    <ul class="list-disc space-y-1 pl-5">
                        <li>O preenchimento amarelo mostra quanto da mala já está ocupado.</li>
                        <li>Se ficar vermelho ou aparecer cadeado, a mala ultrapassou peso ou volume — mova itens para outra.</li>
                        <li>Use os botões “Mala A/B” abaixo de cada item para alternar rapidamente.</li>
                    </ul>
                </div>
            </transition>
            <div
                class="grid gap-3 rounded-2xl bg-white/80 px-4 py-3 text-xs text-slate-600 ring-1 ring-black/5 sm:grid-cols-3 sm:text-sm"
            >
                <div class="flex items-center gap-3">
                    <span class="grid h-8 w-8 place-items-center rounded-full bg-emerald-100 text-emerald-600">⚖️</span>
                    <div class="space-y-0.5">
                        <p class="text-xs font-semibold uppercase tracking-wide text-slate-500 sm:text-[0.7rem]">
                            Peso carregado
                        </p>
                        <p class="text-sm font-semibold text-slate-800">
                            {{ formatKg(packUsedWeightKg) }} / {{ formatKg(packTotalCapacityKg) }}
                        </p>
                        <p class="text-[11px] text-slate-500 sm:text-xs">
                            {{ formatKg(packRemainingWeightKg) }} livres • {{ formatKg(packReservedKg) }} reservado
                        </p>
                    </div>
                </div>
                <div class="flex items-center gap-3">
                    <span class="grid h-8 w-8 place-items-center rounded-full bg-sky-100 text-sky-600">🧊</span>
                    <div class="space-y-0.5">
                        <p class="text-xs font-semibold uppercase tracking-wide text-slate-500 sm:text-[0.7rem]">
                            Volume ocupado
                        </p>
                        <p class="text-sm font-semibold text-slate-800">
                            {{ formatLiters(packUsedVolumeCm3) }} / {{ formatLiters(packTotalVolumeCm3) }}
                        </p>
                        <p class="text-[11px] text-slate-500 sm:text-xs">
                            {{ formatLiters(packRemainingVolumeCm3) }} livres • {{ formatLiters(packReservedVolumeCm3) }} reservado
                        </p>
                    </div>
                </div>
                <div class="flex items-center gap-3">
                    <span
                        class="grid h-8 w-8 place-items-center rounded-full"
                        :class="lockedBagsCount ? 'bg-rose-100 text-rose-600' : 'bg-emerald-100 text-emerald-600'"
                    >
                        🧳
                    </span>
                    <div class="space-y-0.5">
                        <p class="text-xs font-semibold uppercase tracking-wide text-slate-500 sm:text-[0.7rem]">
                            Status das malas
                        </p>
                        <p class="text-sm font-semibold" :class="lockedBagsCount ? 'text-rose-600' : 'text-slate-800'">
                            {{ lockedBagsCount }} bloqueada(s) • {{ totalBagsCount }} no total
                        </p>
                        <p class="text-[11px] text-slate-500 sm:text-xs">
                            {{ packedCount }} itens embalados de {{ packItems.length }}
                        </p>
                    </div>
                </div>
            </div>
            <WeightBar
                :bags="rawPackBags"
                :reserved-kg="packReservedKg"
                :total-capacity-kg="packTotalCapacityKg"
                :yes-weight-kg="packUsedWeightKg"
            />
            <VolumeBar
                :bags="rawPackBags"
                :reserved-cm3="packReservedVolumeCm3"
                :total-capacity-cm3="packTotalVolumeCm3"
                :used-cm3="packUsedVolumeCm3"
            />
            <div class="grid gap-4 md:grid-cols-2">
                <Suitcase
                    v-for="bag in suitcaseSummaries"
                    :key="bag.id"
                    :name="bag.name"
                    :dims="bag.dims"
                    :current="bag.current"
                    :max="bag.max"
                    :status="bag.status"
                    :ratio="bag.ratio"
                    :weight="bag.weight"
                    :volume="bag.volume"
                />
            </div>
        </Card>

        <div
            v-if="allPackedBanner && packItems.length"
            class="mt-4 flex items-start gap-3 rounded-2xl bg-green-50 p-4 text-green-800 shadow-sm ring-1 ring-green-200"
        >
            <span class="text-2xl">🎉</span>
            <div>
                <p class="text-base font-semibold">Tudo embalado!</p>
                <p class="text-sm">Você pode revisar no Resumo para ajustar as malas finalizadas.</p>
            </div>
        </div>

        <Card tone="yellow" class="space-y-4">
            <template v-if="packItems.length">
        <div
            class="sticky top-16 z-10 flex flex-wrap items-center justify-between gap-2 rounded-xl bg-white/90 p-3 text-sm text-slate-600 shadow ring-1 ring-black/5 backdrop-blur"
        >
            <span class="font-semibold text-slate-700">
                Embalados: {{ packedCount }} / {{ packItems.length }}
            </span>
            <button
                v-if="hasPacked"
                type="button"
                class="inline-flex items-center gap-2 rounded-full border border-amber-200 px-4 py-2 text-xs font-semibold text-amber-700 transition hover:bg-amber-100 sm:text-sm"
                @click="markAllPacked(false)"
                aria-label="Desmarcar todos os itens embalados"
            >
                Desmarcar todos
            </button>
        </div>

        <div class="flex items-start gap-2 rounded-2xl bg-white/70 px-3 py-2 text-xs text-slate-600 ring-1 ring-black/5 sm:text-sm">
            <Package class="mt-[2px] h-4 w-4 text-amber-500" />
            <p>
                Toque no item para saber onde está, alterne entre malas A/B com os botões ou marque como embalado quando estiver pronto. Use “Detalhes” para relembrar peso e volume rapidamente.
            </p>
        </div>

        <div
            class="flex flex-wrap items-center gap-3 rounded-2xl bg-white/70 px-3 py-3 text-xs text-slate-600 ring-1 ring-black/5 sm:text-sm"
        >
            <div class="relative flex-1 min-w-[200px] sm:min-w-[260px]">
                <input
                    v-model="searchQuery"
                    type="search"
                    placeholder="Buscar por nome ou notas…"
                    class="w-full rounded-full border border-slate-200 bg-white/90 px-3 py-2 text-sm text-slate-700 shadow-inner shadow-slate-100 focus:border-emerald-400 focus:outline-none focus:ring-2 focus:ring-emerald-200"
                />
                <span
                    v-if="searchQuery"
                    class="pointer-events-none absolute inset-y-0 right-3 flex items-center text-[11px] font-medium text-slate-400"
                >
                    {{ filteredPackItems.length }} resultado(s)
                </span>
            </div>
            <div class="flex flex-wrap items-center gap-2">
                <button
                    v-for="option in filterOptions"
                    :key="option.value"
                    type="button"
                    class="rounded-full border px-3 py-1 text-xs font-semibold transition sm:text-sm"
                    :class="[
                        activeFilter === option.value
                            ? 'border-emerald-300 bg-emerald-500 text-white shadow'
                            : 'border-slate-200 bg-white/80 text-slate-600 hover:bg-white',
                    ]"
                    @click="setActiveFilter(option.value)"
                >
                    {{ option.label }}
                </button>
            </div>
        </div>

        <div
            v-if="filteredPackItems.length"
            ref="listContainer"
            class="max-h-[65vh] space-y-4 overflow-y-auto pr-1"
        >
            <div
                v-for="item in filteredPackItems"
                :key="item.id"
                class="flex flex-col gap-4 rounded-2xl bg-white/70 p-4 ring-1 ring-white/40 sm:flex-row sm:items-center sm:justify-between"
            >
                    <div class="flex flex-1 items-start gap-3">
                        <div
                            class="flex h-16 w-16 flex-shrink-0 items-center justify-center overflow-hidden rounded-2xl bg-amber-100/60"
                        >
                            <img
                                v-if="hasPhoto(item)"
                                :src="itemPhoto(item)"
                                :alt="item.title ?? item.name"
                                class="max-h-full max-w-full object-contain"
                                loading="lazy"
                                decoding="async"
                                @error="() => markPhotoFailed(item)"
                            />
                            <Package v-else class="h-7 w-7 text-amber-500/60" />
                        </div>
                        <div class="space-y-1">
                            <p class="text-base font-semibold text-slate-900 sm:text-lg">{{ item.title ?? item.name }}</p>
                            <p v-if="item.notes" class="text-sm text-slate-600">{{ item.notes }}</p>
                            <p class="text-xs text-slate-500">{{ (item.weight ?? 0).toFixed(1) }} kg</p>
                            <p v-if="formatVolume(item)" class="text-xs text-slate-500">Volume: {{ formatVolume(item) }}</p>
                        </div>
                    </div>

                    <div class="flex flex-col gap-3 sm:items-end">
                        <div class="inline-flex items-center gap-2 rounded-full bg-white/70 p-1 ring-1 ring-black/5">
                            <button
                                type="button"
                                class="rounded-full px-4 py-1 text-xs font-semibold transition sm:text-sm"
                                :class="[
                                    item.bag === 'A' ? 'bg-amber-400 text-slate-900 shadow' : 'text-slate-600 hover:bg-white',
                                    isBagLocked('A') ? 'cursor-not-allowed opacity-60 hover:bg-transparent' : '',
                                ]"
                                :disabled="isBagLocked('A')"
                                :title="isBagLocked('A') ? bagLockMessage('A') : 'Enviar para a mala A'"
                                @click="assignBag(item, 'A')"
                            >
                                Mala A
                            </button>
                            <button
                                type="button"
                                class="rounded-full px-4 py-1 text-xs font-semibold transition sm:text-sm"
                                :class="[
                                    item.bag === 'B' ? 'bg-amber-400 text-slate-900 shadow' : 'text-slate-600 hover:bg-white',
                                    isBagLocked('B') ? 'cursor-not-allowed opacity-60 hover:bg-transparent' : '',
                                ]"
                                :disabled="isBagLocked('B')"
                                :title="isBagLocked('B') ? bagLockMessage('B') : 'Enviar para a mala B'"
                                @click="assignBag(item, 'B')"
                            >
                                Mala B
                            </button>
                        </div>

                        <div class="flex items-center gap-2">
                            <label class="inline-flex items-center gap-2 rounded-full bg-white/80 px-3 py-1 text-sm font-medium text-slate-600 ring-1 ring-black/5">
                                <input
                                    type="checkbox"
                                    class="h-4 w-4 rounded border-slate-300 text-amber-500 focus:ring-amber-300"
                                    :checked="item.packed"
                                    @change="onPackedChange(item, $event.target.checked)"
                                    :aria-label="`Marcar ${item.title ?? item.name} como embalado`"
                                />
                                Embalado
                            </label>
                            <button
                                type="button"
                                class="inline-flex items-center justify-center rounded-full bg-amber-500/15 px-2 py-1 text-xs font-semibold uppercase tracking-wide text-amber-600 ring-1 ring-amber-300 transition hover:bg-amber-500/25 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-amber-400"
                                @click="openItemHelp(item)"
                            >
                                Detalhes
                            </button>
                        </div>
                    </div>
            </div>
        </div>

        <div
            v-else
            class="rounded-2xl border border-dashed border-slate-300/70 bg-white/60 p-8 text-center text-sm text-slate-500 sm:text-base"
        >
            Nenhum item encontrado para a busca atual. Ajuste os filtros para visualizar novamente.
        </div>
        </template>
        <div v-else class="py-10 text-center text-sm text-slate-600">
            Nenhum item aguardando embalagem por enquanto.
        </div>
        </Card>

    </AppLayout>
</template>

<script setup>
import { Head, usePage } from '@inertiajs/vue3';
import { computed, inject, nextTick, onBeforeUnmount, onMounted, reactive, ref, watch, watchEffect } from 'vue';
import { Package } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import Card from '@/Components/Card.vue';
import Suitcase from '@/Components/Suitcase.vue';
import WeightBar from '@/Components/WeightBar.vue';
import VolumeBar from '@/Components/VolumeBar.vue';
import { useDecisionStore } from '@/stores/decision';
import { toast } from '@/utils/toast';

const decisionStore = useDecisionStore();
const page = usePage();
const numberFormatter = new Intl.NumberFormat('pt-BR');

const formatKg = (value) => `${Number(value ?? 0).toFixed(1)} kg`;
const formatLiters = (value) => `${(Number(value ?? 0) / 1000).toFixed(1)} L`;

const move = computed(() => page.props.move ?? null);

watchEffect(() => {
    decisionStore.setMove(move.value);
});

const listContainer = ref(null);
const registerScrollTarget = inject('registerScrollTarget', null);
let unregisterScrollTarget = null;

onMounted(async () => {
    if (move.value?.id) {
        try {
            await Promise.all([decisionStore.fetchPack(), decisionStore.fetchResumo()]);
        } catch (error) {
            console.error(error);
        }
    }

    if (registerScrollTarget) {
        unregisterScrollTarget = registerScrollTarget(listContainer);
    }
});

onBeforeUnmount(() => {
    unregisterScrollTarget?.();
});

const packItems = computed(() => decisionStore.pack.items ?? []);
const rawPackBags = computed(() => decisionStore.pack.bags ?? []);
const packTotals = computed(() => decisionStore.pack.totals ?? {});
const failedImages = reactive(new Set());
const showLegend = ref(false);

const searchQuery = ref('');
const activeFilter = ref('all');
const filterOptions = Object.freeze([
    { value: 'all', label: 'Todos' },
    { value: 'bag-A', label: 'Mala A' },
    { value: 'bag-B', label: 'Mala B' },
    { value: 'unassigned', label: 'Sem mala' },
    { value: 'packed', label: 'Embalados' },
    { value: 'unpacked', label: 'Pendentes' },
]);

const normalize = (value) =>
    (value ?? '')
        .toString()
        .toLowerCase()
        .normalize('NFD')
        .replace(/[\u0300-\u036f]/g, '');

const matchesFilter = (item, filter) => {
    const bagCode = (item?.bag ?? item?.bag_code ?? '').toString().toUpperCase();
    switch (filter) {
        case 'bag-A':
            return bagCode === 'A';
        case 'bag-B':
            return bagCode === 'B';
        case 'unassigned':
            return !bagCode;
        case 'packed':
            return Boolean(item?.packed);
        case 'unpacked':
            return !item?.packed;
        default:
            return true;
    }
};

const matchesQuery = (item, query) => {
    if (!query) return true;
    const haystack = normalize(
        `${item?.title ?? item?.name ?? ''} ${item?.notes ?? ''} ${item?.category ?? ''} ${item?.section ?? ''}`,
    );
    return haystack.includes(query);
};

const filteredPackItems = computed(() => {
    const filter = activeFilter.value;
    const query = normalize(searchQuery.value);
    return packItems.value.filter((item) => matchesFilter(item, filter) && matchesQuery(item, query));
});

const scrollListToTop = () => {
    if (!listContainer.value) return;
    listContainer.value.scrollTo({ top: 0, behavior: 'smooth' });
};

const setActiveFilter = (value) => {
    if (activeFilter.value === value) return;
    activeFilter.value = value;
    nextTick(() => scrollListToTop());
};

watch(searchQuery, () => {
    nextTick(() => scrollListToTop());
});

const itemPhoto = (item) => {
    const source =
        item?.photo?.trim?.() ||
        item?.thumbnail_url?.trim?.() ||
        item?.photo_url?.trim?.() ||
        null;
    if (!source) return null;
    if (failedImages.has(item.id)) return null;
    return source;
};

const hasPhoto = (item) => Boolean(itemPhoto(item));

const markPhotoFailed = (item) => {
    if (!item?.id) return;
    failedImages.add(item.id);
};

const bagLockMap = computed(() => {
    const map = {};
    rawPackBags.value.forEach((bag) => {
        const code = String(bag.code ?? bag.id ?? '');
        const weightRatio = Number(bag.weight_ratio ?? bag.weightRatio ?? 0);
        const volumeRatio = Number(bag.volume_ratio ?? bag.volumeRatio ?? 0);
        const lockedByWeight = Boolean(bag.locked_by_weight ?? bag.lockedByWeight) || weightRatio >= 1;
        const lockedByVolume = Boolean(bag.locked_by_volume ?? bag.lockedByVolume) || volumeRatio >= 1;
        const lockedFlag = bag.locked ?? (lockedByWeight || lockedByVolume);
        const locked = Boolean(lockedFlag);
        map[code] = {
            locked,
            lockedByWeight,
            lockedByVolume,
        };
    });
    return map;
});

const isBagLocked = (code) => {
    const info = bagLockMap.value[String(code ?? '')];
    return Boolean(info?.locked);
};

const bagLockMessage = (code) => {
    const info = bagLockMap.value[String(code ?? '')];
    if (!info?.locked) return '';
    if (info.lockedByWeight && info.lockedByVolume) {
        return 'Mala cheia: limite de peso e volume atingidos';
    }
    if (info.lockedByWeight) {
        return 'Mala cheia: limite de peso atingido';
    }
    if (info.lockedByVolume) {
        return 'Mala cheia: limite de volume atingido';
    }
    return 'Mala cheia';
};

const suitcaseSummaries = computed(() =>
    rawPackBags.value.map((bag, index) => {
        const capacityKg = Number(bag.capacity_kg ?? bag.capacity ?? 0) || 0;
        const actualKg = Number(bag.total_kg ?? bag.yes_kg ?? bag.used ?? 0) || 0;
        const reservedKg = Number(bag.reservedAppliedKg ?? bag.reserved_kg ?? bag.reserved_applied_kg ?? 0) || 0;
        const projectedKg = Number(bag.projectedWeightKg ?? bag.projected_weight_kg ?? 0) || 0;
        let effectiveKg = Number(bag.usedWithProjection ?? bag.effective_kg ?? bag.effectiveKg ?? 0);
        if (!effectiveKg) {
            effectiveKg = actualKg + reservedKg + projectedKg;
        }
        const remainingKg = bag.remaining_kg != null ? Number(bag.remaining_kg) : Math.max(capacityKg - effectiveKg, 0);
        const weightRatio = bag.weight_ratio ?? (capacityKg ? effectiveKg / capacityKg : 0);

        const capacityVolumeCm3 = Number(
            bag.capacity_volume_cm3 ??
                bag.capacityVolume_cm3 ??
                bag.capacityVolume ??
                bag.capacity_volume ??
                0,
        ) || 0;
        const actualVolumeCm3 = Number(
            bag.total_volume_cm3 ??
                bag.volume_cm3 ??
                bag.volumeCm3 ??
                bag.used_volume_cm3 ??
                0,
        ) || 0;
        const reservedVolumeCm3 = Number(
            bag.reserved_volume_cm3 ??
                bag.reservedVolumeCm3 ??
                bag.reservedVolumeAppliedCm3 ??
                0,
        ) || 0;
        const projectedVolumeCm3 = Number(bag.projected_volume_cm3 ?? bag.projectedVolumeCm3 ?? 0) || 0;

        let effectiveVolumeCm3 = Number(
            bag.volumeWithProjectionCm3 ??
                bag.effective_volume_cm3 ??
                bag.effectiveVolumeCm3 ??
                0,
        );
        if (!effectiveVolumeCm3) {
            effectiveVolumeCm3 = actualVolumeCm3 + reservedVolumeCm3 + projectedVolumeCm3;
        }

        const remainingVolumeCm3 =
            bag.remaining_volume_cm3 != null
                ? Number(bag.remaining_volume_cm3)
                : bag.remainingVolumeCm3 != null
                    ? Number(bag.remainingVolumeCm3)
                    : capacityVolumeCm3
                        ? Math.max(capacityVolumeCm3 - effectiveVolumeCm3, 0)
                        : null;

        const volumeRatio = bag.volume_ratio ?? (capacityVolumeCm3 ? effectiveVolumeCm3 / capacityVolumeCm3 : 0);

        const lockedByWeight = Boolean(bag.locked_by_weight ?? bag.lockedByWeight) || weightRatio >= 1;
        const lockedByVolume = Boolean(bag.locked_by_volume ?? bag.lockedByVolume) || volumeRatio >= 1;
        const locked = Boolean(bag.locked ?? (lockedByWeight || lockedByVolume));

        let status = bag.status;
        if (!status) {
            if (locked) status = 'Fechado';
            else if (Math.max(weightRatio, volumeRatio) >= 0.9) status = 'Lotado';
            else status = 'Normal';
        }

        return {
            id: String(bag.id ?? `bag-${index}`),
            name: bag.name ?? `Mala ${index + 1}`,
            dims: bag.dimensions ?? '—',
            current: effectiveKg,
            max: capacityKg,
            ratio: Math.max(weightRatio, volumeRatio),
            status,
            weight: {
                actual: actualKg,
                reserved: reservedKg,
                projected: projectedKg,
                effective: effectiveKg,
                remaining: remainingKg,
            },
            volume: {
                actual: actualVolumeCm3,
                reserved: reservedVolumeCm3,
                projected: projectedVolumeCm3,
                effective: effectiveVolumeCm3,
                capacity: capacityVolumeCm3 || null,
                remaining: remainingVolumeCm3,
            },
        };
    }),
);

const packTotalCapacityKg = computed(() => {
    const capacity = Number(packTotals.value.total_capacity ?? 0);
    if (capacity > 0) return capacity;
    return rawPackBags.value.reduce((sum, bag) => sum + Number(bag.capacity_kg ?? bag.capacity ?? 0), 0);
});

const packReservedKg = computed(() => Number(packTotals.value.reserved_kg ?? decisionStore.reservedKg ?? 0));

const packEffectiveWeightKg = computed(() =>
    suitcaseSummaries.value.reduce((sum, bag) => sum + Number(bag.weight?.effective ?? 0), 0),
);

const packUsedWeightKg = packEffectiveWeightKg;

const packRemainingWeightKg = computed(() =>
    Math.max(packTotalCapacityKg.value - packEffectiveWeightKg.value, 0),
);

const packTotalVolumeCm3 = computed(() => {
    const total = Number(packTotals.value.total_volume_cm3 ?? 0);
    if (total > 0) return total;
    return rawPackBags.value.reduce(
        (sum, bag) =>
            sum +
            Number(
                bag.capacity_volume_cm3 ??
                    bag.capacityVolume_cm3 ??
                    bag.capacityVolume ??
                    bag.capacity_volume ??
                    0,
            ),
        0,
    );
});

const packReservedVolumeCm3 = computed(() =>
    Number(packTotals.value.reserved_volume_cm3 ?? decisionStore.reservedVolumeCm3 ?? 0),
);

const packEffectiveVolumeCm3 = computed(() =>
    suitcaseSummaries.value.reduce((sum, bag) => sum + Number(bag.volume?.effective ?? 0), 0),
);

const packUsedVolumeCm3 = packEffectiveVolumeCm3;

const packRemainingVolumeCm3 = computed(() =>
    Math.max(packTotalVolumeCm3.value - packEffectiveVolumeCm3.value, 0),
);

const lockedBagsCount = computed(() =>
    rawPackBags.value.filter((bag) => {
        const weightRatio = Number(bag.weight_ratio ?? bag.weightRatio ?? 0);
        const volumeRatio = Number(bag.volume_ratio ?? bag.volumeRatio ?? 0);
        const lockedByWeight = Boolean(bag.locked_by_weight ?? bag.lockedByWeight) || weightRatio >= 1;
        const lockedByVolume = Boolean(bag.locked_by_volume ?? bag.lockedByVolume) || volumeRatio >= 1;
        return Boolean(bag.locked ?? (lockedByWeight || lockedByVolume));
    }).length,
);

const totalBagsCount = computed(() => rawPackBags.value.length);

const packedCount = computed(() => packItems.value.filter((item) => item.packed).length);
const hasPacked = computed(() => packItems.value.some((item) => item.packed));

const allPackedBanner = computed(() => decisionStore.allPacked && packItems.value.length > 0);

const markAllPacked = async (value) => {
    if (!packItems.value.length) return;
    const ids = packItems.value.map((item) => item.id);
    try {
        const operations = [decisionStore.markPacked(ids, value)];
        if (!value) {
            operations.push(decisionStore.assignBagBulk(ids, ''));
        }
        await Promise.all(operations);
        toast.success(value ? 'Itens marcados como embalados ✅' : 'Todos os itens liberados das malas ↩︎');
    } catch (error) {
        console.error(error);
        toast.error('Não foi possível atualizar os itens ❌');
    }
};

const assignBag = async (item, bag) => {
    if (!item) return;
    if (isBagLocked(bag)) {
        toast.info(bagLockMessage(bag) || 'Esta mala já está cheia');
        return;
    }

    const operations = [];
    if (item.bag !== bag) {
        operations.push(decisionStore.assignBag(item.id, bag));
    }
    if (!item.packed) {
        operations.push(decisionStore.markPacked([item.id], true));
    }

    if (!operations.length) {
        return;
    }

    try {
        await Promise.all(operations);
        toast.success(`Item preparado na mala ${bag}`);
    } catch (error) {
        console.error(error);
        toast.error('Não foi possível atualizar o item ❌');
    }
};

const onPackedChange = async (item, checked) => {
    try {
        const operations = [decisionStore.markPacked([item.id], checked)];
        if (!checked && item.bag) {
            operations.push(decisionStore.assignBag(item.id, ''));
        }
        await Promise.all(operations);
        toast.success(checked ? 'Marcado como embalado ✅' : 'Item voltou para a fila e saiu da mala ↩︎');
    } catch (error) {
        console.error(error);
        toast.error('Não foi possível atualizar o item ❌');
    }
};

const openItemHelp = (item) => {
    const bagLabel = item.bag ? `Na mala ${item.bag}` : 'Ainda sem mala';
    const weightLabel = `${(item.weight ?? 0).toFixed(1)} kg`;
    const volumeLabel = formatVolume(item) ?? 'Sem volume estimado';
    toast.info(`${item.title ?? item.name}: ${bagLabel} • ${weightLabel} • ${volumeLabel}`);
};

const formatVolume = (item) => {
    const cm3 = item.volume_cm3 ?? null;
    const liters = item.volume_liters ?? (cm3 != null ? cm3 / 1000 : null);
    if (liters == null || Number.isNaN(liters)) {
        return null;
    }
    const cm3Value = cm3 ?? liters * 1000;
    return `${Number(liters).toFixed(1)} L (${numberFormatter.format(Math.round(cm3Value))} cm³)`;
};
</script>
