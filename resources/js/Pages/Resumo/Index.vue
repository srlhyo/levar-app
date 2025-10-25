<template>
    <Head title="Resumo" />
    <AppLayout>
        <template #title>Resumo</template>
        <template #subtitle>Uma visão geral das malas, pendências e itens que vão com a gente.</template>

        <Card tone="slate">
            <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
                <div class="space-y-1">
                    <p class="text-xs uppercase tracking-wide text-slate-600">Total catalogado</p>
                    <p class="text-2xl font-semibold text-slate-900">{{ stats.total }}</p>
                </div>
                <div class="space-y-1">
                    <p class="text-xs uppercase tracking-wide text-slate-600">Pendentes</p>
                    <p class="text-2xl font-semibold text-sky-600">{{ stats.pending }}</p>
                </div>
                <div class="space-y-1">
                    <p class="text-xs uppercase tracking-wide text-slate-600">Vai levar</p>
                    <p class="text-2xl font-semibold text-emerald-600">{{ stats.keep }}</p>
                </div>
                <div class="space-y-1">
                    <p class="text-xs uppercase tracking-wide text-slate-600">Embalados</p>
                    <p class="text-2xl font-semibold text-amber-600">{{ stats.packed }}</p>
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
            <div class="grid gap-3 sm:grid-cols-2">
                <div class="rounded-2xl bg-white/70 p-4 ring-1 ring-white/40">
                    <p class="text-sm font-semibold text-slate-800">Mala A</p>
                    <p class="text-xs text-slate-500">{{ stats.luggageA }} itens • {{ stats.weightA.toFixed(1) }} kg</p>
                </div>
                <div class="rounded-2xl bg-white/70 p-4 ring-1 ring-white/40">
                    <p class="text-sm font-semibold text-slate-800">Mala B</p>
                    <p class="text-xs text-slate-500">{{ stats.luggageB }} itens • {{ stats.weightB.toFixed(1) }} kg</p>
                </div>
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
                    :disabled="!canExport"
                    :title="canExport ? '' : 'pendentes em aberto'"
                    @click="handleExport"
                >
                    <Download class="h-4 w-4" />
                    Exportar CSV
                </button>
            </div>
            <p v-if="!canExport" class="text-xs text-slate-500">
                Resolva os itens pendentes antes de exportar.
            </p>
        </Card>

        <Card v-if="keepItems.length" tone="slate" class="space-y-4">
            <p class="text-base font-semibold text-slate-900">Itens a levar</p>
            <div class="space-y-3">
                <div
                    v-for="item in keepItems"
                    :key="item.id"
                    class="flex flex-col gap-3 rounded-2xl bg-white/70 p-4 ring-1 ring-white/40 md:flex-row md:items-center md:gap-6"
                >
                    <div class="flex-1 space-y-1">
                        <p class="text-base font-semibold text-slate-900">{{ item.name }}</p>
                        <p class="text-sm text-slate-600">{{ item.notes }}</p>
                    </div>
                    <div class="flex flex-wrap items-center gap-2 text-xs font-semibold text-slate-600">
                        <span class="rounded-full bg-slate-900 px-3 py-1 text-white">
                            {{ item.weight.toFixed(1) }} kg
                        </span>
                        <span v-if="item.luggage" class="rounded-full bg-white px-3 py-1 text-slate-700 ring-1 ring-black/5">
                            Mala {{ item.luggage }}
                        </span>
                        <span v-if="item.packed" class="rounded-full bg-emerald-500/90 px-3 py-1 text-white">
                            Pronto
                        </span>
                    </div>
                </div>
            </div>
        </Card>
    </AppLayout>
</template>

<script setup>
import { Head } from '@inertiajs/vue3';
import { computed, ref } from 'vue';
import { Download } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import Card from '@/Components/Card.vue';
import WeightBar from '@/Components/WeightBar.vue';
import { toast } from '@/utils/toast';

const items = ref([
    {
        id: 'lamp',
        name: 'Abajur de leitura',
        weight: 1.2,
        decision: 'keep',
        luggage: 'A',
        packed: true,
        notes: 'Vai no canto da sala nova',
    },
    {
        id: 'boardgames',
        name: 'Boardgames favoritos',
        weight: 3.5,
        decision: 'keep',
        luggage: 'B',
        packed: false,
        notes: 'Caixa grande, melhor envolver em roupas',
    },
    {
        id: 'winter-coat',
        name: 'Casaco impermeável',
        weight: 2.0,
        decision: 'pending',
        luggage: null,
        packed: false,
        notes: 'Avaliar se cabe nas malas',
    },
    {
        id: 'coffee-set',
        name: 'Kit café especial',
        weight: 0.9,
        decision: 'keep',
        luggage: 'A',
        packed: false,
        notes: 'Frágil — levar na mochila',
    },
]);

const keepItems = computed(() => items.value.filter((item) => item.decision === 'keep'));
const stats = computed(() => {
    const total = items.value.length;
    const pending = items.value.filter((item) => item.decision === 'pending').length;
    const keep = keepItems.value.length;
    const packed = items.value.filter((item) => item.packed).length;
    const luggageAItems = items.value.filter((item) => item.luggage === 'A');
    const luggageBItems = items.value.filter((item) => item.luggage === 'B');
    const weightA = luggageAItems.reduce((sum, item) => sum + item.weight, 0);
    const weightB = luggageBItems.reduce((sum, item) => sum + item.weight, 0);
    const totalWeight = 46;
    const reservedKg = 4;
    return {
        total,
        pending,
        keep,
        packed,
        luggageA: luggageAItems.length,
        luggageB: luggageBItems.length,
        weightA,
        weightB,
        totalWeight,
        reservedKg,
    };
});

const canExport = computed(() => stats.value.pending === 0 && stats.value.keep > 0);

const handleExport = () => {
    if (!canExport.value) return;
    toast.success('Export gerado! (mock)');
};
</script>
