<template>
    <Head title="Resumo" />
    <AppLayout>
        <template #title>Resumo</template>
        <template #subtitle>Uma visão geral das malas, pendências e itens que vão com a gente.</template>

        <Card tone="slate">
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
                    <p class="text-xs uppercase tracking-wide text-slate-600">Pendentes</p>
                    <p class="text-2xl font-semibold text-sky-600">{{ stats.pending }}</p>
                </div>
                <div class="space-y-1">
                    <p class="text-xs uppercase tracking-wide text-slate-600">Indefinidos</p>
                    <p class="text-2xl font-semibold text-slate-600">{{ stats.undecided }}</p>
                </div>
            </div>
            <div class="mt-4 grid gap-4 sm:grid-cols-3">
                <div class="rounded-2xl bg-white/70 px-4 py-3 text-xs font-medium text-slate-600 ring-1 ring-white/40">
                    Total catalogado: <span class="font-semibold text-slate-900">{{ stats.total }}</span>
                </div>
                <div class="rounded-2xl bg-white/70 px-4 py-3 text-xs font-medium text-slate-600 ring-1 ring-white/40">
                    Processados: <span class="font-semibold text-slate-900">{{ stats.decided }}</span>
                </div>
                <div class="rounded-2xl bg-white/70 px-4 py-3 text-xs font-medium text-slate-600 ring-1 ring-white/40">
                    Restantes: <span class="font-semibold text-slate-900">{{ stats.remaining }}</span>
                </div>
            </div>
        </Card>

        <Card tone="slate" class="space-y-6">
            <WeightBar
                :total-kg="stats.totalWeight"
                :bag-a-used="stats.weightA"
                :bag-b-used="stats.weightB"
                :reserved-kg="stats.reservedKg"
            />
            <div class="flex flex-col gap-6 sm:flex-row">
                <Suitcase
                    v-for="bag in bags"
                    :key="bag.id"
                    class="flex-1"
                    :name="bag.name"
                    :dims="bag.dims"
                    :current="bag.current"
                    :max="bag.max"
                    :ratio="bag.ratio"
                    :status="bag.status"
                />
            </div>
        </Card>

        <Card tone="slate" class="space-y-4">
            <div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
                <div>
                    <p class="text-base font-semibold text-slate-900">Exportar planilha</p>
                    <p class="text-sm text-slate-600">
                        Gera CSV com os itens marcados como levar, malas e status de embalagem.
                    </p>
                </div>
                <button
                    type="button"
                    class="inline-flex items-center gap-2 rounded-2xl bg-slate-900 px-4 py-2 text-sm font-semibold text-white shadow hover:bg-slate-800 disabled:cursor-not-allowed disabled:bg-slate-400 disabled:text-white/80"
                    :disabled="exportDisabled"
                    :title="exportDisabled ? exportTooltip : ''"
                    @click="handleExport"
                >
                    <Download class="h-4 w-4" />
                    Exportar CSV
                </button>
            </div>
            <p v-if="exportDisabled" class="text-xs text-slate-500">
                {{ exportTooltip }}
            </p>
        </Card>

        <Card tone="slate" class="space-y-5">
            <div>
                <p class="text-base font-semibold text-slate-900">Itens por decisão</p>
                <p class="text-sm text-slate-600">
                    Navegue pelos itens marcados como levar, pendentes ou não levar.
                </p>
            </div>

            <Tabs v-model="activeTab" :items="tabItems">
                <div v-if="currentItems.length" class="mt-4 space-y-4">
                    <div class="flex items-center justify-between rounded-2xl bg-white/70 px-4 py-2 text-sm text-slate-600 ring-1 ring-white/40">
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
                        <span v-if="selectedCount" class="text-xs font-medium text-slate-500">
                            {{ selectedCount }} selecionado(s)
                        </span>
                    </div>

                    <div class="space-y-3">
                        <ItemRow
                            v-for="item in currentItems"
                            :key="item.id"
                            :item="item"
                            :selected="currentSelection.has(item.id)"
                            @toggle-select="toggleSelection"
                            @requeue="handleRowRequeue"
                            @delete="handleRowDelete"
                        />
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
                                    ↩ Reinserir no deck
                                </button>
                                <button
                                    type="button"
                                    class="inline-flex items-center justify-center gap-2 rounded-full bg-rose-500/90 px-4 py-2 text-sm font-semibold text-white shadow transition hover:bg-rose-500 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-rose-300"
                                    @click="handleBulkDelete"
                                >
                                    🗑 Enviar para Reciclagem
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

        <Toast v-model="toastOpen" :message="toastMessage" />

        <teleport to="body">
            <transition name="fade">
                <div
                    v-if="undo.visible"
                    class="fixed bottom-16 right-4 z-[9999] max-w-xs sm:bottom-6"
                >
                    <ToastUndo :message="undo.message" :duration="undo.duration" @undo="handleUndo" />
                </div>
            </transition>
            <transition name="fade">
                <div
                    v-if="confirm.open"
                    class="fixed inset-0 z-[10000] flex items-end justify-center bg-slate-900/40 px-4 pb-10 sm:items-center"
                    role="dialog"
                    aria-modal="true"
                >
                    <div class="w-full max-w-sm space-y-4 rounded-3xl bg-white p-6 text-slate-700 shadow-xl">
                        <div class="space-y-2">
                            <p class="text-lg font-semibold text-slate-900">Enviar para a Reciclagem?</p>
                            <p class="text-sm text-slate-600">Você poderá restaurar depois.</p>
                        </div>
                        <div class="flex flex-col gap-2 sm:flex-row sm:justify-end">
                            <button
                                type="button"
                                class="inline-flex items-center justify-center rounded-full bg-white px-4 py-2 text-sm font-semibold text-slate-700 ring-1 ring-black/5 transition hover:bg-slate-100 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-400"
                                @click="closeConfirm"
                            >
                                Cancelar
                            </button>
                            <button
                                type="button"
                                class="inline-flex items-center justify-center rounded-full bg-rose-500 px-4 py-2 text-sm font-semibold text-white shadow transition hover:bg-rose-400 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-rose-300"
                                @click="confirmDelete"
                            >
                                Enviar
                            </button>
                        </div>
                    </div>
                </div>
            </transition>
        </teleport>

        <div
            v-if="DEV"
            class="fixed bottom-4 left-4 z-[9998] flex items-center gap-2 rounded-xl bg-white/90 px-3 py-2 text-xs font-semibold text-slate-600 shadow ring-1 ring-black/5 backdrop-blur"
        >
            <span class="text-[0.65rem] uppercase tracking-wider text-slate-400">DEV</span>
            <button
                type="button"
                class="rounded-full bg-emerald-500 px-3 py-1 text-white shadow hover:bg-emerald-400 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-300"
                @click="handleDevSeed"
            >
                Seed
            </button>
            <button
                type="button"
                class="rounded-full bg-slate-200 px-3 py-1 text-slate-700 shadow hover:bg-slate-300 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-400"
                @click="handleDevClear"
            >
                Clear
            </button>
        </div>
    </AppLayout>
</template>

<script setup>
import { Head, router, usePage } from '@inertiajs/vue3';
import { computed, nextTick, onBeforeUnmount, onMounted, reactive, ref, watch } from 'vue';
import { Download } from 'lucide-vue-next';
import { route } from 'ziggy-js';
import AppLayout from '@/Layouts/AppLayout.vue';
import Card from '@/Components/Card.vue';
import WeightBar from '@/Components/WeightBar.vue';
import Tabs from '@/Components/Tabs.vue';
import ItemRow from '@/Components/ItemRow.vue';
import Toast from '@/Components/Toast.vue';
import ToastUndo from '@/Components/ToastUndo.vue';
import Suitcase from '@/Components/Suitcase.vue';
import { useDecisionStore } from '@/stores/decision';
import { toast } from '@/utils/toast';

const DEV = import.meta.env.DEV;
const decisionStore = useDecisionStore();
const page = usePage();

const hydrateStore = async () => {
    const shouldSeed = DEV && page.url.includes('seed=1');
    if (shouldSeed) {
        await decisionStore.forceSeed();
    } else {
        await decisionStore.loadMockData();
        decisionStore.initialize();
    }
    if (DEV) {
        console.info('[resumo] store state', {
            items: decisionStore.items.length,
            queue: decisionStore.queue.length,
        });
        console.info('[resumo] lists', {
            take: decisionStore.takeList.length,
            pending: decisionStore.pendingList.length,
            leave: decisionStore.leaveList.length,
        });
    }
};

onMounted(async () => {
    await hydrateStore();
});

const activeTab = ref('take');
const selectAllRef = ref(null);

const selection = reactive({
    take: new Set(),
    pending: new Set(),
    leave: new Set(),
});

const takeItems = computed(() => decisionStore.takeList);
const pendingItems = computed(() => decisionStore.pendingList);
const leaveItems = computed(() => decisionStore.leaveList);

const tabItems = computed(() => [
    { key: 'take', label: 'Levar', badge: decisionStore.yesCount },
    { key: 'pending', label: 'Pendentes', badge: decisionStore.pendingCount },
    { key: 'leave', label: 'Não levar', badge: decisionStore.noCount },
]);

const listsByTab = computed(() => ({
    take: takeItems.value,
    pending: pendingItems.value,
    leave: leaveItems.value,
}));

const currentItems = computed(() => listsByTab.value[activeTab.value] ?? []);
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

const stats = computed(() => {
    const allItems = decisionStore.items.filter((item) => !item.deleted);
    const total = allItems.length;
    const pending = decisionStore.pendingCount;
    const leave = decisionStore.noCount;
    const take = decisionStore.yesCount;
    const undecided = decisionStore.undecidedCount;
    const packed = allItems.filter((item) => item.packed).length;
    const luggageAItems = allItems.filter((item) => item.bag === 'A');
    const luggageBItems = allItems.filter((item) => item.bag === 'B');
    const weightA = luggageAItems.reduce((sum, item) => sum + (item.weight ?? 0), 0);
    const weightB = luggageBItems.reduce((sum, item) => sum + (item.weight ?? 0), 0);
    const totalWeight = allItems.reduce((sum, item) => sum + (item.weight ?? 0), 0);
    const reservedKg = 4;
    const decided = take + leave;
    const remaining = Math.max(total - decided - pending, 0);
    return {
        total,
        pending,
        take,
        leave,
        undecided,
        packed,
        luggageA: luggageAItems.length,
        luggageB: luggageBItems.length,
        weightA,
        weightB,
        totalWeight,
        reservedKg,
        decided,
        remaining,
    };
});

const bags = computed(() => {
    const definitions = [
        {
            id: 'A',
            name: 'Mala A',
            dims: '78 × 50 × 30 cm',
            current: stats.value.weightA,
            max: 23,
        },
        {
            id: 'B',
            name: 'Mala B',
            dims: '78 × 50 × 30 cm',
            current: stats.value.weightB,
            max: 23,
        },
    ];

    return definitions.map((bag) => {
        const rawRatio = bag.max ? bag.current / bag.max : 0;
        const clampedRatio = Math.max(0, Math.min(rawRatio, 1));
        let status = 'Normal';
        if (rawRatio >= 0.9 && rawRatio <= 1) status = 'Lotado';
        if (rawRatio > 1) status = 'Fechado';

        return {
            ...bag,
            ratio: clampedRatio,
            status,
        };
    });
});

const hasBlockingDecisions = computed(() => stats.value.pending > 0 || stats.value.undecided > 0);
const exportDisabled = computed(() => stats.value.take === 0 || hasBlockingDecisions.value);
const exportTooltip = computed(() => {
    if (hasBlockingDecisions.value) return 'Termine as decisões para exportar';
    if (stats.value.take === 0) return 'Nenhum item marcado para levar';
    return '';
});

const toastOpen = ref(false);
const toastMessage = ref('');

const showToast = (message) => {
    toastMessage.value = message;
    toastOpen.value = false;
    nextTick(() => {
        toastOpen.value = true;
    });
};

const undo = reactive({
    visible: false,
    ids: [],
    timer: null,
    duration: 10000,
    message: 'Itens enviados para a Reciclagem 🗑',
});

const confirm = reactive({
    open: false,
    ids: [],
});

let redirectTimer = null;

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
    set.clear();
    if (event.target.checked) {
        currentItems.value.forEach((item) => set.add(item.id));
    }
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
    const validIds = new Set(currentItems.value.map((item) => item.id));
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
    () => decisionStore.items.map((item) => `${item.id}:${item.decision}:${item.deleted}`),
    () => {
        pruneAllSelection();
    },
);

const handleExport = () => {
    if (exportDisabled.value) return;
    toast.success('Export gerado! (mock)');
};

const handleRowRequeue = (id) => {
    decisionStore.requeueItems([id]);
    clearSelection([id]);
    showToast('Item reinserido no deck ✅');
};

const handleBulkRequeue = () => {
    const ids = selectedIds.value;
    if (!ids.length) return;
    decisionStore.requeueItems(ids);
    clearSelection(ids);
    showToast('Itens reinseridos no deck ✅');
    const destination = route ? route('decidir.index') : '/decidir';
    if (redirectTimer) {
        window.clearTimeout(redirectTimer);
    }
    redirectTimer = window.setTimeout(() => {
        router.visit(destination);
    }, 600);
};

const openConfirm = (ids) => {
    if (!ids.length) return;
    confirm.ids = ids;
    confirm.open = true;
};

const closeConfirm = () => {
    confirm.open = false;
    confirm.ids = [];
};

const startUndo = (ids) => {
    undo.ids = ids;
    undo.visible = true;
    if (undo.timer) {
        window.clearTimeout(undo.timer);
    }
    undo.timer = window.setTimeout(() => {
        undo.visible = false;
        undo.ids = [];
        undo.timer = null;
    }, undo.duration);
};

const confirmDelete = () => {
    if (!confirm.ids.length) return;
    decisionStore.softDeleteItems(confirm.ids);
    clearSelection(confirm.ids);
    showToast(confirm.ids.length > 1 ? 'Itens enviados para a Reciclagem 🗑' : 'Item enviado para a Reciclagem 🗑');
    startUndo(confirm.ids.slice());
    closeConfirm();
};

const handleRowDelete = (id) => {
    openConfirm([id]);
};

const handleBulkDelete = () => {
    openConfirm(selectedIds.value);
};

const handleUndo = () => {
    if (!undo.ids.length) return;
    decisionStore.restoreItems(undo.ids);
    undo.visible = false;
    if (undo.timer) {
        window.clearTimeout(undo.timer);
        undo.timer = null;
    }
    showToast('Itens restaurados ✅');
};

const handleDevSeed = async () => {
    await decisionStore.forceSeed();
    selection.take.clear();
    selection.pending.clear();
    selection.leave.clear();
    showToast('Mock reimportado ✅');
};

const handleDevClear = () => {
    decisionStore.resetAll();
    selection.take.clear();
    selection.pending.clear();
    selection.leave.clear();
    showToast('Mock limpo ♻️');
};

onBeforeUnmount(() => {
    if (undo.timer) {
        window.clearTimeout(undo.timer);
    }
    if (redirectTimer) {
        window.clearTimeout(redirectTimer);
    }
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
