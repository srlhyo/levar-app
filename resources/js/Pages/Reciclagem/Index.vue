<template>
    <Head title="Reciclagem" />
    <AppLayout>
        <template #title>Reciclagem</template>
        <template #subtitle>Itens excluídos ficam guardados por 60 dias antes de sumirem definitivamente.</template>

        <Card tone="slate" class="space-y-4">
            <template v-if="trashedItems.length">
                <div
                    v-for="item in trashedItems"
                    :key="item.id"
                    class="flex flex-col gap-4 rounded-2xl bg-white/70 p-4 ring-1 ring-white/60 md:flex-row md:items-center md:justify-between"
                >
                    <div class="space-y-1">
                        <p class="text-base font-semibold text-slate-900 md:text-lg">{{ item.title ?? item.name }}</p>
                        <p class="text-sm text-slate-600">{{ item.location }}</p>
                        <p class="text-xs text-slate-500">Excluído {{ item.deletedAt }} • {{ item.weight.toFixed(1) }} kg</p>
                    </div>
                    <div class="flex flex-col gap-3 md:items-end">
                        <span
                            class="inline-flex items-center gap-2 rounded-full px-3 py-1 text-xs font-semibold"
                            :class="item.daysLeft <= 5 ? 'bg-rose-500/90 text-white' : 'bg-slate-900 text-white'"
                        >
                            <TimerReset class="h-4 w-4" />
                            {{ item.daysLeft }} dias restantes
                        </span>
                        <div class="flex gap-2">
                            <button
                                type="button"
                                class="rounded-2xl border border-slate-300 px-4 py-1.5 text-xs font-semibold text-slate-600 hover:bg-white"
                                @click="restore(item)"
                            >
                                Restaurar
                            </button>
                            <button
                                type="button"
                                class="rounded-2xl bg-rose-500/90 px-4 py-1.5 text-xs font-semibold text-white shadow hover:bg-rose-500"
                                @click="purge(item)"
                            >
                                Apagar agora
                            </button>
                        </div>
                    </div>
                </div>
            </template>
            <div v-else class="py-10 text-center text-sm text-slate-600">
                <ArchiveRestore class="mx-auto mb-3 h-10 w-10 text-slate-500" />
                Nenhum item está na reciclagem no momento.
            </div>
        </Card>
    </AppLayout>
</template>

<script setup>
import { Head } from '@inertiajs/vue3';
import { ref } from 'vue';
import { ArchiveRestore, TimerReset } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import Card from '@/Components/Card.vue';
import { toast } from '@/utils/toast';

const trashedItems = ref([
    {
        id: 'books-1',
        name: 'Coleção livros UX',
        location: 'Escritório • Estante de metal',
        deletedAt: 'há 3 dias',
        daysLeft: 57,
        weight: 4.2,
    },
    {
        id: 'kitchen-3',
        name: 'Panela elétrica antiga',
        location: 'Cozinha • Armário superior',
        deletedAt: 'há 40 dias',
        daysLeft: 20,
        weight: 2.8,
    },
    {
        id: 'decor-12',
        name: 'Quadro Londres',
        location: 'Sala • Parede principal',
        deletedAt: 'há 55 dias',
        daysLeft: 5,
        weight: 1.4,
    },
]);

const restore = (item) => {
    toast.success(`Restaurado: ${item.title ?? item.name} (mock)`);
};

const purge = (item) => {
    toast.error(`Remoção definitiva agendada para ${item.title ?? item.name} (mock)`);
};
</script>
