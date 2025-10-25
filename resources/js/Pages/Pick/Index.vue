<template>
    <Head title="Embalar" />
    <AppLayout>
        <template #title>Embalar</template>
        <template #subtitle>Distribua os itens nas malas A e B e marque o que já está pronto.</template>

        <WeightBar :total-kg="46" :bag-a-used="weightA" :bag-b-used="weightB" :reserved-kg="4.0" />

        <Card tone="yellow" class="space-y-4">
            <template v-if="items.length">
                <div
                    v-for="item in items"
                    :key="item.id"
                    class="flex flex-col gap-4 rounded-2xl bg-white/70 p-4 ring-1 ring-white/40 sm:flex-row sm:items-center sm:justify-between"
                >
                    <div class="flex flex-1 items-start gap-3">
                        <IconPill tone="yellow">
                            <component :is="item.icon" class="h-6 w-6" />
                        </IconPill>
                        <div class="space-y-1">
                            <p class="text-base font-semibold text-slate-900 sm:text-lg">{{ item.name }}</p>
                            <p class="text-sm text-slate-600">{{ item.subtitle }}</p>
                            <p class="text-xs text-slate-500">{{ item.weight.toFixed(1) }} kg</p>
                        </div>
                    </div>

                    <div class="flex flex-col gap-3 sm:items-end">
                        <div class="inline-flex items-center gap-2 rounded-full bg-white/70 p-1 ring-1 ring-black/5">
                            <button
                                type="button"
                                class="rounded-full px-4 py-1 text-xs font-semibold transition sm:text-sm"
                                :class="item.bag === 'A' ? 'bg-amber-400 text-slate-900 shadow' : 'text-slate-600 hover:bg-white'"
                                @click="assignBag(item, 'A')"
                            >
                                Mala A
                            </button>
                            <button
                                type="button"
                                class="rounded-full px-4 py-1 text-xs font-semibold transition sm:text-sm"
                                :class="item.bag === 'B' ? 'bg-amber-400 text-slate-900 shadow' : 'text-slate-600 hover:bg-white'"
                                @click="assignBag(item, 'B')"
                            >
                                Mala B
                            </button>
                        </div>

                        <label class="inline-flex items-center gap-2 text-sm font-medium text-slate-600">
                            <input
                                type="checkbox"
                                class="h-4 w-4 rounded border-slate-300 text-amber-500 focus:ring-amber-300"
                                :checked="item.packed"
                                @change="togglePacked(item)"
                            />
                            Embalado
                        </label>
                    </div>
                </div>
            </template>
            <div v-else class="py-10 text-center text-sm text-slate-600">
                Nenhum item aguardando embalagem por enquanto.
            </div>
        </Card>
    </AppLayout>
</template>

<script setup>
import { Head } from '@inertiajs/vue3';
import { computed, ref } from 'vue';
import { Camera, HandPlatter, Laptop, Package, Shirt } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import Card from '@/Components/Card.vue';
import IconPill from '@/Components/IconPill.vue';
import WeightBar from '@/Components/WeightBar.vue';
import { toast } from '@/utils/toast';

const items = ref([
    {
        id: 'coat',
        name: 'Casaco de inverno',
        subtitle: 'Mantém o calor nas noites frias de São Paulo',
        weight: 1.8,
        bag: 'A',
        packed: false,
        icon: Shirt,
    },
    {
        id: 'coffee',
        name: 'Kit Aeropress + Café especial',
        subtitle: 'Presente do Pedro, melhor levar na mala de mão',
        weight: 0.9,
        bag: 'B',
        packed: true,
        icon: HandPlatter,
    },
    {
        id: 'laptop',
        name: 'Notebook trabalho remoto',
        subtitle: 'Vai no mochilão, reserva de 3kg garantida',
        weight: 2.1,
        bag: 'A',
        packed: false,
        icon: Laptop,
    },
    {
        id: 'camera',
        name: 'Câmera mirrorless + lente 35mm',
        subtitle: 'Usar bolsa acolchoada – frágil!',
        weight: 1.2,
        bag: 'B',
        packed: false,
        icon: Camera,
    },
]);

const weightA = computed(() => items.value.filter((item) => item.bag === 'A').reduce((sum, item) => sum + item.weight, 0));
const weightB = computed(() => items.value.filter((item) => item.bag === 'B').reduce((sum, item) => sum + item.weight, 0));

const assignBag = (item, bag) => {
    item.bag = bag;
    toast.success(`Item enviado para mala ${bag}`);
};

const togglePacked = (item) => {
    item.packed = !item.packed;
    toast.success(item.packed ? 'Marcado como embalado' : 'Item voltou para a lista');
};
</script>
