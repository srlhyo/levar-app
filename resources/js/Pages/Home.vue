<template>
    <Head title="Decidir o que Levar" />
    <AppLayout>
        <template #title>Decidir o que Levar</template>
        <template #subtitle>
            <span @click="handleMudancaClick" class="select-none">Organize sua mudança</span> de forma simples e visual.
        </template>

        <div class="grid gap-4 sm:gap-5">
            <Card
                v-for="mode in modes"
                :key="mode.key"
                tag="button"
                type="button"
                :tone="mode.tone"
                :disabled="!isEnabled(mode)"
                :aria-disabled="!isEnabled(mode)"
                :tabindex="isEnabled(mode) ? 0 : -1"
                class="w-full text-left transition-transform duration-200 hover:-translate-y-0.5 focus:outline-none focus-visible:ring-2 focus-visible:ring-slate-500/40"
                :class="!isEnabled(mode) ? 'pointer-events-none opacity-40' : ''"
                @click="() => handleNavigate(mode)"
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
            <p>
                UK → Brasil • 2 malas de
                <span @click="handleKgClick" class="select-none"> 23kg </span>
                cada
            </p>
        </footer>
    </AppLayout>
</template>

<script setup>
import { Head, router, usePage } from '@inertiajs/vue3';
import { computed, ref } from 'vue';
import { Camera, ChevronRight, FileText, Heart, Package } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import Card from '@/Components/Card.vue';
import IconPill from '@/Components/IconPill.vue';

const page = usePage();
const isAdmin = computed(() => Boolean(page.props.auth?.user?.is_admin));

const modes = [
    {
        key: 'catalogar',
        title: 'Catalogar',
        subtitle: 'Capture fotos e registre detalhes dos itens.',
        icon: Camera,
        tone: 'blue',
        iconTone: 'blue',
        href: '/catalogar',
    },
    {
        key: 'decidir',
        title: 'Decidir',
        subtitle: 'Faça o swipe deck e escolha o destino de cada item.',
        icon: Heart,
        tone: 'green',
        iconTone: 'green',
        href: '/decidir',
    },
    {
        key: 'pick',
        title: 'Embalar',
        subtitle: 'Distribua nas malas A/B e marque como embalado.',
        icon: Package,
        tone: 'yellow',
        iconTone: 'yellow',
        href: '/pick',
    },
    {
        key: 'resumo',
        title: 'Resumo',
        subtitle: 'Acompanhe os totais, pesos e pendências.',
        icon: FileText,
        tone: 'slate',
        iconTone: 'slate',
        href: '/resumo',
    },
];

const catalogUnlocked = ref(false);
const othersUnlocked = ref(false);
const mudancaClicks = ref(0);
const kgClicks = ref(0);

const isEnabled = (mode) => {
    if (isAdmin.value) {
        if (mode.key === 'catalogar') {
            return catalogUnlocked.value;
        }
        return othersUnlocked.value;
    }
    return mode.key !== 'catalogar';
};

const pulseToggle = (refTarget) => {
    refTarget.value = !refTarget.value;
};

const handleMudancaClick = () => {
    if (!isAdmin.value) return;
    mudancaClicks.value += 1;
    if (mudancaClicks.value >= 3) {
        mudancaClicks.value = 0;
        pulseToggle(catalogUnlocked);
    }
};

const handleKgClick = () => {
    if (!isAdmin.value) return;
    kgClicks.value += 1;
    if (kgClicks.value >= 3) {
        kgClicks.value = 0;
        pulseToggle(othersUnlocked);
    }
};

const handleNavigate = (mode) => {
    if (!isEnabled(mode)) return;
    router.visit(mode.href);
};
</script>
