<template>
    <Head title="Decidir" />
    <AppLayout>
        <template #title>Decidir</template>
        <template #subtitle>Escolha rapidamente se o item vai, não vai ou fica para decidir depois.</template>

        <Card tone="green" class="space-y-4">
            <div class="flex items-center justify-between text-sm font-medium text-slate-600">
                <span>Progresso</span>
                <span>{{ processedCount }} / {{ totalCount }}</span>
            </div>
            <div class="h-2 rounded-full bg-white/60">
                <div class="h-full rounded-full bg-emerald-500 transition-all duration-300" :style="{ width: `${progressPercent}%` }" />
            </div>
            <p class="rounded-2xl bg-white/70 px-4 py-2 text-xs font-medium text-slate-600">
                Processados: {{ processedCount }}/{{ totalCount }} • Pendentes: {{ pendingCount }}
            </p>
            <p class="text-xs text-slate-600 sm:text-sm">
                Gestos: direita (Levar) • esquerda (Não levar) • para baixo (Decidir depois). Os botões abaixo fazem o mesmo.
            </p>
        </Card>

        <div v-if="currentItem" class="flex flex-col items-center gap-8">
            <SwipeCard
                ref="swipeCardRef"
                :item="currentItem"
                :disabled="isProcessing"
                @decision="handleDecision"
            />

            <div class="flex w-full max-w-md items-center justify-between gap-3 sm:max-w-lg">
                <div class="relative group flex-1">
                    <button
                        type="button"
                        :aria-describedby="tooltipIds.no"
                        aria-label="Não levar"
                        class="inline-flex h-14 w-full items-center justify-center rounded-full border border-rose-200 bg-white/90 text-rose-500 shadow transition hover:bg-rose-50 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-rose-400 disabled:cursor-not-allowed disabled:opacity-40 sm:h-16"
                        :disabled="isProcessing"
                        @click="() => requestDecision('no')"
                        @touchstart="() => handleTouchHint('no')"
                    >
                        <X class="h-6 w-6" />
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
                        class="inline-flex h-14 w-full items-center justify-center rounded-full border border-slate-200 bg-white/90 text-slate-700 shadow transition hover:bg-slate-100 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-400 disabled:cursor-not-allowed disabled:opacity-40 sm:h-16"
                        :disabled="isProcessing"
                        @click="() => requestDecision('pending')"
                        @touchstart="() => handleTouchHint('pending')"
                    >
                        <Clock class="h-6 w-6" />
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
                        class="inline-flex h-14 w-full items-center justify-center rounded-full border border-emerald-300 bg-emerald-500 text-white shadow transition hover:bg-emerald-400 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-300 disabled:cursor-not-allowed disabled:opacity-40 sm:h-16"
                        :disabled="isProcessing"
                        @click="() => requestDecision('yes')"
                        @touchstart="() => handleTouchHint('yes')"
                    >
                        <Heart class="h-6 w-6" />
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

        <Toast v-model="toastOpen" :message="toastMessage" :duration="2600" />

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
import { route } from 'ziggy-js';
import { computed, nextTick, onMounted, reactive, ref } from 'vue';
import { Clock, Heart, X } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import Card from '@/Components/Card.vue';
import SwipeCard from '@/Components/SwipeCard.vue';
import Toast from '@/Components/Toast.vue';
import { useDecisionStore } from '@/stores/decision';

const DEV = import.meta.env.DEV;
const page = usePage();
const decisionStore = useDecisionStore();

const totalCount = computed(() => decisionStore.totalCount);
const processedCount = computed(() => decisionStore.processedCount);
const pendingCount = computed(() => decisionStore.pendingCount);
const progressPercent = computed(() => decisionStore.progressPercent);
const currentItem = computed(() => decisionStore.currentItem);
const bannerProcessedWithPendings = computed(
    () => totalCount.value > 0 && processedCount.value === totalCount.value && pendingCount.value > 0,
);

const toastOpen = ref(false);
const toastMessage = ref('');
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

const showToast = (message) => {
    toastMessage.value = message;
    toastOpen.value = false;
    nextTick(() => {
        toastOpen.value = true;
    });
};

const vibrate = (pattern) => {
    if (typeof navigator !== 'undefined' && 'vibrate' in navigator) {
        navigator.vibrate(pattern);
    }
};

const handleDecision = (type) => {
    const item = decisionStore.applyDecision(type);
    if (!item) {
        isProcessing.value = false;
        return;
    }

    if (type === 'pending') {
        vibrate([0, 30, 30, 30]);
        showToast('Item adiado ⏳');
    } else if (type === 'yes') {
        vibrate(25);
        showToast('Marcado para levar 💚');
    } else if (type === 'no') {
        vibrate([0, 20, 80, 20]);
        showToast('Marcado como não levar ❌');
    }

    nextTick(() => {
        isProcessing.value = false;
    });
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

const hydrateStore = async () => {
    const shouldSeed = DEV && page.url.includes('seed=1');
    if (shouldSeed) {
        await decisionStore.forceSeed();
    } else {
        await decisionStore.loadMockData();
        decisionStore.initialize();
    }
    if (DEV) {
        console.info('[decidir] store state', {
            items: decisionStore.items.length,
            queue: decisionStore.queue.length,
        });
    }
};

const handleDevSeed = async () => {
    await decisionStore.forceSeed();
    isProcessing.value = false;
    showToast('Mock reimportado ✅');
};

const handleDevClear = () => {
    decisionStore.resetAll();
    isProcessing.value = false;
    showToast('Mock limpo ♻️');
};

const goToResumo = () => {
    const destination = route ? route('resumo.index') : '/resumo';
    router.visit(destination);
};

onMounted(async () => {
    await hydrateStore();
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
