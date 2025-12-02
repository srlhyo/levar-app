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

        <section class="decidir-panel">
            <div class="decidir-panel__head">
                <div class="decidir-panel__title-block">
                    <TileIcon3D tone="indigo" class="decidir-panel__icon">
                        <Sparkles class="h-5 w-5" />
                    </TileIcon3D>
                    <div>
                        <p class="decidir-eyebrow">Fluxo guiado</p>
                        <h2 class="decidir-panel__title">Como decidir</h2>
                        <p class="decidir-panel__subtitle">Arraste a carta ou use os botões abaixo para classificar cada item.</p>
                    </div>
                </div>
                <div class="decidir-panel__actions">
                    <button type="button" class="decidir-panel__link" @click="setAllGuideSections(true)">Expandir tudo</button>
                    <span aria-hidden="true" class="decidir-panel__divider">•</span>
                    <button type="button" class="decidir-panel__link" @click="setAllGuideSections(false)">Recolher tudo</button>
                </div>
            </div>

            <div class="decidir-accordion-group">
                <article class="decidir-accordion">
                    <button
                        type="button"
                        class="decidir-accordion__trigger"
                        @click="toggleGuideSection('guide')"
                    >
                        <div class="flex items-center gap-3">
                            <TileIcon3D tone="indigo" class="decidir-accordion__icon">
                                <BookOpenCheck class="h-4 w-4" />
                            </TileIcon3D>
                            <span>Guia rápido</span>
                        </div>
                        <ChevronDown
                            class="h-4 w-4 transition"
                            :class="guideSections.guide ? 'rotate-180' : ''"
                        />
                    </button>
                    <transition name="fade">
                        <div v-if="guideSections.guide" class="decidir-accordion__body">
                            <p>Deslize a carta inteira: direita = <strong>Levar</strong>, esquerda = <strong>Não levar</strong>, para baixo = <strong>Pendentes</strong>.</p>
                            <p>Os botões abaixo replicam os gestos e são ideais quando quiser decidir rapidamente sem arrastar.</p>
                            <p>A ação “Desfazer” devolve o último item ao deck em até 6 segundos se algo der errado.</p>
                        </div>
                    </transition>
                </article>

                <article class="decidir-accordion">
                    <button
                        type="button"
                        class="decidir-accordion__trigger"
                        @click="toggleGuideSection('progress')"
                    >
                        <div class="flex items-center gap-3">
                            <TileIcon3D tone="indigo" class="decidir-accordion__icon">
                                <BarChart3 class="h-4 w-4" />
                            </TileIcon3D>
                            <span>Progresso do deck</span>
                        </div>
                        <ChevronDown
                            class="h-4 w-4 transition"
                            :class="guideSections.progress ? 'rotate-180' : ''"
                        />
                    </button>
                    <transition name="fade">
                        <div v-if="guideSections.progress" class="decidir-accordion__body decidir-progress">
                            <div class="decidir-progress__row">
                                <span>Restantes na pilha</span>
                                <span>{{ undecidedCount }} / {{ totalCount }}</span>
                            </div>
                            <div class="decidir-progress__track">
                                <div class="decidir-progress__fill" :style="{ width: `${progressPercent}%` }" />
                            </div>
                            <div class="decidir-progress__meta">
                                <span>
                                    <span class="decidir-progress__value">{{ progressPercent }}%</span>
                                    concluído
                                </span>
                                <span>Processados: <span class="font-semibold text-slate-800">{{ processedCount }}</span> / {{ totalCount }}</span>
                                <span v-if="backlogCount" class="decidir-progress__badge">Fila pendente: {{ backlogCount }}</span>
                            </div>
                        </div>
                    </transition>
                </article>

                <article class="decidir-accordion">
                    <button
                        type="button"
                        class="decidir-accordion__trigger"
                        @click="toggleGuideSection('legend')"
                    >
                        <div class="flex items-center gap-3">
                            <TileIcon3D tone="indigo" class="decidir-accordion__icon">
                                <Pointer class="h-4 w-4" />
                            </TileIcon3D>
                            <span>Gestos e botões</span>
                        </div>
                        <ChevronDown
                            class="h-4 w-4 transition"
                            :class="guideSections.legend ? 'rotate-180' : ''"
                        />
                    </button>
                    <transition name="fade">
                        <div v-if="guideSections.legend" class="decidir-accordion__body">
                            <div class="decidir-legend">
                                <span class="decidir-legend__item decidir-legend__item--no">
                                    <X class="h-4 w-4" />
                                    Não levar
                                </span>
                                <span class="decidir-legend__item decidir-legend__item--pending">
                                    <Clock class="h-4 w-4" />
                                    Decidir depois
                                </span>
                                <span class="decidir-legend__item decidir-legend__item--yes">
                                    <Heart class="h-4 w-4" />
                                    Levar
                                </span>
                            </div>
                            <p>Deslize a carta inteira ou toque nos botões para classificar. No celular, mantenha o toque firme para arrastar.</p>
                        </div>
                    </transition>
                </article>
            </div>
        </section>

        <div v-if="isLoading" class="decidir-skeleton">
            <div class="decidir-skeleton__card">
                <div class="decidir-skeleton__media" />
                <div class="decidir-skeleton__lines">
                    <span />
                    <span />
                    <span />
                </div>
            </div>
            <div class="decidir-skeleton__actions">
                <span />
                <span />
                <span />
            </div>
        </div>

        <div
            v-else-if="currentItem"
            ref="cardViewportRef"
            class="flex min-h-[60vh] flex-col items-center justify-center gap-8 scroll-mt-20"
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

        <section v-else-if="bannerProcessedWithPendings" class="decidir-empty-card">
            <div class="decidir-empty-card__content">
                <TileIcon3D tone="indigo" class="decidir-empty-card__tile">
                    <ListChecks class="h-5 w-5" />
                </TileIcon3D>
                <div class="decidir-empty-card__text">
                    <p class="decidir-empty-card__title">Há itens pendentes para decidir</p>
                    <p class="decidir-empty-card__message">
                        Revise o Resumo para devolver os pendentes ao deck e concluir as decisões.
                    </p>
                </div>
            </div>
            <div class="decidir-empty-card__actions">
                <button
                    type="button"
                    class="decidir-empty-card__cta"
                    @click="goToResumo"
                >
                    Ir para Resumo
                    <span aria-hidden="true">→</span>
                </button>
            </div>
        </section>

        <Card v-else tone="slate" class="decidir-state-card space-y-3 text-center">
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
    BarChart3,
    BookOpenCheck,
    ChevronDown,
    Clock,
    Heart,
    ListChecks,
    Pointer,
    Sparkles,
    Undo2,
    X,
} from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import Card from '@/Components/Card.vue';
import SwipeCard from '@/Components/SwipeCard.vue';
import SwipeActionButtons from '@/Components/SwipeActionButtons.vue';
import TileIcon3D from '@/Components/home/TileIcon3D.vue';
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
const cardViewportRef = ref(null);
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
        ensureCardVisible('smooth');

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

const ensureCardVisible = (behavior = 'smooth') => {
    if (typeof window === 'undefined') return;
    const el = cardViewportRef.value;
    if (!el || typeof el.getBoundingClientRect !== 'function') return;

    requestAnimationFrame(() => {
        const rect = el.getBoundingClientRect();
        const viewportHeight = window.innerHeight ?? 0;
        const topPadding = 64;
        const bottomPadding = 80;
        if (rect.top >= topPadding && rect.bottom <= viewportHeight - bottomPadding) {
            return;
        }
        const target = rect.top < topPadding
            ? window.scrollY + rect.top - topPadding
            : window.scrollY + rect.bottom - (viewportHeight - bottomPadding);

        window.scrollTo({
            top: Math.max(target, 0),
            behavior,
        });
    });
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

watch(
    () => currentItem.value?.id,
    (newId, oldId) => {
        if (!newId) return;
        nextTick(() => {
            ensureCardVisible(oldId ? 'smooth' : 'auto');
        });
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
.decidir-panel {
    position: relative;
    overflow: hidden;
    border-radius: 1.75rem;
    padding: 1.75rem;
    background: rgba(255, 255, 255, 0.95);
    border: 1px solid rgba(148, 163, 184, 0.35);
    box-shadow: 0 25px 55px rgba(15, 23, 42, 0.12);
    backdrop-filter: blur(8px);
}
.decidir-panel::before,
.decidir-panel::after {
    content: '';
    position: absolute;
    inset: 0;
    border-radius: inherit;
    pointer-events: none;
}
.decidir-panel::before {
    background: radial-gradient(circle at 15% -20%, rgba(236, 233, 255, 0.8), transparent 50%);
    opacity: 0.8;
}
.decidir-panel::after {
    background: linear-gradient(140deg, rgba(99, 102, 241, 0.12), rgba(14, 165, 233, 0.12));
    animation: decidirPanelFlow 26s ease infinite;
}
.decidir-panel > * {
    position: relative;
    z-index: 1;
}
.decidir-panel__head {
    display: flex;
    flex-direction: column;
    gap: 1rem;
}
@media (min-width: 640px) {
    .decidir-panel__head {
        flex-direction: row;
        align-items: center;
        justify-content: space-between;
    }
}
.decidir-panel__title-block {
    display: flex;
    gap: 1rem;
    align-items: center;
}
.decidir-panel__icon {
    --tile-icon-size: 3.2rem;
    animation: floatIcon 8s ease-in-out infinite;
}
.decidir-eyebrow {
    font-size: 0.75rem;
    text-transform: uppercase;
    letter-spacing: 0.4em;
    font-weight: 600;
    color: #818cf8;
}
.decidir-panel__title {
    font-size: 1.35rem;
    font-weight: 600;
    color: #0f172a;
}
.decidir-panel__subtitle {
    font-size: 0.95rem;
    color: #475569;
}
.decidir-panel__actions {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    font-size: 0.85rem;
    color: #475569;
}
.decidir-panel__link {
    font-weight: 600;
    color: inherit;
    text-decoration: none;
    transition: color 0.2s ease;
}
.decidir-panel__link:hover {
    color: #0f172a;
}
.decidir-panel__divider {
    color: rgba(148, 163, 184, 0.5);
}
.decidir-accordion-group {
    margin-top: 1.5rem;
    display: grid;
    gap: 1rem;
}
.decidir-accordion {
    border-radius: 1.5rem;
    border: 1px solid rgba(148, 163, 184, 0.3);
    background: rgba(255, 255, 255, 0.9);
    box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.8);
}
.decidir-accordion__trigger {
    display: flex;
    width: 100%;
    align-items: center;
    justify-content: space-between;
    padding: 1rem 1.25rem;
    font-size: 0.95rem;
    font-weight: 600;
    text-align: left;
    color: #0f172a;
}
.decidir-accordion__icon {
    --tile-icon-size: 2.4rem;
}
.decidir-accordion__body {
    padding: 0 1.25rem 1.25rem;
    display: flex;
    flex-direction: column;
    gap: 0.65rem;
    font-size: 0.9rem;
    color: #475569;
}
.decidir-progress__row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    font-weight: 600;
    color: #1e293b;
}
.decidir-progress__track {
    margin-top: 0.75rem;
    height: 0.45rem;
    border-radius: 999px;
    background: rgba(226, 232, 240, 0.8);
}
.decidir-progress__fill {
    height: 100%;
    border-radius: inherit;
    background: linear-gradient(135deg, #6366f1, #0ea5e9);
    animation: progressGlow 1.8s ease-in-out infinite;
    transition: width 0.3s ease;
}
.decidir-progress__meta {
    margin-top: 0.75rem;
    display: flex;
    flex-wrap: wrap;
    gap: 0.65rem;
    font-size: 0.85rem;
    color: #475569;
}
.decidir-progress__value {
    font-weight: 700;
    color: #10b981;
    margin-right: 0.3rem;
}
.decidir-progress__badge {
    padding: 0.2rem 0.8rem;
    border-radius: 999px;
    background: rgba(253, 230, 138, 0.3);
    color: #b45309;
    font-weight: 600;
}
.decidir-legend {
    display: flex;
    flex-wrap: wrap;
    gap: 0.75rem;
}
.decidir-legend__item {
    display: inline-flex;
    align-items: center;
    gap: 0.35rem;
    padding: 0.35rem 0.9rem;
    border-radius: 999px;
    font-size: 0.8rem;
    font-weight: 600;
    border: 1px solid transparent;
}
.decidir-legend__item--no {
    background: rgba(248, 113, 113, 0.15);
    color: #b91c1c;
    border-color: rgba(248, 113, 113, 0.4);
}
.decidir-legend__item--pending {
    background: rgba(148, 163, 184, 0.12);
    color: #334155;
    border-color: rgba(148, 163, 184, 0.35);
}
.decidir-legend__item--yes {
    background: rgba(16, 185, 129, 0.18);
    color: #047857;
    border-color: rgba(16, 185, 129, 0.4);
}
.decidir-skeleton {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 1.5rem;
    width: 100%;
}
.decidir-skeleton__card {
    width: min(90%, 28rem);
    border-radius: 1.75rem;
    background: rgba(255, 255, 255, 0.9);
    padding: 1.75rem;
    animation: pulse 1.6s ease-in-out infinite;
}
.decidir-skeleton__media {
    height: 16rem;
    border-radius: 1.5rem;
    background: linear-gradient(135deg, rgba(226, 232, 240, 0.6), rgba(148, 163, 184, 0.4));
}
.decidir-skeleton__lines {
    margin-top: 1.25rem;
    display: grid;
    gap: 0.5rem;
}
.decidir-skeleton__lines span {
    display: block;
    height: 0.6rem;
    border-radius: 999px;
    background: rgba(226, 232, 240, 0.8);
}
.decidir-skeleton__lines span:nth-child(2) {
    width: 80%;
}
.decidir-skeleton__lines span:nth-child(3) {
    width: 60%;
}
.decidir-skeleton__actions {
    width: min(90%, 28rem);
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 0.75rem;
    opacity: 0.6;
}
.decidir-skeleton__actions span {
    height: 3.5rem;
    border-radius: 999px;
    background: rgba(241, 245, 249, 0.9);
}
@keyframes pulse {
    0%,
    100% {
        opacity: 0.7;
    }
    50% {
        opacity: 1;
    }
}
@keyframes decidirPanelFlow {
    0% {
        opacity: 0.6;
        transform: translate3d(0, 0, 0);
    }
    50% {
        opacity: 0.85;
        transform: translate3d(-12px, -8px, 0);
    }
    100% {
        opacity: 0.6;
        transform: translate3d(0, 0, 0);
    }
}
@keyframes floatIcon {
    0%,
    100% {
        transform: translateY(0);
    }
    50% {
        transform: translateY(-4px);
    }
}
@keyframes progressGlow {
    0%,
    100% {
        box-shadow: 0 0 0 rgba(99, 102, 241, 0.3);
    }
    50% {
        box-shadow: 0 0 18px rgba(14, 165, 233, 0.35);
    }
}
.decidir-state-card {
    background: radial-gradient(circle at top, rgba(99, 102, 241, 0.09), rgba(255, 255, 255, 0.95));
    border: 1px solid rgba(148, 163, 184, 0.3);
}
.decidir-empty-card {
    position: relative;
    overflow: hidden;
    border-radius: 1.9rem;
    padding: 1.75rem;
    background: rgba(255, 255, 255, 0.97);
    border: 1px solid rgba(99, 102, 241, 0.15);
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.7),
        0 22px 45px rgba(99, 102, 241, 0.18);
}
.decidir-empty-card::before {
    content: '';
    position: absolute;
    inset: 0;
    border-radius: inherit;
    background: radial-gradient(circle at 20% 20%, rgba(226, 232, 255, 0.8), transparent 55%);
    pointer-events: none;
}
.decidir-empty-card > * {
    position: relative;
    z-index: 1;
}
.decidir-empty-card__content {
    display: flex;
    gap: 1rem;
    align-items: center;
    flex-wrap: wrap;
}
.decidir-empty-card__tile {
    --tile-icon-size: 3rem;
    animation: floatIcon 10s ease-in-out infinite;
    background: linear-gradient(140deg, #6366f1, #0ea5e9, #9333ea);
}
.decidir-empty-card__text {
    flex: 1;
    min-width: 220px;
}
.decidir-empty-card__title {
    font-size: 1.15rem;
    font-weight: 600;
    color: #0b1340;
}
.decidir-empty-card__message {
    font-size: 0.95rem;
    color: rgba(15, 23, 42, 0.8);
}
.decidir-empty-card__actions {
    display: flex;
    justify-content: flex-start;
    margin-top: 0.5rem;
}
.decidir-empty-card__cta {
    display: inline-flex;
    align-items: center;
    gap: 0.4rem;
    border-radius: 999px;
    padding: 0.55rem 1.4rem;
    font-size: 0.95rem;
    font-weight: 600;
    color: white;
    background: linear-gradient(130deg, #475569, #64748b, #94a3b8);
    border: 1px solid rgba(148, 163, 184, 0.4);
    box-shadow: 0 20px 40px rgba(15, 23, 42, 0.25);
    position: relative;
    overflow: hidden;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.decidir-empty-card__cta::before {
    content: '';
    position: absolute;
    inset: 0;
    border-radius: inherit;
    background: radial-gradient(circle at 30% 30%, rgba(255, 255, 255, 0.35), transparent 60%);
    opacity: 0.6;
    pointer-events: none;
}
.decidir-empty-card__cta::after {
    content: '';
    position: absolute;
    inset: 0;
    border-radius: inherit;
    background: linear-gradient(120deg, transparent, rgba(255, 255, 255, 0.25), transparent);
    transform: translateX(-110%);
    animation: decidirCtaShimmer 3.8s ease infinite;
    pointer-events: none;
}
.decidir-empty-card__cta:hover {
    transform: translateY(-2px);
    box-shadow: 0 24px 45px rgba(15, 23, 42, 0.3);
}
@keyframes decidirCtaShimmer {
    0% {
        transform: translateX(-120%);
    }
    100% {
        transform: translateX(120%);
    }
}
@media (max-width: 640px) {
    .decidir-empty-card__actions {
        justify-content: center;
    }
    .decidir-empty-card__content {
        flex-direction: column;
        text-align: center;
    }
}
</style>
