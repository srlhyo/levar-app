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
                        <p class="text-xs text-slate-500">
                            Excluído {{ item.deletedAt }}
                            <span v-if="item.weight != null"> • {{ formatWeight(item.weight) }}</span>
                            <span v-if="formatVolume(item)"> • {{ formatVolume(item) }}</span>
                        </p>
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
import { Head, usePage } from '@inertiajs/vue3';
import { computed, onMounted, watchEffect } from 'vue';
import { ArchiveRestore, TimerReset } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import Card from '@/Components/Card.vue';
import { useDecisionStore } from '@/stores/decision';
import { toast } from '@/utils/toast';

const decisionStore = useDecisionStore();
const page = usePage();
const move = computed(() => page.props.move ?? null);

watchEffect(() => {
    decisionStore.setMove(move.value);
});

onMounted(async () => {
    if (!move.value?.id) return;
    try {
        await decisionStore.fetchRecycle();
    } catch (error) {
        console.error(error);
        toast.error('Não foi possível carregar a reciclagem.');
    }
});

const trashedItems = computed(() => decisionStore.recycle ?? []);

const numberFormatter = new Intl.NumberFormat('pt-BR');

const formatWeight = (weight) => `${Number(weight ?? 0).toFixed(1)} kg`;

const formatVolume = (item) => {
    const cm3 = item.volume_cm3 ?? null;
    const liters = item.volume_liters ?? (cm3 != null ? cm3 / 1000 : null);
    if (liters == null || Number.isNaN(liters)) {
        return null;
    }
    const cm3Value = cm3 ?? liters * 1000;
    return `${Number(liters).toFixed(1)} L (${numberFormatter.format(Math.round(cm3Value))} cm³)`;
};

const restore = async (item) => {
    try {
        await decisionStore.restoreItems([item.id]);
        toast.success(`${item.title ?? item.name} restaurado ✅`);
    } catch (error) {
        console.error(error);
        toast.error('Falha ao restaurar o item.');
    }
};

const purge = async (item) => {
    try {
        await decisionStore.destroyItem(item.id);
        toast.success('Item removido definitivamente.');
    } catch (error) {
        console.error(error);
        toast.error('Falha ao remover o item.');
    }
};
</script>
