<template>
    <Head title="Decidir o que Levar" />
    <AppLayout>
        <template #title>Decidir o que Levar</template>
        <template #subtitle>Organize sua mudança de forma simples e visual.</template>

        <div class="grid gap-4 sm:gap-5">
            <FeatureTile
                v-for="mode in modes"
                :key="mode.key"
                :title="mode.title"
                :subtitle="mode.subtitle"
                :tone="mode.tone"
                :eyebrow="mode.eyebrow"
                :delay="mode.delay"
                :icon="mode.icon"
                :highlight="mode.highlight"
                @select="() => handleNavigate(mode)"
            />
        </div>

        <footer class="pt-6 text-center">
            <div class="inline-flex items-center gap-2 rounded-full bg-white/80 px-4 py-2 text-xs font-semibold text-slate-600 shadow-inner shadow-white/60 ring-1 ring-white/60">
                <span>UK → Brasil</span>
                <span class="text-slate-400">•</span>
                <span>2 malas de 23 kg</span>
            </div>
        </footer>
    </AppLayout>
</template>

<script setup>
import { Head, router } from '@inertiajs/vue3';
import { Camera, ClipboardList, Package, Sparkles } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import FeatureTile from '@/Components/home/FeatureTile.vue';

const modes = [
    {
        key: 'catalogar',
        title: 'Catalogar',
        subtitle: 'Capture fotos e registre detalhes dos itens.',
        icon: Camera,
        tone: 'emerald',
        eyebrow: 'Etapa 01',
        delay: 0,
        highlight: false,
        href: '/catalogar',
    },
    {
        key: 'decidir',
        title: 'Decidir',
        subtitle: 'Faça o swipe deck e escolha o destino de cada item.',
        icon: Sparkles,
        tone: 'indigo',
        eyebrow: 'Etapa 02',
        delay: 100,
        highlight: true,
        href: '/decidir',
    },
    {
        key: 'pick',
        title: 'Embalar',
        subtitle: 'Distribua nas malas A/B e marque como embalado.',
        icon: Package,
        tone: 'amber',
        eyebrow: 'Etapa 03',
        delay: 200,
        highlight: false,
        href: '/pick',
    },
    {
        key: 'resumo',
        title: 'Resumo',
        subtitle: 'Acompanhe os totais, pesos e pendências.',
        icon: ClipboardList,
        tone: 'slate',
        eyebrow: 'Etapa 04',
        delay: 300,
        highlight: false,
        href: '/resumo',
    },
];

const handleNavigate = (mode) => {
    router.visit(mode.href);
};
</script>
