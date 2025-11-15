<template>
    <Head title="Decidir" />
    <AppLayout>
        <template #title>Decidir</template>
        <template #subtitle>Escolha rapidamente se o item vai, não vai ou fica para decidir depois.</template>

        <transition name="fade">
            <div
                v-if="milestoneMessage"
                class="pointer-events-none fixed inset-0 z-30 flex items-start justify-center pt-24"
                aria-live="assertive"
            >
                <div class="inline-flex items-center gap-3 rounded-3xl bg-white/90 px-5 py-3 text-emerald-700 shadow-2xl ring-1 ring-emerald-200/70">
                    <Sparkles class="h-5 w-5 text-emerald-500" />
                    <p class="text-base font-semibold">{{ milestoneMessage }}</p>
                </div>
            </div>
        </transition>

        <Card tone="green" class="space-y-4">
            <div class="flex flex-wrap items-center justify-between gap-3">
                <div>
                    <p class="text-base font-semibold text-slate-900">Como decidir</p>
                    <p class="text-sm text-slate-600">Arraste a carta ou use os botões abaixo para classificar cada item.</p>
                </div>
                <button
                    type="button"
                    class="inline-flex items-center gap-2 rounded-full bg-white/80 px-3 py-1 text-xs font-semibold text-slate-700 ring-1 ring-black/5 transition hover:bg-white focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-300"
                    @click="showDecidirHelp = !showDecidirHelp"
                    :aria-expanded="showDecidirHelp ? 'true' : 'false'"
                >
                    <span class="inline-flex h-5 w-5 items-center justify-center rounded-full bg-emerald-500/15 text-[11px] font-semibold text-emerald-600">?</span>
                    Como funciona
                </button>
            </div>
            <transition name="fade">
                <div
                    v-if="showDecidirHelp"
                    class="space-y-3 rounded-2xl bg-white/80 px-4 py-3 text-xs text-slate-600 ring-1 ring-black/5 sm:text-sm"
                >
                    <p class="font-semibold text-slate-800">Como aproveitar o deck</p>
                    <ul class="list-disc space-y-1.5 pl-5">
                        <li>Deslize a carta inteira: direita = <strong>Levar</strong>, esquerda = <strong>Não levar</strong>, para baixo = <strong>Pendentes</strong>. Os botões replicam os gestos.</li>
                        <li>Use os atalhos inteligentes para despachar direto para uma mala ou guardar o item; eles respeitam travas de peso/volume.</li>
                        <li>Ative o feedback tátil para sentir cada decisão e toque no ícone da foto para ampliá-la antes de decidir.</li>
                        <li>A barra “Na fila” mostra os próximos itens e o botão “Desfazer” devolve a última carta ao deck em até 6 segundos.</li>
                        <li>Se a pilha zerar, visite o Resumo para reinsira pendentes ou revisar as malas antes de continuar.</li>
                    </ul>
                </div>
            </transition>
            <div class="flex items-center justify-between text-sm font-medium text-slate-600">
                <span>Restantes na pilha</span>
                <span>{{ undecidedCount }} / {{ totalCount }}</span>
            </div>
            <div class="h-2 rounded-full bg-white/60">
                <div class="h-full rounded-full bg-emerald-500 transition-all duration-300" :style="{ width: `${progressPercent}%` }" />
            </div>
            <div class="rounded-2xl bg-white/70 px-4 py-2 text-xs font-medium text-slate-600 sm:text-sm">
                <div class="flex flex-col gap-1 sm:flex-row sm:items-center sm:justify-between">
                    <span class="inline-flex items-center gap-1">
                        <span class="font-semibold text-emerald-600">{{ progressPercent }}%</span>
                        concluído
                    </span>
                    <span class="inline-flex items-center gap-1 text-slate-500">
                        Processados: <span class="font-semibold text-slate-700">{{ processedCount }}</span> / {{ totalCount }}
                    </span>
                    <span
                        v-if="backlogCount"
                        class="inline-flex items-center gap-1 text-amber-600"
                    >
                        Fila pendente: <span class="font-semibold">{{ backlogCount }}</span>
                    </span>
                </div>
            </div>
            <div class="flex flex-wrap items-center gap-2 rounded-2xl bg-white/60 px-4 py-2 text-xs text-slate-600 sm:text-sm">
                <span class="inline-flex items-center gap-1 rounded-full bg-rose-100 px-2 py-1 text-rose-600">
                    <X class="h-4 w-4" />
                    Não levar
                </span>
                <span class="inline-flex items-center gap-1 rounded-full bg-slate-100 px-2 py-1 text-slate-700">
                    <Clock class="h-4 w-4" />
                    Decidir depois
                </span>
                <span class="inline-flex items-center gap-1 rounded-full bg-emerald-100 px-2 py-1 text-emerald-600">
                    <Heart class="h-4 w-4" />
                    Levar
                </span>
            </div>
            <p class="text-xs text-slate-600 sm:text-sm">
                Deslize a carta inteira ou toque nos botões para classificar. No celular, mantenha o toque firme para arrastar.
            </p>
            <div class="flex justify-end">
                <button
                    type="button"
                    class="inline-flex items-center gap-2 rounded-full border border-slate-200/70 bg-white/80 px-4 py-1.5 text-xs font-semibold text-slate-700 shadow-sm transition hover:border-emerald-200 hover:bg-white focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-300 sm:text-sm"
                    @click="toggleHaptics"
                >
                    <Vibrate class="h-4 w-4" />
                    <span>{{ hapticsEnabled ? 'Feedback tátil ligado' : 'Ativar feedback tátil' }}</span>
                    <span
                        class="h-2 w-2 rounded-full"
                        :class="hapticsEnabled ? 'bg-emerald-500 shadow-[0_0_0_4px_rgba(16,185,129,0.2)]' : 'bg-slate-400'"
                        aria-hidden="true"
                    />
                </button>
            </div>
        </Card>

        <div v-if="isLoading" class="flex flex-col items-center gap-6">
            <div class="w-[90%] max-w-md animate-pulse rounded-3xl bg-white/50 p-8 sm:max-w-lg">
                <div class="h-64 rounded-2xl bg-slate-200/60" />
                <div class="mt-6 space-y-3">
                    <div class="h-4 w-3/4 rounded bg-slate-200/80" />
                    <div class="h-3 w-full rounded bg-slate-200/70" />
                    <div class="h-3 w-2/3 rounded bg-slate-200/70" />
                </div>
            </div>
            <div class="flex w-full max-w-md gap-3 opacity-60 sm:max-w-lg">
                <div class="h-14 flex-1 rounded-full bg-white/40" />
                <div class="h-14 flex-1 rounded-full bg-white/40" />
                <div class="h-14 flex-1 rounded-full bg-white/40" />
            </div>
        </div>

        <div v-else-if="currentItem" class="flex flex-col items-center gap-8">
            <SwipeCard
                ref="swipeCardRef"
                :item="currentItem"
                :disabled="isProcessing"
                @decision="handleDecision"
            />

            <div v-if="upcomingCards.length" class="w-full max-w-md text-left sm:max-w-lg">
                <p class="mb-2 text-xs font-semibold uppercase tracking-wide text-slate-500">Na fila</p>
                <div class="flex gap-3 overflow-x-auto pb-1">
                    <div
                        v-for="item in upcomingCards"
                        :key="item.id"
                        class="min-w-[11rem] shrink-0 rounded-2xl border border-slate-200/70 bg-white/80 px-3 py-2 shadow-sm"
                    >
                        <p class="line-clamp-2 text-sm font-semibold text-slate-800">{{ item.title ?? item.name }}</p>
                        <p class="text-xs text-slate-500">
                            {{ item.category ? formatCategory(item.category) : 'Item catalogado' }}
                        </p>
                    </div>
                </div>
            </div>

            <SwipeActionButtons
                :disabled="isProcessing"
                :quick-actions="quickActions"
                @decide="requestDecision"
            />
        </div>

        <Card
            v-else-if="bannerProcessedWithPendings"
            tone="slate"
            class="space-y-4 text-left sm:text-center"
        >
            <div class="text-3xl sm:text-4xl">🗂️</div>
            <div class="space-y-2">
                <p class="text-base font-semibold text-slate-800">Há itens pendentes para decidir</p>
                <p class="text-sm text-slate-600">
                    Revise no Resumo e reinsira os pendentes no deck para decidir.
                </p>
            </div>
            <div class="flex flex-col gap-2 sm:flex-row sm:justify-center">
                <button
                    type="button"
                    class="inline-flex items-center justify-center gap-2 rounded-full bg-emerald-500 px-4 py-2 text-sm font-semibold text-white shadow transition hover:bg-emerald-400 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-300"
                    @click="goToResumo"
                >
                    Ir para Resumo
                </button>
            </div>
        </Card>

        <Card v-else tone="slate" class="space-y-3 text-center">
            <div class="text-4xl">🎉</div>
            <p class="text-base font-semibold text-slate-700">Todos os itens foram processados.</p>
            <p class="text-sm text-slate-500">Você pode revisar o resumo para ver os totais.</p>
        </Card>

        <transition name="slide-up">
            <div v-if="undoState.itemId" class="fixed inset-x-0 bottom-4 z-40 px-4 sm:bottom-6">
                <div class="mx-auto flex max-w-md items-center gap-3 rounded-2xl bg-slate-900/90 px-4 py-3 text-white shadow-2xl ring-1 ring-black/10 sm:max-w-lg">
                    <div class="flex-1">
                        <p class="text-sm font-semibold">{{ undoState.label }}</p>
                        <p class="text-xs text-slate-300">Toque para desfazer em até 6 segundos</p>
                    </div>
                    <button
                        type="button"
                        class="inline-flex items-center gap-1 rounded-full bg-white/10 px-3 py-1.5 text-sm font-semibold text-white transition hover:bg-white/20 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-white/60"
                        @click="undoLastDecision"
                    >
                        <Undo2 class="h-4 w-4" />
                        Desfazer
                    </button>
                </div>
            </div>
        </transition>

    </AppLayout>
</template>

<script setup>
import { Head, router, usePage } from '@inertiajs/vue3';
import { route } from 'ziggy-js';
import {
    computed,
    nextTick,
    onBeforeUnmount,
    onMounted,
    ref,
    watch,
    watchEffect,
} from 'vue';
import {
    Clock,
    Heart,
    Sparkles,
    Undo2,
    Vibrate,
    X,
} from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import Card from '@/Components/Card.vue';
import SwipeCard from '@/Components/SwipeCard.vue';
import SwipeActionButtons from '@/Components/SwipeActionButtons.vue';
import { useDecisionStore } from '@/stores/decision';
import { toast } from '@/utils/toast';

const page = usePage();
const decisionStore = useDecisionStore();

const move = computed(() => page.props.move ?? null);
const moveBags = computed(() => move.value?.bags ?? []);

watchEffect(() => {
    decisionStore.setMove(move.value);
});

const totalCount = computed(() => decisionStore.totalCount);
const processedCount = computed(() => decisionStore.processedCount);
const undecidedCount = computed(() => decisionStore.undecidedCount);
const backlogCount = computed(() => decisionStore.pendingCount);
const progressPercent = computed(() => decisionStore.progressPercent);
const currentItem = computed(() => decisionStore.currentItem);
const upcomingCards = computed(() => decisionStore.deck.slice(1, 3));
const bannerProcessedWithPendings = computed(
    () => totalCount.value > 0 && undecidedCount.value === 0 && backlogCount.value > 0,
);

const showDecidirHelp = ref(false);
const isProcessing = ref(false);
const isLoading = ref(true);
const swipeCardRef = ref(null);
const hapticsEnabled = ref(true);
const milestoneMessage = ref(null);
const celebrationTimeout = ref(null);
const celebratedMilestones = ref(new Set());
const undoState = ref({ itemId: null, label: '', timer: null });

const formatBagDescription = (bag) => {
    const remaining = [bag?.remaining_kg, bag?.remaining_weight, bag?.remaining_weight_kg].find(
        (value) => typeof value === 'number' && Number.isFinite(value),
    );
    if (remaining != null) {
        return `${remaining.toFixed(1)} kg livres`;
    }

    const capacity = [bag?.capacity_kg, bag?.max_weight, bag?.limit_kg].find(
        (value) => typeof value === 'number' && Number.isFinite(value),
    );
    if (capacity != null) {
        return `${capacity.toFixed(1)} kg máx.`;
    }

    return 'Enviar para a mala';
};

const availableBags = computed(() => {
    if (Array.isArray(moveBags.value) && moveBags.value.length > 0) {
        return moveBags.value;
    }
    if (Array.isArray(decisionStore.bags) && decisionStore.bags.length > 0) {
        return decisionStore.bags;
    }
    return [];
});

const quickActions = computed(() => {
    const actions = [];
    if (availableBags.value.length) {
        const bagActions = availableBags.value.slice(0, 3).map((bag) => {
            const code = bag?.code ?? bag?.slug ?? bag?.id ?? null;
            return {
                key: `bag-${code ?? bag?.id}`,
                label: bag?.name || `Mala ${String(code ?? '').toUpperCase()}`,
                description: formatBagDescription(bag),
                name: 'yes',
                options: code ? { bag: code } : {},
                intent: bag?.locked ? 'warning' : 'default',
            };
        });
        actions.push(...bagActions);
    }

    actions.push({
        key: 'action-pending',
        label: 'Guardar',
        description: 'Mover para pendentes',
        name: 'pending',
        options: {},
        intent: 'warning',
    });

    return actions;
});

const vibrate = (pattern) => {
    if (!hapticsEnabled.value) return;
    if (typeof navigator !== 'undefined' && 'vibrate' in navigator) {
        navigator.vibrate(pattern);
    }
};

const handleDecision = async ({ type, options = {} }) => {
    const active = decisionStore.currentItem;
    if (!active) {
        isProcessing.value = false;
        return;
    }

    try {
        await decisionStore.applyDecision(type, options);

        if (type === 'pending') {
            vibrate([0, 30, 30, 30]);
            toast.info('Item adiado ⏳');
        } else if (type === 'yes') {
            vibrate(25);
            toast.success('Marcado para levar 💚');
        } else if (type === 'no') {
            vibrate([0, 20, 80, 20]);
            toast.info('Marcado como não levar ❌');
        }
        setUndoState(active.id, formatDecisionLabel(type, options));
    } catch (error) {
        console.error(error);
        toast.error('Não foi possível atualizar o item ❌');
    } finally {
        nextTick(() => {
            isProcessing.value = false;
        });
    }
};

const requestDecision = (type, options = {}) => {
    if (!currentItem.value || isProcessing.value) return;
    isProcessing.value = true;
    swipeCardRef.value?.triggerDecision(type, options);
};

const goToResumo = () => {
    const destination = route ? route('resumo.index') : '/resumo';
    router.visit(destination);
};

const toggleHaptics = () => {
    hapticsEnabled.value = !hapticsEnabled.value;
    if (typeof window !== 'undefined') {
        window.localStorage.setItem('decidir_haptics', JSON.stringify(hapticsEnabled.value));
    }
};

const formatDecisionLabel = (type, options) => {
    const base = {
        yes: 'Levar',
        no: 'Não levar',
        pending: 'Decidir depois',
    }[type] ?? 'Decisão aplicada';

    if (type === 'yes' && options?.bag) {
        return `${base} • Mala ${String(options.bag).toUpperCase()}`;
    }

    return base;
};

const setUndoState = (itemId, label) => {
    clearUndoState();
    const timer = typeof window !== 'undefined'
        ? window.setTimeout(() => {
            clearUndoState();
        }, 6000)
        : null;

    undoState.value = { itemId, label, timer };
};

const clearUndoState = () => {
    if (undoState.value?.timer && typeof window !== 'undefined') {
        window.clearTimeout(undoState.value.timer);
    }
    undoState.value = { itemId: null, label: '', timer: null };
};

const undoLastDecision = async () => {
    if (!undoState.value.itemId) return;
    try {
        await decisionStore.decideItems([undoState.value.itemId], 'undecided', { clearBag: true });
        await decisionStore.fetchDeck();
        toast.success('Item voltou ao deck ↩️');
    } catch (error) {
        console.error(error);
        toast.error('Não foi possível desfazer ❌');
    } finally {
        clearUndoState();
    }
};

const loadDeck = async () => {
    if (!move.value?.id) {
        isLoading.value = false;
        return;
    }
    isLoading.value = true;
    try {
        await decisionStore.fetchDeck();
    } catch (error) {
        console.error(error);
        toast.error('Não foi possível carregar os itens ❌');
    } finally {
        isLoading.value = false;
    }
};

const hydratePreferences = () => {
    if (typeof window === 'undefined') return;
    const storedHaptics = window.localStorage.getItem('decidir_haptics');
    if (storedHaptics !== null) {
        hapticsEnabled.value = storedHaptics === 'true';
    }
};

const handleMilestones = (value) => {
    const thresholds = [25, 50, 75, 100];
    thresholds.forEach((threshold) => {
        if (value >= threshold && !celebratedMilestones.value.has(threshold)) {
            celebratedMilestones.value.add(threshold);
            triggerCelebration(threshold);
        }
    });
};

const triggerCelebration = (threshold) => {
    milestoneMessage.value = `Você concluiu ${threshold}%!`;
    if (celebrationTimeout.value && typeof window !== 'undefined') {
        window.clearTimeout(celebrationTimeout.value);
    }
    celebrationTimeout.value = typeof window !== 'undefined'
        ? window.setTimeout(() => {
            milestoneMessage.value = null;
        }, 2200)
        : null;
};

onMounted(() => {
    hydratePreferences();
    loadDeck();
});

onBeforeUnmount(() => {
    if (celebrationTimeout.value && typeof window !== 'undefined') {
        window.clearTimeout(celebrationTimeout.value);
    }
    clearUndoState();
});

watch(
    () => move.value?.id,
    (newId, oldId) => {
        if (newId && newId !== oldId) {
            loadDeck();
        }
    },
);

watch(progressPercent, (value) => {
    handleMilestones(value);
});

const formatCategory = (value) => {
    if (!value) return '';
    return String(value)
        .replace(/_/g, ' ')
        .replace(/\b\w/g, (char) => char.toUpperCase());
};
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
    transition: opacity 0.2s ease;
}
.fade-enter-from,
.fade-leave-to {
    opacity: 0;
}
.slide-up-enter-active,
.slide-up-leave-active {
    transition: opacity 0.25s ease, transform 0.25s ease;
}
.slide-up-enter-from,
.slide-up-leave-to {
    opacity: 0;
    transform: translateY(10px);
}
</style>
