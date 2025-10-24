<template>
    <Head title="Decidir" />
    <div class="min-h-screen bg-decide-secondary flex flex-col">
        <PageHeader
            title="Decidir"
            :subtitle="items.length ? `${currentIndex + 1} de ${items.length} itens` : 'Nenhum item para decidir'"
            gradient-class="bg-gradient-decide"
            @back="router.visit('/')"
        >
            <div class="mt-4 h-2 bg-white/20 rounded-full overflow-hidden">
                <div
                    class="h-full bg-white transition-all duration-300"
                    :style="{ width: `${progress}%` }"
                />
            </div>
        </PageHeader>

        <div class="flex-1 flex flex-col items-center justify-center p-6">
            <div v-if="currentItem" class="w-full flex flex-col items-center">
                <SwipeCard :item="currentItem" @swipe="handleDecision" />

                <div class="flex gap-4 mt-8">
                    <button
                        type="button"
                        class="rounded-full w-16 h-16 border-2 border-destructive text-destructive hover:bg-destructive hover:text-white transition flex items-center justify-center"
                        @click="handleDecision('discard')"
                    >
                        <X class="h-8 w-8" />
                    </button>
                    <button
                        type="button"
                        class="rounded-full w-16 h-16 border-2 border-summary text-summary hover:bg-summary hover:text-white transition flex items-center justify-center"
                        @click="handleDecision('later')"
                    >
                        <Clock class="h-8 w-8" />
                    </button>
                    <button
                        type="button"
                        class="rounded-full w-16 h-16 bg-decide hover:bg-decide/90 transition flex items-center justify-center text-white"
                        @click="handleDecision('keep')"
                    >
                        <Heart class="h-8 w-8" />
                    </button>
                </div>
            </div>
            <div v-else class="text-center space-y-4">
                <div class="text-6xl">🎉</div>
                <h2 class="text-2xl font-bold text-decide">Tudo decidido!</h2>
                <p class="text-muted-foreground">Você já decidiu sobre todos os itens catalogados</p>
                <button
                    type="button"
                    class="bg-decide hover:bg-decide/90 text-white rounded-xl px-6 py-3 font-semibold"
                    @click="router.visit('/')"
                >
                    Voltar ao Início
                </button>
            </div>
        </div>
    </div>
</template>

<script setup>
import { Head, router } from '@inertiajs/vue3';
import { computed, onMounted, ref } from 'vue';
import { Clock, Heart, X } from 'lucide-vue-next';
import SwipeCard from '@/Components/SwipeCard.vue';
import PageHeader from '@/Components/PageHeader.vue';
import { storage } from '@/utils/storage';
import { toast } from '@/utils/toast';
import AppLayout from '@/Layouts/AppLayout.vue';

defineOptions({ layout: AppLayout });

const items = ref([]);
const currentIndex = ref(0);

const currentItem = computed(() => items.value[currentIndex.value]);
const progress = computed(() => {
    if (!items.value.length) return 100;
    return Math.min(100, (currentIndex.value / items.value.length) * 100);
});

const loadItems = () => {
    const all = storage.getItems();
    items.value = all.filter((item) => item.decision === 'pending');
    currentIndex.value = 0;
};

onMounted(loadItems);

const handleDecision = (decision) => {
    if (!currentItem.value) return;

    storage.updateItem(currentItem.value.id, { decision });

    const messages = {
        keep: '✓ Vai na mala!',
        discard: '✗ Não vai',
        later: '⏰ Decidir depois',
    };

    toast.success(messages[decision] ?? 'Atualizado');
    currentIndex.value += 1;

    if (currentIndex.value >= items.value.length) {
        loadItems();
    }
};
</script>
