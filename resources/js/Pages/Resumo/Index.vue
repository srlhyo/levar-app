<template>
    <Head title="Resumo" />
    <div class="min-h-screen bg-summary-secondary">
        <PageHeader
            title="Resumo"
            subtitle="Visão geral da sua mudança"
            gradient-class="bg-gradient-summary"
            @back="router.visit('/')"
        />

        <div class="p-6 space-y-6">
            <section class="bg-card rounded-xl p-6 shadow-smooth-sm">
                <h2 class="text-lg font-semibold mb-4">Progresso</h2>
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <div class="text-3xl font-bold text-summary">{{ stats.total }}</div>
                        <div class="text-sm text-muted-foreground">Total de itens</div>
                    </div>
                    <div>
                        <div class="text-3xl font-bold text-catalog">{{ stats.pending }}</div>
                        <div class="text-sm text-muted-foreground">Por decidir</div>
                    </div>
                    <div>
                        <div class="text-3xl font-bold text-decide">{{ stats.keep }}</div>
                        <div class="text-sm text-muted-foreground">Vai levar</div>
                    </div>
                    <div>
                        <div class="text-3xl font-bold text-pack">{{ stats.packed }}</div>
                        <div class="text-sm text-muted-foreground">Embalados</div>
                    </div>
                </div>
            </section>

            <section class="bg-card rounded-xl p-6 shadow-smooth-sm">
                <h2 class="text-lg font-semibold mb-4">Malas</h2>
                <div class="space-y-4">
                    <div class="flex justify-between items-center p-4 bg-pack-secondary rounded-lg">
                        <div>
                            <div class="font-semibold">Mala A</div>
                            <div class="text-sm text-muted-foreground">{{ stats.luggageA }} itens</div>
                        </div>
                        <div class="text-right">
                            <div class="text-2xl font-bold text-pack">{{ stats.weightA.toFixed(1) }}kg</div>
                            <div class="text-xs text-muted-foreground">de 23kg</div>
                        </div>
                    </div>
                    <div class="flex justify-between items-center p-4 bg-pack-secondary rounded-lg">
                        <div>
                            <div class="font-semibold">Mala B</div>
                            <div class="text-sm text-muted-foreground">{{ stats.luggageB }} itens</div>
                        </div>
                        <div class="text-right">
                            <div class="text-2xl font-bold text-pack">{{ stats.weightB.toFixed(1) }}kg</div>
                            <div class="text-xs text-muted-foreground">de 23kg</div>
                        </div>
                    </div>
                </div>
            </section>

            <section class="space-y-3">
                <button
                    type="button"
                    class="w-full bg-summary hover:bg-summary/90 text-white rounded-xl px-4 py-3 flex items-center justify-center gap-2 text-lg shadow-smooth-md disabled:opacity-50 disabled:cursor-not-allowed"
                    :disabled="!stats.keep"
                    @click="exportCSV"
                >
                    <Download class="h-5 w-5" />
                    Exportar CSV
                </button>
                <p v-if="!stats.keep" class="text-center text-sm text-muted-foreground">
                    Primeiro decida quais itens levar para poder exportar
                </p>
            </section>

            <section v-if="stats.keep" class="bg-card rounded-xl p-6 shadow-smooth-sm">
                <h2 class="text-lg font-semibold mb-4">Itens a levar</h2>
                <div class="space-y-3">
                    <div
                        v-for="item in keepItems"
                        :key="item.id"
                        class="flex items-center gap-3 p-3 bg-background rounded-lg"
                    >
                        <img
                            v-if="item.photo"
                            :src="item.photo"
                            :alt="item.name"
                            class="w-12 h-12 rounded object-cover"
                        />
                        <div class="flex-1 min-w-0">
                            <div class="font-medium">{{ item.name }}</div>
                            <div class="text-sm text-muted-foreground">
                                {{ (item.weight ?? 0).toFixed(1) }}kg
                                <span v-if="item.luggage"> • Mala {{ item.luggage }}</span>
                                <span v-if="item.packed"> • ✓</span>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </div>
</template>

<script setup>
import { Head, router } from '@inertiajs/vue3';
import { computed, onMounted, ref } from 'vue';
import { Download } from 'lucide-vue-next';
import PageHeader from '@/Components/PageHeader.vue';
import { storage } from '@/utils/storage';
import { toast } from '@/utils/toast';
import AppLayout from '@/Layouts/AppLayout.vue';

defineOptions({ layout: AppLayout });

const items = ref([]);

const loadItems = () => {
    items.value = storage.getItems();
};

onMounted(loadItems);

const keepItems = computed(() => items.value.filter((item) => item.decision === 'keep'));

const stats = computed(() => {
    const total = items.value.length;
    const pending = items.value.filter((item) => item.decision === 'pending').length;
    const keep = keepItems.value.length;
    const discard = items.value.filter((item) => item.decision === 'discard').length;
    const later = items.value.filter((item) => item.decision === 'later').length;
    const packed = items.value.filter((item) => item.packed).length;
    const luggageAItems = items.value.filter((item) => item.luggage === 'A');
    const luggageBItems = items.value.filter((item) => item.luggage === 'B');
    const weightA = luggageAItems.reduce((sum, item) => sum + (item.weight ?? 0), 0);
    const weightB = luggageBItems.reduce((sum, item) => sum + (item.weight ?? 0), 0);
    return {
        total,
        pending,
        keep,
        discard,
        later,
        packed,
        luggageA: luggageAItems.length,
        luggageB: luggageBItems.length,
        weightA,
        weightB,
    };
});

const exportCSV = () => {
    if (!keepItems.value.length) return;

    const rows = [
        ['Nome', 'Peso (kg)', 'Mala', 'Embalado', 'Notas'],
        ...keepItems.value.map((item) => [
            item.name,
            item.weight ?? 0,
            item.luggage ?? 'Não atribuída',
            item.packed ? 'Sim' : 'Não',
            item.notes ?? '',
        ]),
    ];

    const csvContent = rows.map((row) => row.map((value) => `"${String(value).replace(/"/g, '""')}"`).join(',')).join('\n');

    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const url = window.URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.setAttribute('download', `mudanca-${new Date().toISOString().slice(0, 10)}.csv`);
    document.body.appendChild(link);
    link.click();
    link.remove();
    window.URL.revokeObjectURL(url);

    toast.success('CSV exportado!');
};
</script>
