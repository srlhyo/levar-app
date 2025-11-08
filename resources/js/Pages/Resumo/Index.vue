<template>
    <Head title="Resumo" />
    <AppLayout>
        <template #title>Resumo</template>
        <template #subtitle>Uma visão geral das malas, pendências e itens que vão com a gente.</template>

        <Card tone="slate">
            <div class="flex flex-wrap items-center justify-between gap-3 mb-4">
                <div>
                    <p class="text-base font-semibold text-slate-900">Panorama da mudança</p>
                    <p class="text-sm text-slate-600">Acompanhe o avanço entre levar, pendentes e não levar em tempo real.</p>
                </div>
                <button
                    type="button"
                    class="inline-flex items-center gap-2 rounded-full bg-white/80 px-3 py-1 text-xs font-semibold text-slate-700 ring-1 ring-black/5 transition hover:bg-white focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-300"
                    @click="showResumoHelp = !showResumoHelp"
                    :aria-expanded="showResumoHelp ? 'true' : 'false'"
                >
                    <span class="inline-flex h-5 w-5 items-center justify-center rounded-full bg-emerald-500/15 text-[11px] font-semibold text-emerald-600">?</span>
                    Como funciona
                </button>
            </div>
            <transition name="fade">
                <div
                    v-if="showResumoHelp"
                    class="mb-4 space-y-2 rounded-2xl bg-white/80 px-4 py-3 text-xs text-slate-600 ring-1 ring-black/5 sm:text-sm"
                >
                    <p class="font-semibold text-slate-800">Dicas rápidas</p>
                    <ul class="list-disc space-y-1 pl-5">
                        <li>Use o Resumo para reordenar o que já foi decidido e enviar itens de volta ao deck.</li>
                        <li>Os números somam levar + não levar + pendentes. Se algo parecer fora, reinsira cartas.</li>
                        <li>Os cartões de mala mostram peso/volume utilizados; quando travam, mova itens para outra.</li>
                    </ul>
                </div>
            </transition>
            <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
                <div class="space-y-1">
                    <p class="text-xs uppercase tracking-wide text-slate-600">Vai levar</p>
                    <p class="text-2xl font-semibold text-emerald-600">{{ stats.take }}</p>
                </div>
                <div class="space-y-1">
                    <p class="text-xs uppercase tracking-wide text-slate-600">Não levar</p>
                    <p class="text-2xl font-semibold text-rose-500">{{ stats.leave }}</p>
                </div>
                <div class="space-y-1">
                    <p class="text-xs uppercase tracking-wide text-slate-600">Pendentes (fila)</p>
                    <p class="text-2xl font-semibold text-sky-600">{{ stats.pending }}</p>
                </div>
                <div class="space-y-1">
                    <p class="text-xs uppercase tracking-wide text-slate-600">Indefinidos</p>
                    <p class="text-2xl font-semibold text-slate-600">{{ stats.undecided }}</p>
                </div>
            </div>
            <div class="mt-4 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
                <div class="rounded-2xl bg-white/70 px-4 py-3 text-xs font-medium text-slate-600 ring-1 ring-white/40">
                    Total catalogado: <span class="font-semibold text-slate-900">{{ stats.total }}</span>
                </div>
                <div class="rounded-2xl bg-white/70 px-4 py-3 text-xs font-medium text-slate-600 ring-1 ring-white/40">
                    Processados: <span class="font-semibold text-slate-900">{{ processedSummary }}</span>
                </div>
                <div class="rounded-2xl bg-white/70 px-4 py-3 text-xs font-medium text-slate-600 ring-1 ring-white/40">
                    Pendentes (total): <span class="font-semibold text-slate-900">{{ stats.pending_total ?? pendingTotal }}</span>
                </div>
                <div class="rounded-2xl bg-white/70 px-4 py-3 text-xs font-medium text-slate-600 ring-1 ring-white/40">
                    Cartas no deck: <span class="font-semibold text-slate-900">{{ pendingDeckCount }}</span>
                </div>
            </div>
            <div
                class="mt-4 grid gap-3 rounded-2xl bg-white/70 px-4 py-3 text-xs text-slate-600 ring-1 ring-white/40 sm:grid-cols-3 sm:text-sm"
            >
                <div class="flex items-center gap-3">
                    <span class="grid h-8 w-8 place-items-center rounded-full bg-emerald-100 text-emerald-600">🎯</span>
                    <div class="space-y-0.5">
                        <p class="text-xs font-semibold uppercase tracking-wide text-slate-500 sm:text-[0.7rem]">
                            Progresso geral
                        </p>
                        <p class="text-sm font-semibold text-slate-800">
                            {{ completionPercent }}% concluído
                        </p>
                    </div>
                </div>
                <div class="flex items-center gap-3">
                    <span class="grid h-8 w-8 place-items-center rounded-full bg-sky-100 text-sky-600">📦</span>
                    <div class="space-y-0.5">
                        <p class="text-xs font-semibold uppercase tracking-wide text-slate-500 sm:text-[0.7rem]">
                            Pronto para levar
                        </p>
                        <p class="text-sm font-semibold text-slate-800">
                            {{ readyPercent }}% dos itens
                        </p>
                    </div>
                </div>
                <div class="flex items-center gap-3">
                    <span class="grid h-8 w-8 place-items-center rounded-full bg-amber-100 text-amber-600">🧳</span>
                    <div class="space-y-0.5">
                        <p class="text-xs font-semibold uppercase tracking-wide text-slate-500 sm:text-[0.7rem]">
                            Já embalados
                        </p>
                        <p class="text-sm font-semibold text-slate-800">
                            {{ packedPercent }}% embalado
                        </p>
                    </div>
                </div>
            </div>
        </Card>

        <Card tone="slate" class="space-y-4">
            <div class="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
                <div class="space-y-1">
                    <p class="text-sm font-semibold text-slate-800">Capacidade das malas</p>
                    <p class="text-xs text-slate-600 sm:text-sm">
                        Veja os detalhes completos de peso e volume na tela Embalar. Lá você consegue distribuir e travar cada mala em tempo real.
                    </p>
                </div>
                <button
                    type="button"
                    class="inline-flex items-center gap-2 rounded-full bg-emerald-500 px-4 py-2 text-sm font-semibold text-white shadow transition hover:bg-emerald-400 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-300"
                    @click="goToPack"
                >
                    Abrir Embalar
                </button>
            </div>
        </Card>

        <Card tone="slate" class="space-y-5">
            <div class="flex flex-col gap-3 sm:flex-row sm:items-start sm:justify-between">
                <div>
                    <p class="text-base font-semibold text-slate-900">Itens por decisão</p>
                    <p class="text-sm text-slate-600">
                        Navegue pelos itens marcados como levar, pendentes ou não levar.
                    </p>
                </div>
                <button
                    type="button"
                    class="inline-flex items-center gap-2 self-start rounded-full bg-sky-500/10 px-4 py-2 text-xs font-semibold text-sky-600 ring-1 ring-sky-200 transition hover:bg-sky-500/20 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-sky-400 sm:text-sm"
                    @click="goToDecidir"
                >
                    Ir para Decidir
                    <span aria-hidden="true" class="text-base">→</span>
                </button>
            </div>
            <div class="flex flex-wrap items-center gap-2 text-xs text-slate-600 sm:text-sm">
                <span class="inline-flex items-center gap-1 rounded-full bg-emerald-50 px-3 py-1 text-emerald-600">
                    ✔ Levar: <span class="font-semibold">{{ stats.take }}</span>
                </span>
                <span class="inline-flex items-center gap-1 rounded-full bg-amber-50 px-3 py-1 text-amber-600">
                    ⏳ Pendentes: <span class="font-semibold">{{ stats.pending_total ?? pendingTotal }}</span>
                </span>
                <span class="inline-flex items-center gap-1 rounded-full bg-rose-50 px-3 py-1 text-rose-500">
                    ✖ Não levar: <span class="font-semibold">{{ stats.leave }}</span>
                </span>
            </div>

            <Tabs v-model="activeTab" :items="tabItems">
                <div v-if="totalFilteredCount" class="mt-4 space-y-4">
                    <div class="flex flex-wrap items-center justify-between gap-3 rounded-2xl bg-white/70 px-4 py-2 text-sm text-slate-600 ring-1 ring-white/40">
                        <div class="flex flex-wrap items-center gap-3 text-xs sm:text-sm">
                            <div class="relative">
                                <input
                                    v-model="searchQuery"
                                    type="search"
                                    placeholder="Buscar por nome, notas ou mala…"
                                    class="w-56 rounded-full border border-slate-200 bg-white/90 px-3 py-1.5 text-sm text-slate-700 shadow-inner shadow-slate-100 focus:border-emerald-400 focus:outline-none focus:ring-2 focus:ring-emerald-200 sm:w-64"
                                />
                            </div>
                            <select
                                v-model="selectedBagFilter"
                                class="rounded-full border border-slate-200 bg-white/90 px-3 py-1.5 text-xs font-medium text-slate-600 shadow-inner shadow-slate-100 focus:border-emerald-400 focus:outline-none focus:ring-2 focus:ring-emerald-200 sm:text-sm"
                            >
                                <option value="all">Todas as malas</option>
                                <option v-for="bag in bagFilters" :key="bag.value" :value="bag.value">
                                    {{ bag.label }}
                                </option>
                                <option value="unassigned">Sem mala</option>
                            </select>
                            <div class="inline-flex items-center gap-2 rounded-full border border-slate-200 bg-white/90 px-2 py-1 text-xs text-slate-600 shadow-inner shadow-slate-100">
                                <span>Itens por página</span>
                                <select
                                    v-model.number="pageSize"
                                    class="rounded border border-slate-200 bg-white px-2 py-1 text-xs focus:border-emerald-400 focus:outline-none focus:ring-1 focus:ring-emerald-300"
                                >
                                    <option v-for="option in pageSizeOptions" :key="option" :value="option">
                                        {{ option }}
                                    </option>
                                </select>
                            </div>
                            <button
                                type="button"
                                class="inline-flex items-center gap-1 rounded-full bg-white px-3 py-1 text-xs font-semibold text-slate-600 ring-1 ring-black/5 transition hover:bg-slate-50 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-300"
                                @click="resetFilters"
                            >
                                Limpar filtros
                            </button>
                        </div>
                        <div class="text-xs text-slate-500 sm:text-sm">
                            Exibindo
                            <span class="font-semibold text-slate-700">{{ pageStart }}–{{ pageEnd }}</span>
                            de
                            <span class="font-semibold text-slate-700">{{ totalFilteredCount }}</span>
                            itens
                        </div>
                    </div>

                    <div class="flex flex-wrap items-center justify-between gap-3 rounded-2xl bg-white/70 px-4 py-2 text-sm text-slate-600 ring-1 ring-white/40">
                        <label class="flex items-center gap-2 font-semibold">
                            <input
                                ref="selectAllRef"
                                type="checkbox"
                                class="h-5 w-5 rounded border-slate-300 text-emerald-500 focus:ring-emerald-400"
                                :checked="allSelected"
                                @change="toggleSelectAll"
                            />
                            <span>Selecionar todos</span>
                        </label>
                        <div class="flex items-center gap-2">
                            <button
                                type="button"
                                class="inline-flex items-center justify-center gap-2 rounded-full bg-emerald-50 px-3 py-1.5 text-xs font-semibold text-emerald-600 ring-1 ring-emerald-200 transition hover:bg-emerald-100 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-300 disabled:cursor-not-allowed disabled:opacity-50"
                                :disabled="!selectedCount"
                                @click="handleBulkRequeue"
                                title="Devolver a seleção para o deck da tela Decidir"
                            >
                                ↩ Voltar para o deck do Decidir
                            </button>
                            <span v-if="selectedCount" class="text-xs font-medium text-slate-500">
                                {{ selectedCount }} selecionado(s)
                            </span>
                        </div>
                    </div>

                    <div
                        ref="listContainer"
                        class="max-h-[65vh] space-y-3 overflow-y-auto pr-1"
                    >
                        <ItemRow
                            v-for="item in currentItems"
                            :key="item.id"
                            :item="item"
                            :selected="currentSelection.has(item.id)"
                            :show-delete="false"
                            @toggle-select="toggleSelection"
                        />
                    </div>

                    <div
                        v-if="totalPages > 1"
                        class="flex flex-wrap items-center justify-between gap-2 rounded-2xl bg-white/70 px-4 py-2 text-xs text-slate-600 ring-1 ring-white/40 sm:text-sm"
                    >
                        <div class="space-x-2">
                            <button
                                type="button"
                                class="rounded-full border border-slate-200 px-3 py-1 font-semibold text-slate-600 transition hover:bg-white focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-300 disabled:cursor-not-allowed disabled:opacity-40"
                                :disabled="currentPage <= 1"
                                @click="currentPage = Math.max(currentPage - 1, 1)"
                            >
                                ← Anterior
                            </button>
                            <button
                                type="button"
                                class="rounded-full border border-slate-200 px-3 py-1 font-semibold text-slate-600 transition hover:bg-white focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-300 disabled:cursor-not-allowed disabled:opacity-40"
                                :disabled="currentPage >= totalPages"
                                @click="currentPage = Math.min(currentPage + 1, totalPages)"
                            >
                                Próxima →
                            </button>
                        </div>
                        <div class="flex items-center gap-2">
                            <span>Página</span>
                            <input
                                v-model.number="currentPage"
                                type="number"
                                min="1"
                                :max="totalPages"
                                class="w-16 rounded border border-slate-200 px-2 py-1 text-center text-sm focus:border-emerald-400 focus:outline-none focus:ring-1 focus:ring-emerald-300"
                            />
                            <span>de {{ totalPages }}</span>
                        </div>
                    </div>

                    <transition name="slide-up">
                        <div
                            v-if="selectedCount"
                            class="sticky bottom-0 inset-x-0 rounded-3xl bg-white/90 p-3 shadow-[0_-6px_12px_rgba(0,0,0,0.06)] backdrop-blur sm:relative sm:rounded-none sm:bg-transparent sm:p-0 sm:shadow-none"
                        >
                            <div class="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-end">
                                <button
                                    type="button"
                                    class="inline-flex items-center justify-center gap-2 rounded-full bg-emerald-500 px-4 py-2 text-sm font-semibold text-white shadow transition hover:bg-emerald-400 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-300"
                                    @click="handleBulkRequeue"
                                >
                                    ↩ Voltar para o deck do Decidir
                                </button>
                                <button
                                    type="button"
                                    class="inline-flex items-center justify-center gap-2 rounded-full bg-white/80 px-4 py-2 text-sm font-semibold text-slate-700 ring-1 ring-black/5 transition hover:bg-white focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-300"
                                    @click="clearCurrentSelection"
                                >
                                    Limpar seleção
                                </button>
                            </div>
                        </div>
                    </transition>

                </div>

                <div
                    v-else
                    class="mt-4 rounded-3xl border border-dashed border-slate-300/80 bg-white/70 p-6 text-center text-sm text-slate-600"
                >
                    <p class="text-base font-semibold text-slate-700">{{ currentEmpty.title }}</p>
                    <p class="mt-1 text-sm text-slate-500">{{ currentEmpty.description }}</p>
                </div>
            </Tabs>
        </Card>

    </AppLayout>
</template>

<script setup>
import { Head, usePage, router } from '@inertiajs/vue3';
import { computed, inject, nextTick, onBeforeUnmount, onMounted, reactive, ref, watch, watchEffect } from 'vue';
import AppLayout from '@/Layouts/AppLayout.vue';
import Card from '@/Components/Card.vue';
import Tabs from '@/Components/Tabs.vue';
import ItemRow from '@/Components/ItemRow.vue';
import { useDecisionStore } from '@/stores/decision';
import { toast } from '@/utils/toast';

const decisionStore = useDecisionStore();
const page = usePage();
const move = computed(() => page.props.move ?? null);

watchEffect(() => {
    decisionStore.setMove(move.value);
});

const goToPack = () => {
    router.visit('/pick');
};

const goToDecidir = () => {
    router.visit('/decidir');
};

const showResumoHelp = ref(false);
const activeTab = ref('take');
const selectAllRef = ref(null);
const selection = reactive({
    take: new Set(),
    pending: new Set(),
    leave: new Set(),
});

const takeItems = computed(() => decisionStore.takeList ?? []);
const pendingItems = computed(() => decisionStore.pendingList ?? []);
const undecidedItems = computed(() => decisionStore.undecidedList ?? []);
const leaveItems = computed(() => decisionStore.leaveList ?? []);

const allResumoItems = computed(() => {
    const map = new Map();
    [...takeItems.value, ...pendingItems.value, ...undecidedItems.value, ...leaveItems.value].forEach((item) => {
        map.set(item.id, item);
    });
    return Array.from(map.values());
});

const tabItems = computed(() => [
    { key: 'take', label: 'Levar', badge: decisionStore.yesCount },
    { key: 'pending', label: 'Pendentes', badge: pendingItems.value.length },
    { key: 'leave', label: 'Não levar', badge: decisionStore.noCount },
]);

const listsByTab = computed(() => ({
    take: takeItems.value,
    pending: pendingItems.value,
    leave: leaveItems.value,
}));

const rawTabItems = computed(() => listsByTab.value[activeTab.value] ?? []);

const searchQuery = ref('');
const selectedBagFilter = ref('all');
const pageSizeOptions = [10, 25, 50, 100];
const pageSize = ref(25);
const currentPage = ref(1);

const bagFilters = computed(() => {
    const seen = new Map();
    rawTabItems.value.forEach((item) => {
        const code = item.bag ?? item.bag_code ?? null;
        if (!code) return;
        if (!seen.has(code)) {
            const label = item.bag_name
                ? item.bag_name
                : `Mala ${String(code).toUpperCase()}`;
            seen.set(String(code), { value: String(code), label });
        }
    });
    return Array.from(seen.values()).sort((a, b) => a.label.localeCompare(b.label, 'pt-BR'));
});

const normalize = (value) => (value ?? '').toString().toLowerCase();

const filteredItems = computed(() => {
    const query = normalize(searchQuery.value);
    const bagFilter = selectedBagFilter.value;

    return rawTabItems.value.filter((item) => {
        if (bagFilter === 'unassigned' && (item.bag ?? item.bag_code ?? null)) {
            return false;
        }
        if (bagFilter !== 'all' && bagFilter !== 'unassigned') {
            if (String(item.bag ?? item.bag_code ?? '') !== bagFilter) {
                return false;
            }
        }

        if (!query) return true;

        const bagLabel = item.bag_name ?? (item.bag ? `Mala ${item.bag}` : '');
        const haystack = normalize(
            `${item.title ?? ''} ${item.notes ?? ''} ${item.category ?? ''} ${item.section ?? ''} ${item.bag ?? ''} ${bagLabel}`,
        );

        return haystack.includes(query);
    });
});

const totalFilteredCount = computed(() => filteredItems.value.length);

const totalPages = computed(() => {
    if (!totalFilteredCount.value) return 0;
    return Math.max(1, Math.ceil(totalFilteredCount.value / pageSize.value));
});

const currentItems = computed(() => {
    if (!totalFilteredCount.value) return [];
    const start = (currentPage.value - 1) * pageSize.value;
    return filteredItems.value.slice(start, start + pageSize.value);
});

const pageStart = computed(() => {
    if (!totalFilteredCount.value) return 0;
    return Math.min((currentPage.value - 1) * pageSize.value + 1, totalFilteredCount.value);
});

const pageEnd = computed(() => {
    if (!totalFilteredCount.value) return 0;
    return Math.min(pageStart.value + pageSize.value - 1, totalFilteredCount.value);
});

const currentSelection = computed(() => selection[activeTab.value] ?? new Set());
const selectedIds = computed(() => Array.from(currentSelection.value));
const selectedCount = computed(() => selectedIds.value.length);
const allSelected = computed(
    () => currentItems.value.length > 0 && selectedIds.value.length === currentItems.value.length,
);
const someSelected = computed(
    () => selectedIds.value.length > 0 && selectedIds.value.length < currentItems.value.length,
);

const emptyStates = {
    take: {
        title: 'Nada por aqui ainda.',
        description: 'Decida itens no deck para montar a lista de levar.',
    },
    pending: {
        title: 'Sem pendências.',
        description: 'Os itens adiados aparecem aqui para retomar depois.',
    },
    leave: {
        title: 'Nenhum item marcado como “Não levar”.',
        description: 'Quando você descarta algo, ele aparece aqui.',
    },
};

const currentEmpty = computed(() => emptyStates[activeTab.value] ?? emptyStates.take);

const rawStats = computed(() =>
    decisionStore.resumo.stats ?? {
        total: 0,
        pending: 0,
        take: 0,
        leave: 0,
        undecided: 0,
        decided: 0,
        remaining: 0,
        totalWeight: 0,
        reservedKg: decisionStore.reservedKg ?? 0,
    },
);

const pendingDeckCount = computed(() => rawStats.value.pending_deck ?? undecidedItems.value.length ?? 0);
const pendingBacklog = computed(() => rawStats.value.pending ?? pendingItems.value.length ?? 0);
const pendingTotal = computed(() => rawStats.value.pending_total ?? pendingBacklog.value);

const stats = computed(() => {
    const base = rawStats.value;
    const total = base.total ?? 0;
    const take = base.take ?? decisionStore.yesCount;
    const leave = base.leave ?? decisionStore.noCount;
    const pending = base.pending ?? pendingBacklog.value;
    const undecided = base.undecided ?? Math.max(total - (take + leave + pending), 0);
    const decided = base.decided ?? (take + leave);
    const processed = base.processed ?? (take + leave + pending);
    const reserved = base.reservedKg ?? decisionStore.reservedKg ?? 0;
    const totalCapacity = base.totalCapacityKg ?? 0;

    const takeList = decisionStore.resumo.lists.take ?? [];
    const fallbackYesWeight = takeList.reduce(
        (sum, item) => sum + (Number(item.weight ?? item.weight_kg ?? item.weightKg ?? 0) || 0),
        0,
    );
    const fallbackYesVolume = takeList.reduce((sum, item) => {
        if (item.volume_cm3 != null) return sum + Number(item.volume_cm3);
        if (item.volume_liters != null) return sum + Number(item.volume_liters) * 1000;
        if (item.dimensions) {
            const parts = item.dimensions
                .split(/[x×]/i)
                .map((part) => parseFloat(part.replace(/[^0-9,.]/g, '').replace(',', '.')))
                .filter((value) => !Number.isNaN(value) && value > 0);
            if (parts.length >= 3) {
                return sum + parts.slice(0, 3).reduce((acc, value) => acc * value, 1);
            }
        }
        return sum;
    }, 0);

    const yesWeight = base.yesWeightKg ?? fallbackYesWeight;
    const remainingCapacity = base.remainingCapacityKg ?? Math.max(totalCapacity - reserved - yesWeight, 0);

    const summaryVolumes = base.volumes ?? base.dimensions ?? null;
    const yesVolumeCm3 = summaryVolumes?.volume_cm3 ?? fallbackYesVolume;

    const items = allResumoItems.value;
    const packed = items.filter((item) => item.packed).length;

    return {
        ...base,
        total,
        take,
        leave,
        pending,
        pending_total: pendingTotal.value,
        pending_deck: pendingDeckCount.value,
        undecided,
        decided,
        processed,
        remaining: base.remaining ?? Math.max(0, total - processed),
        packed,
        reservedKg: reserved,
        totalCapacityKg: totalCapacity,
        yesWeightKg: yesWeight,
        remainingCapacityKg: remainingCapacity,
        yesVolumeCm3,
    };
});

const processedSummary = computed(() => stats.value.processed ?? ((stats.value.decided ?? 0) + (stats.value.pending ?? 0)));

const completionPercent = computed(() => {
    if (!stats.value.total) return 0;
    return Math.round(((stats.value.processed ?? 0) / stats.value.total) * 100);
});

const readyPercent = computed(() => {
    if (!stats.value.total) return 0;
    return Math.round(((stats.value.take ?? 0) / stats.value.total) * 100);
});

const packedPercent = computed(() => {
    if (!stats.value.total) return 0;
    return Math.round(((stats.value.packed ?? 0) / stats.value.total) * 100);
});

const bagSummaries = computed(() => {
    const list = decisionStore.resumo.bags ?? [];
    let reservedRemaining = Number(stats.value.reservedKg ?? decisionStore.reservedKg ?? 0);
    let volumeReservedTotal = Number(
        (stats.value.volumes ?? stats.value.dimensions)?.reserved_cm3 ?? 0,
    );
    if (volumeReservedTotal <= 0) {
        volumeReservedTotal = Number(decisionStore.reservedVolumeCm3 ?? 0);
    }
    if (volumeReservedTotal <= 0) {
        volumeReservedTotal = Number(move.value?.reserved_volume_cm3 ?? 0);
    }
    if (volumeReservedTotal <= 0) {
        volumeReservedTotal = list.reduce(
            (sum, bag) => sum + Number(bag.reserved_volume_cm3 ?? bag.reservedVolumeAppliedCm3 ?? 0),
            0,
        );
    }
    let reservedVolumeRemaining = volumeReservedTotal > 0 ? volumeReservedTotal : 0;
    const epsilon = 1e-4;

    const baseBags = list.map((bag, index) => {
        const capacity = Number(bag.capacity_kg ?? bag.capacity ?? 0) || 0;
        const actualUsed = Number(bag.yes_kg ?? bag.total_kg ?? bag.total ?? 0) || 0;

        const preReservedKg = Number(
            bag.reserved_applied_kg ?? bag.reservedAppliedKg ?? bag.reserved_kg ?? 0,
        );
        const preEffectiveKg = bag.effective_kg ?? bag.effectiveKg ?? null;
        const preRemainingKg = bag.remaining_kg ?? null;
        const preWeightRatio = bag.weight_ratio ?? bag.weightRatio ?? null;
        const preLockedByWeight = bag.locked_by_weight ?? bag.lockedByWeight ?? null;

        let reservedApplied = Number(preReservedKg) || 0;
        let effectiveUsed =
            preEffectiveKg != null ? Number(preEffectiveKg) : actualUsed + reservedApplied;
        let remaining =
            preRemainingKg != null ? Number(preRemainingKg) : Math.max(capacity - effectiveUsed, 0);
        let weightRatio =
            preWeightRatio != null ? Number(preWeightRatio) : capacity ? effectiveUsed / capacity : 0;
        let lockedByWeight =
            preLockedByWeight != null
                ? Boolean(preLockedByWeight)
                : capacity > 0 && weightRatio >= 1 - epsilon;

        if (preEffectiveKg == null && preReservedKg === 0) {
            const availableForReserved = Math.max(capacity - actualUsed, 0);
            reservedApplied = Math.min(availableForReserved, Math.max(reservedRemaining, 0));
            reservedRemaining -= reservedApplied;
            effectiveUsed = actualUsed + reservedApplied;
            remaining = Math.max(capacity - effectiveUsed, 0);
            weightRatio = capacity ? effectiveUsed / capacity : 0;
            lockedByWeight = capacity > 0 && weightRatio >= 1 - epsilon;
        }

        const rawCapacityVolume =
            bag.capacity_volume_cm3 ?? bag.capacityVolume_cm3 ?? bag.capacityVolumeCm3 ?? null;
        const capacityVolumeCm3 = rawCapacityVolume != null ? Number(rawCapacityVolume) : null;
        const volumeCm3 = Number(bag.total_volume_cm3 ?? bag.volume_cm3 ?? bag.volumeCm3 ?? 0) || 0;
        const preReservedVolume = Number(
            bag.reserved_volume_cm3 ?? bag.reservedVolumeAppliedCm3 ?? 0,
        );
        const preEffectiveVolume =
            bag.effective_volume_cm3 ?? bag.effectiveVolumeCm3 ?? null;
        const preRemainingVolume =
            bag.remaining_volume_cm3 ?? bag.remainingVolumeCm3 ?? null;
        const preVolumeRatio = bag.volume_ratio ?? bag.volumeRatio ?? null;
        const preLockedByVolume = bag.locked_by_volume ?? bag.lockedByVolume ?? null;

        let reservedVolumeApplied = Number(preReservedVolume) || 0;
        let effectiveVolumeCm3 =
            preEffectiveVolume != null
                ? Number(preEffectiveVolume)
                : volumeCm3 + reservedVolumeApplied;
        let remainingVolumeCm3 =
            preRemainingVolume !== null && preRemainingVolume !== undefined
                ? (preRemainingVolume === null ? null : Number(preRemainingVolume))
                : capacityVolumeCm3 != null
                    ? Math.max(capacityVolumeCm3 - effectiveVolumeCm3, 0)
                    : null;
        let volumeRatio =
            preVolumeRatio != null
                ? Number(preVolumeRatio)
                : capacityVolumeCm3 && capacityVolumeCm3 > 0
                    ? effectiveVolumeCm3 / capacityVolumeCm3
                    : 0;
        let lockedByVolume =
            preLockedByVolume != null
                ? Boolean(preLockedByVolume)
                : capacityVolumeCm3 && volumeRatio >= 1 - epsilon;

        if (preEffectiveVolume == null && preReservedVolume === 0 && capacityVolumeCm3 != null) {
            const availableVolumeForReserved = Math.max(capacityVolumeCm3 - volumeCm3, 0);
            reservedVolumeApplied = Math.min(
                availableVolumeForReserved,
                Math.max(reservedVolumeRemaining, 0),
            );
            reservedVolumeRemaining = Math.max(reservedVolumeRemaining - reservedVolumeApplied, 0);
            effectiveVolumeCm3 = volumeCm3 + reservedVolumeApplied;
            remainingVolumeCm3 = Math.max(capacityVolumeCm3 - effectiveVolumeCm3, 0);
            volumeRatio =
                capacityVolumeCm3 && capacityVolumeCm3 > 0
                    ? effectiveVolumeCm3 / capacityVolumeCm3
                    : 0;
            lockedByVolume = capacityVolumeCm3 && volumeRatio >= 1 - epsilon;
        }

        const locked =
            (bag.locked ?? null) !== null ? Boolean(bag.locked) : lockedByWeight || lockedByVolume;

        const status = bag.status
            ?? (locked
                ? 'Fechado'
                : (weightRatio >= 0.9 || volumeRatio >= 0.9 ? 'Lotado' : 'Normal'));

        return {
            id: bag.id ?? `bag-${index}`,
            name: bag.name ?? `Mala ${index + 1}`,
            code: bag.code ?? null,
            capacity,
            used: actualUsed,
            reservedAppliedKg: reservedApplied,
            effectiveUsedKg: effectiveUsed,
            remaining,
            remaining_kg: remaining,
            weightRatio,
            status,
            dimensions: bag.dimensions ?? '—',
            volumeCm3,
            capacityVolumeCm3,
            remainingVolumeCm3,
            reservedVolumeAppliedCm3: reservedVolumeApplied,
            effectiveVolumeCm3,
            volumeRatio,
            locked,
            lockedByWeight,
            lockedByVolume,
            projectedWeightKg: 0,
            projectedVolumeCm3: 0,
        };
    });

    const takeList = decisionStore.resumo.lists.take ?? [];
    const fallbackTakeWeight = takeList.reduce(
        (sum, item) => sum + (Number(item.weight ?? item.weight_kg ?? item.weightKg ?? 0) || 0),
        0,
    );
    const fallbackTakeVolume = takeList.reduce((sum, item) => {
        if (item.volume_cm3 != null) return sum + Number(item.volume_cm3);
        if (item.volume_liters != null) return sum + Number(item.volume_liters) * 1000;
        if (item.dimensions) {
            const parts = item.dimensions
                .split(/[x×]/i)
                .map((part) => parseFloat(part.replace(/[^0-9,.]/g, '').replace(',', '.')))
                .filter((value) => !Number.isNaN(value) && value > 0);
            if (parts.length >= 3) {
                return sum + parts.slice(0, 3).reduce((acc, value) => acc * value, 1);
            }
        }
        return sum;
    }, 0);

    const totalYesWeight = Number(stats.value.yesWeightKg ?? fallbackTakeWeight ?? 0);
    const assignedWeight = baseBags.reduce((sum, bag) => sum + (bag.used ?? 0), 0);
    let weightBacklog = Math.max(totalYesWeight - assignedWeight, 0);

    const totalYesVolume = Number(stats.value.yesVolumeCm3 ?? fallbackTakeVolume ?? 0);
    const assignedVolume = baseBags.reduce((sum, bag) => sum + (bag.volumeCm3 ?? bag.volume_cm3 ?? 0), 0);
    let volumeBacklog = Math.max(totalYesVolume - assignedVolume, 0);

    const adjustedBags = baseBags.map((bag) => {
        if (weightBacklog > 0 && bag.capacity > 0) {
            const available = Math.max(bag.capacity - bag.effectiveUsedKg, 0);
            if (available > 0) {
                const addition = Math.min(weightBacklog, available);
                bag.projectedWeightKg = addition;
                bag.effectiveUsedKg += addition;
                bag.remaining = Math.max(bag.capacity - bag.effectiveUsedKg, 0);
                bag.weightRatio = bag.capacity ? bag.effectiveUsedKg / bag.capacity : bag.weightRatio;
                weightBacklog -= addition;
            }
        }

        if (volumeBacklog > 0 && bag.capacityVolumeCm3) {
            const availableVolume = Math.max(bag.capacityVolumeCm3 - bag.effectiveVolumeCm3, 0);
            if (availableVolume > 0) {
                const addition = Math.min(volumeBacklog, availableVolume);
                bag.projectedVolumeCm3 = addition;
                bag.effectiveVolumeCm3 += addition;
                bag.remainingVolumeCm3 = Math.max(
                    bag.capacityVolumeCm3 - bag.effectiveVolumeCm3,
                    0,
                );
                bag.volumeRatio = bag.capacityVolumeCm3
                    ? bag.effectiveVolumeCm3 / bag.capacityVolumeCm3
                    : bag.volumeRatio;
                volumeBacklog -= addition;
            }
        }

        bag.usedWithProjection = bag.effectiveUsedKg;
        bag.volumeWithProjectionCm3 = bag.effectiveVolumeCm3;
        if (bag.capacityVolumeCm3 != null) {
            bag.remainingVolumeCm3 = Math.max(bag.capacityVolumeCm3 - bag.volumeWithProjectionCm3, 0);
        }

        bag.lockedByWeight = bag.lockedByWeight || (bag.capacity > 0 && bag.effectiveUsedKg >= bag.capacity - epsilon);
        bag.lockedByVolume =
            bag.lockedByVolume ||
            (bag.capacityVolumeCm3 && bag.effectiveVolumeCm3 >= bag.capacityVolumeCm3 - epsilon);
        bag.locked = bag.lockedByWeight || bag.lockedByVolume;

        bag.ratio = Math.max(bag.weightRatio ?? 0, bag.volumeRatio ?? 0);
        bag.remaining_kg = bag.remaining;

        if (bag.locked) {
            bag.status = 'Fechado';
        } else if (bag.weightRatio >= 0.9 || bag.volumeRatio >= 0.9) {
            bag.status = 'Lotado';
        } else {
            bag.status = 'Normal';
        }

        return bag;
    });

    return adjustedBags;
});

const totalCapacityKg = computed(() => (stats.value.totalCapacityKg ?? bagSummaries.value.reduce((sum, bag) => sum + bag.capacity, 0)));
const yesWeightKg = computed(() => (stats.value.yesWeightKg ?? bagSummaries.value.reduce((sum, bag) => sum + (bag.effectiveUsedKg ?? bag.used ?? 0), 0)));
const reservedCapacityKg = computed(() => stats.value.reservedKg ?? 0);
const remainingCapacityKg = computed(() => stats.value.remainingCapacityKg ?? Math.max(totalCapacityKg.value - reservedCapacityKg.value - yesWeightKg.value, 0));

const volumeSummary = computed(() => {
    const summary = stats.value.volumes ?? stats.value.dimensions;
    const bagVolume = (decisionStore.resumo.bags ?? []).reduce((sum, bag) => {
        const parsed = bag.capacity_volume_cm3 ?? bag.capacityVolume_cm3 ?? bag.capacityVolumeCm3 ?? null;
        if (parsed != null) return sum + Number(parsed);
        if (bag.dimensions) {
            const parts = bag.dimensions
                .split(/[x×]/i)
                .map((part) => parseFloat(part.replace(/[^0-9,.]/g, '').replace(',', '.')))
                .filter((value) => !Number.isNaN(value) && value > 0);
            if (parts.length >= 3) {
                return sum + parts.slice(0, 3).reduce((acc, value) => acc * value, 1);
            }
        }
        return sum;
    }, 0);
    if (summary) {
        const usedCm3 = Number(summary.volume_cm3 ?? 0);
        const reservedCm3 = Number(summary.reserved_cm3 ?? 0);
        const capacityCm3 = Number(summary.capacity_cm3 ?? bagVolume ?? 0);
        const availableCm3 = Number(
            summary.available_cm3 ?? capacityCm3 - reservedCm3,
        );
        const remainingCm3 = Number(
            summary.remaining_cm3 ?? availableCm3 - usedCm3,
        );
        const overflowCm3 = Number(
            summary.overflow_cm3 ?? (remainingCm3 < 0 ? Math.abs(remainingCm3) : 0),
        );
        return {
            count: summary.count ?? null,
            volume_cm3: usedCm3,
            volume_liters: Number(summary.volume_liters ?? (usedCm3 ? usedCm3 / 1000 : 0)),
            reserved_cm3: reservedCm3,
            reserved_liters: Number(summary.reserved_liters ?? (reservedCm3 ? reservedCm3 / 1000 : 0)),
            capacity_cm3: capacityCm3,
            capacity_liters: Number(summary.capacity_liters ?? (capacityCm3 ? capacityCm3 / 1000 : 0)),
            available_cm3: availableCm3,
            available_liters: Number(
                summary.available_liters ?? (availableCm3 ? availableCm3 / 1000 : 0),
            ),
            remaining_cm3: remainingCm3,
            remaining_liters: Number(
                summary.remaining_liters ?? (remainingCm3 ? remainingCm3 / 1000 : 0),
            ),
            overflow_cm3: overflowCm3,
            overflow_liters: Number(
                summary.overflow_liters ?? (overflowCm3 ? overflowCm3 / 1000 : 0),
            ),
        };
    }
    if (!bagVolume) return null;
    const usedFromBags = bagSummaries.value.reduce(
        (sum, bag) => sum + (Number(bag.volumeWithProjectionCm3 ?? bag.effectiveVolumeCm3 ?? bag.volumeCm3 ?? 0) || 0),
        0,
    );
    const reserved = bagSummaries.value.reduce(
        (sum, bag) => sum + (Number(bag.reservedVolumeAppliedCm3 ?? 0) || 0),
        0,
    );
    const remaining = Math.max(bagVolume - reserved - usedFromBags, 0);
    return {
        count: null,
        volume_cm3: usedFromBags,
        volume_liters: usedFromBags / 1000,
        reserved_cm3: reserved,
        reserved_liters: reserved / 1000,
        capacity_cm3: bagVolume,
        capacity_liters: bagVolume / 1000,
        available_cm3: bagVolume - reserved,
        available_liters: (bagVolume - reserved) / 1000,
        remaining_cm3: remaining,
        remaining_liters: remaining / 1000,
        overflow_cm3: 0,
        overflow_liters: 0,
    };
});

const volumeStats = computed(() => volumeSummary.value ?? null);
const volumeTotalCapacityCm3 = computed(() =>
    volumeStats.value?.capacity_cm3 ??
    bagSummaries.value.reduce((sum, bag) => sum + (bag.capacityVolumeCm3 ?? 0), 0),
);
const volumeUsedCm3 = computed(() =>
    volumeStats.value?.volume_cm3 ??
    bagSummaries.value.reduce((sum, bag) => sum + (bag.effectiveVolumeCm3 ?? bag.volumeCm3 ?? 0), 0),
);
const volumeReservedCm3 = computed(() =>
    volumeStats.value?.reserved_cm3 ??
    bagSummaries.value.reduce((sum, bag) => sum + (bag.reservedVolumeAppliedCm3 ?? 0), 0),
);

const suitcaseBags = computed(() =>
    bagSummaries.value.map((bag) => {
        const capacityVolumeCm3 = bag.capacityVolumeCm3 != null ? Number(bag.capacityVolumeCm3) : null;
        const actualVolumeCm3 = Number(bag.volumeCm3 ?? bag.volume_cm3 ?? 0);
        const reservedVolumeCm3 = Number(bag.reservedVolumeAppliedCm3 ?? bag.reserved_volume_cm3 ?? 0);
        const projectedVolumeCm3 = Number(bag.projectedVolumeCm3 ?? 0);
        const effectiveVolumeCm3 = Number(
            bag.volumeWithProjectionCm3 ??
                bag.effectiveVolumeCm3 ??
                bag.effective_volume_cm3 ??
                actualVolumeCm3 + projectedVolumeCm3 + reservedVolumeCm3,
        );
        const remainingVolumeCm3 =
            capacityVolumeCm3 != null ? Math.max(capacityVolumeCm3 - effectiveVolumeCm3, 0) : null;

        const actualWeightKg = Number(bag.used ?? bag.yes_kg ?? bag.total_kg ?? 0) || 0;
        const reservedWeightKg = Number(bag.reservedAppliedKg ?? 0);
        const projectedWeightKg = Number(bag.projectedWeightKg ?? 0);
        const effectiveWeightKg = Number(
            bag.usedWithProjection ?? bag.effectiveUsedKg ?? actualWeightKg + projectedWeightKg + reservedWeightKg,
        );
        const remainingWeightKg = Math.max((bag.capacity ?? 0) - effectiveWeightKg, 0);

        return {
            id: bag.id,
            name: bag.name,
            dims: bag.dimensions || '—',
            current: effectiveWeightKg,
            max: bag.capacity,
            volume: {
                current: effectiveVolumeCm3,
                actual: actualVolumeCm3,
                effective: effectiveVolumeCm3,
                reserved: reservedVolumeCm3,
                projected: projectedVolumeCm3,
                capacity: capacityVolumeCm3,
                remaining: remainingVolumeCm3,
            },
            weight: {
                actual: actualWeightKg,
                reserved: reservedWeightKg,
                projected: projectedWeightKg,
                effective: effectiveWeightKg,
                remaining: remainingWeightKg,
            },
            ratio: Math.max(Number(bag.ratio ?? 0), effectiveWeightKg && bag.capacity ? effectiveWeightKg / bag.capacity : 0),
            status: bag.status,
            locked: bag.locked,
            lockedByWeight: bag.lockedByWeight,
            lockedByVolume: bag.lockedByVolume,
        };
    }),
);

const toggleSelection = ({ id, value }) => {
    const set = currentSelection.value;
    if (!set) return;
    if (value) {
        set.add(id);
    } else {
        set.delete(id);
    }
};

const toggleSelectAll = (event) => {
    const set = currentSelection.value;
    if (!set) return;
    const idsOnPage = currentItems.value.map((item) => item.id);
    if (!event.target.checked) {
        idsOnPage.forEach((id) => set.delete(id));
        return;
    }
    idsOnPage.forEach((id) => set.add(id));
};

const clearSelection = (ids) => {
    ['take', 'pending', 'leave'].forEach((key) => {
        ids.forEach((id) => selection[key].delete(id));
    });
};

const clearCurrentSelection = () => {
    currentSelection.value.clear();
};

const pruneSelection = () => {
    const validIds = new Set(filteredItems.value.map((item) => item.id));
    const set = currentSelection.value;
    Array.from(set).forEach((id) => {
        if (!validIds.has(id)) {
            set.delete(id);
        }
    });
};

const pruneAllSelection = () => {
    const decisionByTab = {
        take: 'yes',
        pending: 'pending',
        leave: 'no',
    };
    ['take', 'pending', 'leave'].forEach((key) => {
        const set = selection[key];
        const decisionKey = decisionByTab[key];
        Array.from(set).forEach((id) => {
            const item = decisionStore.itemsMap[id];
            if (!item || item.deleted || (decisionKey && item.decision !== decisionKey)) {
                set.delete(id);
            }
        });
    });
};

const listContainer = ref(null);

const scrollListToTop = ({ window: scrollWindow = false } = {}) => {
    if (listContainer.value) {
        listContainer.value.scrollTo({ top: 0, behavior: 'smooth' });
    }
    if (scrollWindow && typeof window !== 'undefined') {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }
};

const resetFilters = () => {
    searchQuery.value = '';
    selectedBagFilter.value = 'all';
    currentPage.value = 1;
    nextTick(() => scrollListToTop());
};

watch(
    () => currentItems.value.map((item) => item.id),
    () => {
        pruneSelection();
    },
);

watch([allSelected, someSelected], () => {
    if (!selectAllRef.value) return;
    selectAllRef.value.indeterminate = someSelected.value;
});

watch(
    () => allResumoItems.value.map((item) => `${item.id}:${item.decision}:${item.deleted}`),
    () => {
        pruneAllSelection();
    },
);

watch([searchQuery, selectedBagFilter], () => {
    currentPage.value = 1;
    scrollListToTop();
});

watch(pageSize, () => {
    currentPage.value = 1;
    scrollListToTop();
});

watch(activeTab, () => {
    searchQuery.value = '';
    selectedBagFilter.value = 'all';
    currentPage.value = 1;
    scrollListToTop();
});

watch([filteredItems, pageSize], () => {
    if (!totalFilteredCount.value) {
        if (currentPage.value !== 1) {
            currentPage.value = 1;
        }
        return;
    }

    const maxPages = totalPages.value || 1;
    if (currentPage.value > maxPages) {
        currentPage.value = maxPages;
    }
});

watch(currentPage, (value) => {
    if (!totalFilteredCount.value) {
        if (currentPage.value !== 1) {
            currentPage.value = 1;
        }
        return;
    }

    const maxPages = totalPages.value || 1;
    if (value < 1) {
        currentPage.value = 1;
        return;
    }

    if (value > maxPages) {
        currentPage.value = maxPages;
        return;
    }

    scrollListToTop();
});

watch(filteredItems, () => {
    pruneSelection();
});

const ensureUndecided = async (ids) => {
    const toReset = ids.filter((id) => {
        const item = decisionStore.itemsMap[id];
        if (!item) return true;
        const needsDecision = item.decision !== 'undecided';
        const hasBag = Boolean(item.bag_id);
        return needsDecision || hasBag;
    });

    if (!toReset.length) {
        return;
    }

    await decisionStore.decideItems(toReset, 'undecided', { clearBag: true });
};

const handleBulkRequeue = async () => {
    const ids = selectedIds.value;
    if (!ids.length) return;
    try {
        await ensureUndecided(ids);
        await decisionStore.requeueItems(ids);
        await Promise.allSettled([
            decisionStore.fetchResumo(),
            decisionStore.fetchDeck(),
            decisionStore.fetchPack(),
        ]);
        clearSelection(ids);
        toast.success('Itens reinseridos no deck ✅');
    } catch (error) {
        console.error(error);
        toast.error('Não foi possível reinserir os itens ❌');
    }
};

const registerScrollTarget = inject('registerScrollTarget', null);
let unregisterScrollTarget = null;

onMounted(async () => {
    if (!move.value?.id) return;
    try {
        await Promise.all([
            decisionStore.fetchResumo(),
            decisionStore.fetchPack(),
            decisionStore.fetchDeck(),
        ]);
    } catch (error) {
        console.error(error);
        toast.error('Não foi possível carregar o resumo ❌');
    }

    if (registerScrollTarget) {
        unregisterScrollTarget = registerScrollTarget(listContainer);
    }
});

onBeforeUnmount(() => {
    unregisterScrollTarget?.();
});
</script>

<style scoped>
.slide-up-enter-active,
.slide-up-leave-active {
    transition: all 0.2s ease;
}
.slide-up-enter-from,
.slide-up-leave-to {
    opacity: 0;
    transform: translateY(12px);
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
