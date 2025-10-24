<template>
    <Head title="Embalar" />
    <div class="min-h-screen bg-pack-secondary">
        <PageHeader
            title="Embalar"
            :subtitle="`${packedItems.length} de ${items.length} itens embalados`"
            gradient-class="bg-gradient-pack"
            @back="router.visit('/')"
        />

        <div class="p-6 space-y-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div class="bg-card rounded-xl p-4 shadow-smooth-sm">
                    <div class="text-sm text-muted-foreground mb-1">Mala A</div>
                    <div class="text-2xl font-bold text-pack">{{ weightA.toFixed(1) }}kg</div>
                    <div class="text-xs text-muted-foreground">de {{ MAX_WEIGHT }}kg</div>
                    <div class="mt-2 h-2 bg-pack/20 rounded-full overflow-hidden">
                        <div
                            class="h-full bg-pack transition-all"
                            :style="{ width: `${Math.min(100, (weightA / MAX_WEIGHT) * 100)}%` }"
                        />
                    </div>
                </div>

                <div class="bg-card rounded-xl p-4 shadow-smooth-sm">
                    <div class="text-sm text-muted-foreground mb-1">Mala B</div>
                    <div class="text-2xl font-bold text-pack">{{ weightB.toFixed(1) }}kg</div>
                    <div class="text-xs text-muted-foreground">de {{ MAX_WEIGHT }}kg</div>
                    <div class="mt-2 h-2 bg-pack/20 rounded-full overflow-hidden">
                        <div
                            class="h-full bg-pack transition-all"
                            :style="{ width: `${Math.min(100, (weightB / MAX_WEIGHT) * 100)}%` }"
                        />
                    </div>
                </div>
            </div>

            <div v-if="!items.length" class="text-center py-12 space-y-4">
                <Package class="h-16 w-16 text-muted-foreground mx-auto" />
                <h2 class="text-xl font-semibold text-muted-foreground">Nenhum item para embalar</h2>
                <p class="text-sm text-muted-foreground">Primeiro catalogue e decida quais itens levar</p>
            </div>

            <div v-else-if="!unassignedItems.length" class="text-center py-12 space-y-4">
                <div class="text-6xl">✅</div>
                <h2 class="text-2xl font-bold text-pack">Tudo embalado!</h2>
                <p class="text-muted-foreground">Todos os itens foram atribuídos às malas</p>
            </div>

            <div v-else class="space-y-3">
                <div
                    v-for="item in unassignedItems"
                    :key="item.id"
                    class="bg-card rounded-xl p-4 shadow-smooth-sm"
                >
                    <div class="flex items-start gap-3">
                        <img
                            v-if="item.photo"
                            :src="item.photo"
                            :alt="item.name"
                            class="w-16 h-16 rounded-lg object-cover"
                        />
                        <div class="flex-1 min-w-0">
                            <h3 class="font-semibold">{{ item.name }}</h3>
                            <p class="text-sm text-muted-foreground">{{ (item.weight ?? 0).toFixed(1) }}kg</p>
                            <p v-if="item.notes" class="text-xs text-muted-foreground mt-1">
                                {{ item.notes }}
                            </p>
                        </div>
                    </div>

                    <div class="flex gap-2 mt-4">
                        <button
                            type="button"
                            class="flex-1 bg-pack hover:bg-pack/90 text-white rounded-lg px-3 py-2 font-medium"
                            @click="assignLuggage(item.id, 'A')"
                        >
                            Mala A
                        </button>
                        <button
                            type="button"
                            class="flex-1 bg-pack hover:bg-pack/90 text-white rounded-lg px-3 py-2 font-medium"
                            @click="assignLuggage(item.id, 'B')"
                        >
                            Mala B
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { Head, router } from '@inertiajs/vue3';
import { computed, onMounted, ref } from 'vue';
import { Package } from 'lucide-vue-next';
import PageHeader from '@/Components/PageHeader.vue';
import { storage } from '@/utils/storage';
import { toast } from '@/utils/toast';
import AppLayout from '@/Layouts/AppLayout.vue';

defineOptions({ layout: AppLayout });

const MAX_WEIGHT = 23;

const items = ref([]);

const loadItems = () => {
    const all = storage.getItems();
    items.value = all.filter((item) => item.decision === 'keep');
};

onMounted(loadItems);

const weightByLuggage = (luggage) =>
    items.value
        .filter((item) => item.luggage === luggage)
        .reduce((total, item) => total + (item.weight ?? 0), 0);

const weightA = computed(() => weightByLuggage('A'));
const weightB = computed(() => weightByLuggage('B'));
const unassignedItems = computed(() => items.value.filter((item) => !item.luggage));
const packedItems = computed(() => items.value.filter((item) => item.packed));

const assignLuggage = (id, luggage) => {
    storage.updateItem(id, { luggage, packed: true });
    toast.success(`Atribuído à mala ${luggage}`);
    loadItems();
};
</script>
