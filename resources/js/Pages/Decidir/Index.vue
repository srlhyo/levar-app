<template>
    <Head title="Decidir" />
    <AppLayout>
        <template #title>Decidir</template>
        <template #subtitle>Escolha rapidamente se o item vai, não vai ou fica para decidir depois.</template>

        <Card tone="green" class="space-y-4">
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
        </Card>

        <div v-if="currentItem" class="flex flex-col items-center gap-8">
            <SwipeCard
                ref="swipeCardRef"
                :item="currentItem"
                :disabled="isProcessing"
                @decision="handleDecision"
            />

            <div class="flex w-full max-w-md items-stretch justify-between gap-3 sm:max-w-lg">
                <div class="relative group flex-1">
                    <button
                        type="button"
                        :aria-describedby="tooltipIds.no"
                        aria-label="Não levar"
                        class="inline-flex w-full flex-col items-center justify-center gap-1 rounded-full border border-rose-200 bg-white/90 px-4 py-3 text-rose-500 shadow transition hover:bg-rose-50 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-rose-400 disabled:cursor-not-allowed disabled:opacity-40 sm:min-h-[4.25rem]"
                        :disabled="isProcessing"
                        @click="() => requestDecision('no')"
                        @touchstart="() => handleTouchHint('no')"
                    >
                        <X class="h-6 w-6" />
                        <span class="text-[11px] font-semibold uppercase tracking-wide text-rose-500 sm:text-xs">Não levar</span>
                    </button>
                    <span
                        :id="tooltipIds.no"
                        class="pointer-events-none absolute -top-9 left-1/2 hidden -translate-x-1/2 rounded-full bg-slate-900 px-3 py-1 text-xs font-semibold text-white opacity-0 transition delay-[150ms] group-hover:opacity-100 group-focus-within:opacity-100 sm:block"
                    >
                        Não levar
                    </span>
                    <transition name="fade">
                        <span
                            v-if="mobileHint.no"
                            class="pointer-events-none absolute -top-10 left-1/2 -translate-x-1/2 rounded-full bg-slate-900/90 px-3 py-1 text-xs font-semibold text-white sm:hidden"
                        >
                            Não levar
                        </span>
                    </transition>
                </div>

                <div class="relative group flex-1">
                    <button
                        type="button"
                        :aria-describedby="tooltipIds.pending"
                        aria-label="Decidir depois"
                        class="inline-flex w-full flex-col items-center justify-center gap-1 rounded-full border border-slate-200 bg-white/90 px-4 py-3 text-slate-700 shadow transition hover:bg-slate-100 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-400 disabled:cursor-not-allowed disabled:opacity-40 sm:min-h-[4.25rem]"
                        :disabled="isProcessing"
                        @click="() => requestDecision('pending')"
                        @touchstart="() => handleTouchHint('pending')"
                    >
                        <Clock class="h-6 w-6" />
                        <span class="text-[11px] font-semibold uppercase tracking-wide text-slate-600 sm:text-xs">Decidir depois</span>
                    </button>
                    <span
                        :id="tooltipIds.pending"
                        class="pointer-events-none absolute -top-9 left-1/2 hidden -translate-x-1/2 rounded-full bg-slate-900 px-3 py-1 text-xs font-semibold text-white opacity-0 transition delay-[150ms] group-hover:opacity-100 group-focus-within:opacity-100 sm:block"
                    >
                        Decidir depois
                    </span>
                    <transition name="fade">
                        <span
                            v-if="mobileHint.pending"
                            class="pointer-events-none absolute -top-10 left-1/2 -translate-x-1/2 rounded-full bg-slate-900/90 px-3 py-1 text-xs font-semibold text-white sm:hidden"
                        >
                            Decidir depois
                        </span>
                    </transition>
                </div>

                <div class="relative group flex-1">
                    <button
                        type="button"
                        :aria-describedby="tooltipIds.yes"
                        aria-label="Levar"
                        class="inline-flex w-full flex-col items-center justify-center gap-1 rounded-full border border-emerald-400 bg-emerald-500 px-4 py-3 text-white shadow transition hover:bg-emerald-400 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-300 disabled:cursor-not-allowed disabled:opacity-40 sm:min-h-[4.25rem]"
                        :disabled="isProcessing"
                        @click="() => requestDecision('yes')"
                        @touchstart="() => handleTouchHint('yes')"
                    >
                        <Heart class="h-6 w-6" />
                        <span class="text-[11px] font-semibold uppercase tracking-wide text-white sm:text-xs">Levar</span>
                    </button>
                    <span
                        :id="tooltipIds.yes"
                        class="pointer-events-none absolute -top-9 left-1/2 hidden -translate-x-1/2 rounded-full bg-slate-900 px-3 py-1 text-xs font-semibold text-white opacity-0 transition delay-[150ms] group-hover:opacity-100 group-focus-within:opacity-100 sm:block"
                    >
                        Levar
                    </span>
                    <transition name="fade">
                        <span
                            v-if="mobileHint.yes"
                            class="pointer-events-none absolute -top-10 left-1/2 -translate-x-1/2 rounded-full bg-slate-900/90 px-3 py-1 text-xs font-semibold text-white sm:hidden"
                        >
                            Levar
                        </span>
                    </transition>
                </div>
            </div>
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

    </AppLayout>
</template>

<script setup>
import { Head, router, usePage } from '@inertiajs/vue3';
import { route } from 'ziggy-js';
import { computed, nextTick, onMounted, reactive, ref, watchEffect } from 'vue';
import { Clock, Heart, X } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import Card from '@/Components/Card.vue';
import SwipeCard from '@/Components/SwipeCard.vue';
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

const isProcessing = ref(false);
const swipeCardRef = ref(null);
const tooltipIds = {
    no: 'tooltip-no',
    pending: 'tooltip-pending',
    yes: 'tooltip-yes',
};

const mobileHint = reactive({ no: false, pending: false, yes: false });
const mobileSeen = ref(false);
const isTouchDevice = ref(false);

const vibrate = (pattern) => {
    if (typeof navigator !== 'undefined' && 'vibrate' in navigator) {
        navigator.vibrate(pattern);
    }
};

const handleDecision = async (type) => {
    const active = decisionStore.currentItem;
    if (!active) {
        isProcessing.value = false;
        return;
    }

    try {
        await decisionStore.applyDecision(type);

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
    } catch (error) {
        console.error(error);
        toast.error('Não foi possível atualizar o item ❌');
    } finally {
        nextTick(() => {
            isProcessing.value = false;
        });
    }
};

const requestDecision = (type) => {
    if (!currentItem.value || isProcessing.value) return;
    isProcessing.value = true;
    swipeCardRef.value?.triggerDecision(type);
};

const handleTouchHint = (key) => {
    if (!isTouchDevice.value || mobileSeen.value || mobileHint[key]) return;
    mobileHint[key] = true;
    window.setTimeout(() => {
        mobileHint[key] = false;
    }, 1500);

    if (!mobileSeen.value) {
        mobileSeen.value = true;
        if (typeof window !== 'undefined') {
            window.localStorage.setItem('seen_decidir_hints', 'true');
        }
    }
};

const goToResumo = () => {
    const destination = route ? route('resumo.index') : '/resumo';
    router.visit(destination);
};

onMounted(async () => {
    if (move.value?.id) {
        try {
            await decisionStore.fetchDeck();
        } catch (error) {
            console.error(error);
            toast.error('Não foi possível carregar os itens ❌');
        }
    }

    if (typeof window !== 'undefined') {
        isTouchDevice.value = 'ontouchstart' in window || navigator.maxTouchPoints > 0;
        mobileSeen.value = window.localStorage.getItem('seen_decidir_hints') === 'true';
    }
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
</style>
