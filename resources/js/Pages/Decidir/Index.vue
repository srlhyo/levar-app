<template>
    <Head title="Decidir" />
    <AppLayout>
        <template #title>Decidir</template>
        <template #subtitle>Avalie item a item e escolha se vai na mala, fica ou decide depois.</template>

        <Card tone="green" class="space-y-4">
            <div class="flex items-center justify-between text-sm font-medium text-slate-600">
                <span>Progresso</span>
                <span>{{ deckPosition }} / {{ total }}</span>
            </div>
            <div class="h-2 rounded-full bg-white/60">
                <div
                    class="h-full rounded-full bg-emerald-500 transition-all duration-300"
                    :style="{ width: `${progress}%` }"
                />
            </div>
            <p class="text-xs text-slate-600 sm:text-sm">
                Arraste a carta para os lados ou use os botões para tomar a decisão.
            </p>
        </Card>

        <div class="flex flex-col items-center gap-8">
            <SwipeCard v-if="currentItem" :item="currentItem" @swipe="handleDecision" />

            <div v-if="currentItem" class="flex items-center gap-4">
                <button
                    type="button"
                    class="grid h-16 w-16 place-items-center rounded-full border border-rose-200 bg-white/80 text-rose-500 shadow hover:bg-rose-50"
                    @click="handleDecision('discard')"
                >
                    <X class="h-7 w-7" />
                </button>
                <button
                    type="button"
                    class="grid h-16 w-16 place-items-center rounded-full border border-slate-200 bg-white/80 text-slate-600 shadow hover:bg-slate-50"
                    @click="handleDecision('later')"
                >
                    <Clock class="h-7 w-7" />
                </button>
                <button
                    type="button"
                    class="grid h-16 w-16 place-items-center rounded-full border border-emerald-200 bg-emerald-500 text-white shadow hover:bg-emerald-400"
                    @click="handleDecision('keep')"
                >
                    <Heart class="h-7 w-7" />
                </button>
            </div>

            <div v-else class="text-center space-y-3">
                <div class="text-5xl">🎉</div>
                <p class="text-lg font-semibold text-emerald-600">Tudo decidido!</p>
                <p class="text-sm text-slate-600 sm:text-base">Volte quando novos itens aparecerem na lista.</p>
                <button
                    type="button"
                    class="inline-flex items-center gap-2 rounded-2xl bg-emerald-500 px-4 py-2 text-sm font-semibold text-white shadow hover:bg-emerald-400"
                    @click="router.visit('/')"
                >
                    Voltar ao início
                </button>
            </div>
        </div>
    </AppLayout>
</template>

<script setup>
import { Head, router } from '@inertiajs/vue3';
import { computed, ref } from 'vue';
import { Clock, Heart, X } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import Card from '@/Components/Card.vue';
import SwipeCard from '@/Components/SwipeCard.vue';
import { toast } from '@/utils/toast';

const deck = ref([
    {
        id: 'living-room-lamp',
        name: 'Abajur sala vintage',
        weight: 1.3,
        notes: 'Ocupa pouco espaço e ilumina bem',
        decision: 'pending',
    },
    {
        id: 'coat-blue',
        name: 'Casaco azul inverno',
        weight: 1.9,
        notes: 'Favorito da Lauren • Cabe na mala A',
        decision: 'pending',
    },
    {
        id: 'coffee-mugs',
        name: 'Conjunto de canecas viagem',
        weight: 0.8,
        notes: '4 peças • Pode quebrar se despachar',
        decision: 'pending',
    },
]);

const currentIndex = ref(0);

const total = computed(() => deck.value.length);
const currentItem = computed(() => deck.value[currentIndex.value] ?? null);
const deckPosition = computed(() => Math.min(currentIndex.value + 1, total.value));

const progress = computed(() => {
    if (!total.value) return 100;
    return Math.min(100, (currentIndex.value / total.value) * 100);
});

const messages = {
    keep: '✓ Vai na mala!',
    discard: '✗ Não vai',
    later: '⏰ Decidir depois',
};

const handleDecision = (decision) => {
    if (!currentItem.value) return;
    toast.success(messages[decision] ?? 'Atualizado');

    if (decision === 'later') {
        deck.value.push({ ...currentItem.value, id: `${currentItem.value.id}-later-${Date.now()}` });
    }

    currentIndex.value += 1;
};
</script>
