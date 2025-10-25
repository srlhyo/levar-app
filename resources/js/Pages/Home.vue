<template>
    <Head title="Decidir o que Levar" />
    <AppLayout>
        <template #title>Decidir o que Levar</template>
        <template #subtitle>Organize sua mudança de forma simples e visual.</template>

        <div class="flex justify-end" aria-hidden="true">
            <IconPill v-if="adminMode" tone="green">
                <Unlock class="h-6 w-6" />
            </IconPill>
        </div>

        <div class="grid gap-4 sm:gap-5">
            <Card
                v-for="mode in modes"
                :key="mode.key"
                tag="button"
                type="button"
                :tone="mode.tone"
                :disabled="mode.requiresAdmin && !adminMode"
                class="w-full text-left transition-transform duration-200 hover:-translate-y-0.5 focus:outline-none focus-visible:ring-2 focus-visible:ring-slate-500/40"
                @click="handleNavigate(mode)"
            >
                <div class="flex items-center gap-4">
                    <IconPill :tone="mode.iconTone">
                        <component :is="mode.icon" class="h-6 w-6" />
                    </IconPill>
                    <div class="flex-1 space-y-1">
                        <h2 class="text-lg font-semibold text-slate-800 sm:text-xl">{{ mode.title }}</h2>
                        <p class="text-sm text-slate-600 sm:text-base">{{ mode.subtitle }}</p>
                    </div>
                    <ChevronRight class="h-5 w-5 text-slate-500" />
                </div>
            </Card>
        </div>

        <footer class="pt-6 text-center text-sm text-slate-500">
            <p class="cursor-pointer select-none" @click="handleFooterClick">
                UK → Brasil • 2 malas de 23kg cada
            </p>
        </footer>

        <Toast v-model="toastOpen" />
    </AppLayout>
</template>

<script setup>
import { Head, router } from '@inertiajs/vue3';
import { ref } from 'vue';
import { Camera, ChevronRight, FileText, Heart, Package, Unlock } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import Card from '@/Components/Card.vue';
import IconPill from '@/Components/IconPill.vue';
import Toast from '@/Components/Toast.vue';

const adminMode = ref(false);
const tapCount = ref(0);
const toastOpen = ref(false);

const modes = [
    {
        key: 'catalogar',
        title: 'Catalogar',
        subtitle: 'Capture fotos e registre detalhes dos itens.',
        icon: Camera,
        tone: 'blue',
        iconTone: 'blue',
        href: '/catalogar',
        requiresAdmin: true,
    },
    {
        key: 'decidir',
        title: 'Decidir',
        subtitle: 'Faça o swipe deck e escolha o destino de cada item.',
        icon: Heart,
        tone: 'green',
        iconTone: 'green',
        href: '/decidir',
        requiresAdmin: false,
    },
    {
        key: 'pick',
        title: 'Embalar',
        subtitle: 'Distribua nas malas A/B e marque como embalado.',
        icon: Package,
        tone: 'yellow',
        iconTone: 'yellow',
        href: '/pick',
        requiresAdmin: true,
    },
    {
        key: 'resumo',
        title: 'Resumo',
        subtitle: 'Acompanhe os totais, pesos e pendências.',
        icon: FileText,
        tone: 'slate',
        iconTone: 'slate',
        href: '/resumo',
        requiresAdmin: true,
    },
];

const handleNavigate = (mode) => {
    if (mode.requiresAdmin && !adminMode.value) return;
    router.visit(mode.href);
};

const handleFooterClick = () => {
    tapCount.value += 1;
    if (tapCount.value === 3) {
        adminMode.value = true;
        toastOpen.value = true;
    }
};
</script>
