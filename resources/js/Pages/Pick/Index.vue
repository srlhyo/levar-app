<template>
    <Head title="Embalar" />
    <AppLayout>
        <template #title>Embalar</template>
        <template #subtitle>Distribua os itens nas malas A e B e marque o que já está pronto.</template>

        <WeightBar :total-kg="totalCapacity" :bag-a-used="weightA" :bag-b-used="weightB" :reserved-kg="reservedKg" />

        <div
            v-if="allPackedBanner && packItems.length"
            class="mt-4 flex items-start gap-3 rounded-2xl bg-green-50 p-4 text-green-800 shadow-sm ring-1 ring-green-200"
        >
            <span class="text-2xl">🎉</span>
            <div>
                <p class="text-base font-semibold">Tudo embalado!</p>
                <p class="text-sm">Você pode revisar no Resumo ou exportar a planilha.</p>
            </div>
        </div>

        <Card tone="yellow" class="space-y-4">
            <template v-if="packItems.length">
        <div
            class="sticky top-16 z-10 flex flex-wrap items-center justify-between gap-2 rounded-xl bg-white/90 p-3 text-sm text-slate-600 shadow ring-1 ring-black/5 backdrop-blur"
        >
            <span class="font-semibold text-slate-700">
                Embalados: {{ packedCount }} / {{ packItems.length }}
            </span>
            <div class="flex flex-wrap items-center gap-2">
                <button
                    v-if="hasUnpacked"
                    type="button"
                    class="inline-flex items-center gap-2 rounded-full bg-amber-500 px-4 py-2 text-xs font-semibold text-slate-900 shadow transition hover:bg-amber-400 sm:text-sm"
                    @click="markAllPacked(true)"
                    aria-label="Marcar todos os itens como embalados"
                >
                    Marcar todos como Embalado
                </button>
                <button
                    v-if="hasPacked"
                    type="button"
                    class="inline-flex items-center gap-2 rounded-full border border-amber-200 px-4 py-2 text-xs font-semibold text-amber-700 transition hover:bg-amber-100 sm:text-sm"
                    @click="markAllPacked(false)"
                    aria-label="Desmarcar todos os itens embalados"
                >
                    Desmarcar todos
                </button>
            </div>
        </div>

                <div
                    v-for="item in packItems"
                    :key="item.id"
                    class="flex flex-col gap-4 rounded-2xl bg-white/70 p-4 ring-1 ring-white/40 sm:flex-row sm:items-center sm:justify-between"
                >
                    <div class="flex flex-1 items-start gap-3">
                        <IconPill tone="yellow">
                            <Package class="h-6 w-6" />
                        </IconPill>
                        <div class="space-y-1">
                            <p class="text-base font-semibold text-slate-900 sm:text-lg">{{ item.title ?? item.name }}</p>
                            <p v-if="item.notes" class="text-sm text-slate-600">{{ item.notes }}</p>
                            <p class="text-xs text-slate-500">{{ (item.weight ?? 0).toFixed(1) }} kg</p>
                            <p v-if="item.dimensions" class="text-xs text-slate-500">{{ item.dimensions }}</p>
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
                                @change="onPackedChange(item, $event.target.checked)"
                                :aria-label="`Marcar ${item.title ?? item.name} como embalado`"
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
        <Toast v-model="toastOpen" :message="toastMessage" />
    </AppLayout>
</template>

<script setup>
import { Head, usePage } from '@inertiajs/vue3';
import { computed, nextTick, onMounted, ref } from 'vue';
import { Package } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import Card from '@/Components/Card.vue';
import IconPill from '@/Components/IconPill.vue';
import WeightBar from '@/Components/WeightBar.vue';
import Toast from '@/Components/Toast.vue';
import { useDecisionStore } from '@/stores/decision';

const decisionStore = useDecisionStore();
const DEV = import.meta.env.DEV;
const page = usePage();

const totalCapacity = 46;
const reservedKg = 4;

const hydrateStore = async () => {
    const shouldSeed = DEV && page.url.includes('seed=1');
    if (shouldSeed) {
        await decisionStore.forceSeed();
    } else {
        await decisionStore.loadMockData();
        decisionStore.initialize();
    }
};

onMounted(async () => {
    await hydrateStore();
});

const packItems = computed(() =>
    decisionStore.items.filter((item) => !item.deleted && item.decision === 'yes'),
);

const weightA = computed(() =>
    packItems.value.filter((item) => item.bag === 'A').reduce((sum, item) => sum + (item.weight ?? 0), 0),
);
const weightB = computed(() =>
    packItems.value.filter((item) => item.bag === 'B').reduce((sum, item) => sum + (item.weight ?? 0), 0),
);

const packedCount = computed(() => packItems.value.filter((item) => item.packed).length);
const hasUnpacked = computed(() => packItems.value.some((item) => !item.packed));
const hasPacked = computed(() => packItems.value.some((item) => item.packed));

const allPackedBanner = computed(() => decisionStore.allPacked && packItems.value.length > 0);

const toastOpen = ref(false);
const toastMessage = ref('');

const showToast = (message) => {
    toastMessage.value = message;
    toastOpen.value = false;
    nextTick(() => {
        toastOpen.value = true;
    });
};

const markAllPacked = (value) => {
    if (!packItems.value.length) return;
    const ids = packItems.value.map((item) => item.id);
    decisionStore.markPacked(ids, value);
    showToast(value ? 'Itens marcados como embalados ✅' : 'Itens desmarcados como embalados ↩︎');
};

const assignBag = (item, bag) => {
    if (!item) return;
    item.bag = bag;
    decisionStore.persist();
    showToast(`Item enviado para mala ${bag}`);
};

const onPackedChange = (item, checked) => {
    decisionStore.markPacked([item.id], checked);
    showToast(checked ? 'Marcado como embalado ✅' : 'Item voltou para a lista ↩︎');
};
</script>
