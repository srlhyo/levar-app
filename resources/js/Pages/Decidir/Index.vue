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
                <div class="flex items-center gap-3 text-xs text-slate-500 sm:text-sm">
                    <button type="button" class="underline-offset-4 hover:underline" @click="setAllGuideSections(true)">Expandir tudo</button>
                    <span class="text-slate-300">•</span>
                    <button type="button" class="underline-offset-4 hover:underline" @click="setAllGuideSections(false)">Recolher tudo</button>
                </div>
            </div>

            <section class="rounded-2xl bg-white/80">
                <button
                    type="button"
                    class="flex w-full items-center justify-between rounded-2xl px-4 py-2 text-left text-sm font-semibold text-slate-700 sm:text-base"
                    @click="toggleGuideSection('guide')"
                >
                    Guia rápido
                    <ChevronDown
                        class="h-4 w-4 transition"
                        :class="guideSections.guide ? 'rotate-180' : ''"
                    />
                </button>
                <transition name="fade">
                    <div v-if="guideSections.guide" class="space-y-2 px-4 pb-3 text-xs text-slate-600 sm:text-sm">
                        <p>Deslize a carta inteira: direita = <strong>Levar</strong>, esquerda = <strong>Não levar</strong>, para baixo = <strong>Pendentes</strong>.</p>
                        <p>Os botões abaixo replicam os gestos e são ideais quando quiser decidir rapidamente sem arrastar.</p>
                        <p>A ação “Desfazer” devolve o último item ao deck em até 6 segundos se algo der errado.</p>
                    </div>
                </transition>
            </section>

            <section class="rounded-2xl bg-white/80">
                <button
                    type="button"
                    class="flex w-full items-center justify-between rounded-2xl px-4 py-2 text-left text-sm font-semibold text-slate-700 sm:text-base"
                    @click="toggleGuideSection('progress')"
                >
                    Progresso do deck
                    <ChevronDown
                        class="h-4 w-4 transition"
                        :class="guideSections.progress ? 'rotate-180' : ''"
                    />
                </button>
                <transition name="fade">
                    <div v-if="guideSections.progress" class="space-y-2 px-4 pb-3 text-xs text-slate-600 sm:text-sm">
                        <div class="flex items-center justify-between font-medium">
                            <span>Restantes na pilha</span>
                            <span>{{ undecidedCount }} / {{ totalCount }}</span>
                        </div>
                        <div class="h-2 rounded-full bg-slate-100">
                            <div class="h-full rounded-full bg-emerald-500 transition-all duration-300" :style="{ width: `${progressPercent}%` }" />
                        </div>
                        <div class="rounded-xl bg-slate-50 px-3 py-2 text-[13px] font-medium text-slate-600 sm:text-sm">
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
                    </div>
                </transition>
            </section>

            <section class="rounded-2xl bg-white/80">
                <button
                    type="button"
                    class="flex w-full items-center justify-between rounded-2xl px-4 py-2 text-left text-sm font-semibold text-slate-700 sm:text-base"
                    @click="toggleGuideSection('legend')"
                >
                    Gestos e botões
                    <ChevronDown
                        class="h-4 w-4 transition"
                        :class="guideSections.legend ? 'rotate-180' : ''"
                    />
                </button>
                <transition name="fade">
                    <div v-if="guideSections.legend" class="space-y-2 px-4 pb-3 text-xs text-slate-600 sm:text-sm">
                        <div class="flex flex-wrap items-center gap-2 rounded-xl bg-white px-3 py-2">
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
                        <p>Deslize a carta inteira ou toque nos botões para classificar. No celular, mantenha o toque firme para arrastar.</p>
                    </div>
                </transition>
            </section>
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

        <div
            v-else-if="currentItem"
            class="flex flex-col items-center gap-8"
        >
            <SwipeCard
                ref="swipeCardRef"
                :item="currentItem"
                :disabled="isProcessing"
                @decision="handleDecision"
            />

            <SwipeActionButtons
                :disabled="isProcessing"
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
                <div
                    class="mx-auto flex max-w-md items-center gap-3 rounded-2xl bg-slate-900/90 px-4 py-3 text-white shadow-2xl ring-1 ring-black/10 sm:max-w-lg select-none touch-pan-y"
                    :style="undoSwipeStyle"
                    @pointerdown="handleUndoPointerDown"
                    @pointermove="handleUndoPointerMove"
                    @pointerup="handleUndoPointerEnd"
                    @pointercancel="handleUndoPointerEnd"
                    @pointerleave="handleUndoPointerEnd"
                >
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
    reactive,
    ref,
    watch,
    watchEffect,
} from 'vue';
import {
    ChevronDown,
    Clock,
    Heart,
    Sparkles,
    Undo2,
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

watchEffect(() => {
    decisionStore.setMove(move.value);
});

const totalCount = computed(() => decisionStore.totalCount);
const processedCount = computed(() => decisionStore.processedCount);
const undecidedCount = computed(() => decisionStore.undecidedCount);
const backlogCount = computed(() => decisionStore.pendingCount);
const progressPercent = computed(() => decisionStore.progressPercent);
const currentItem = computed(() => decisionStore.currentItem);
const bannerProcessedWithPendings = computed(
    () => totalCount.value > 0 && undecidedCount.value === 0 && backlogCount.value > 0,
);

const guideSections = reactive({
    guide: false,
    progress: false,
    legend: false,
});
const setAllGuideSections = (state) => {
    Object.keys(guideSections).forEach((key) => {
        guideSections[key] = state;
    });
};
const toggleGuideSection = (key) => {
    guideSections[key] = !guideSections[key];
};
const isProcessing = ref(false);
const isLoading = ref(true);
const swipeCardRef = ref(null);
const milestoneMessage = ref(null);
const celebrationTimeout = ref(null);
const celebratedMilestones = ref(new Set());
const undoState = ref({ itemId: null, label: '', timer: null });
const undoSwipe = reactive({
    dragging: false,
    startX: 0,
    deltaX: 0,
    source: null,
});

const undoSwipeStyle = computed(() => {
    if (!undoSwipe.dragging && undoSwipe.deltaX === 0) {
        return null;
    }
    return {
        transform: `translateX(${undoSwipe.deltaX}px)`,
        transition: undoSwipe.dragging ? 'none' : 'transform 0.2s ease',
    };
});

const handleDecision = async ({ type, options = {} }) => {
    const active = decisionStore.currentItem;
    if (!active) {
        isProcessing.value = false;
        return;
    }

    try {
        await decisionStore.applyDecision(type, options);

        if (type === 'pending') {
            toast.info('Item adiado ⏳');
        } else if (type === 'yes') {
            toast.success('Marcado para levar 💚');
        } else if (type === 'no') {
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
    undoSwipe.dragging = false;
    undoSwipe.deltaX = 0;
    undoSwipe.source = null;
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

const beginUndoDrag = (clientX, source) => {
    if (!undoState.value.itemId || undoSwipe.dragging) return false;
    undoSwipe.dragging = true;
    undoSwipe.startX = clientX;
    undoSwipe.deltaX = 0;
    undoSwipe.source = source;
    return true;
};

const updateUndoDrag = (clientX, source) => {
    if (!undoSwipe.dragging || undoSwipe.source !== source) return;
    undoSwipe.deltaX = clientX - undoSwipe.startX;
};

const endUndoDrag = (source) => {
    if (!undoSwipe.dragging || undoSwipe.source !== source) return;
    const delta = undoSwipe.deltaX;
    undoSwipe.dragging = false;
    undoSwipe.source = null;
    if (Math.abs(delta) > 80) {
        clearUndoState();
        return;
    }
    undoSwipe.deltaX = 0;
};

const handleUndoPointerDown = (event) => {
    if (event.target?.closest('button')) {
        return;
    }
    if (event.pointerType === 'mouse' && event.button !== 0) return;
    if (!beginUndoDrag(event.clientX, 'pointer')) return;
    event.currentTarget?.setPointerCapture?.(event.pointerId);
};

const handleUndoPointerMove = (event) => {
    updateUndoDrag(event.clientX, 'pointer');
};

const handleUndoPointerEnd = (event) => {
    event.currentTarget?.releasePointerCapture?.(event.pointerId);
    endUndoDrag('pointer');
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
