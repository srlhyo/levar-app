<template>
    <Head title="Decidir o que Levar" />
    <AppLayout>
        <template #title>Decidir o que Levar</template>
        <template #subtitle>Organize sua mudança de forma simples e visual.</template>

        <button
            v-if="adminMode"
            type="button"
            class="fixed right-4 top-[98px] z-40 rounded-2xl bg-white/70 p-3 shadow-md ring-1 ring-black/5 sm:top-[110px]"
            @click="switchToSimpleMode"
        >
            <Unlock class="h-5 w-5 text-emerald-600" />
        </button>

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
            <p class="cursor-pointer select-none" @click="handleFooterClick">
                UK → Brasil • 2 malas de 23kg cada
            </p>
        </footer>
    </AppLayout>
</template>

<script setup>
import { Head, router } from '@inertiajs/vue3';
import { onMounted, ref, watch } from 'vue';
import { Camera, ChevronRight, FileText, Heart, Package, Unlock } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import Card from '@/Components/Card.vue';
import IconPill from '@/Components/IconPill.vue';
import { toast } from '@/utils/toast';

const MODE_KEY = 'mode';

const adminMode = ref(false);
const tapCount = ref(0);

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

const isEnabled = (mode) => {
    if (mode.key === 'resumo') {
        return true;
    }
    if (adminMode.value) {
        return mode.key !== 'decidir';
    }
    return mode.key === 'decidir';
};

const go = (enabled, url) => {
    if (!enabled) return;
    router.visit(url);
};

const handleNavigate = (mode) => {
    go(isEnabled(mode), mode.href);
};

const handleFooterClick = () => {
    if (adminMode.value) return;
    tapCount.value += 1;
    if (tapCount.value === 3) {
        adminMode.value = true;
        tapCount.value = 0;
        toast.success('Modo completo ativado ✨');
    }
};

const switchToSimpleMode = () => {
    adminMode.value = false;
    tapCount.value = 0;
    toast.info('Modo simples ativado 💡');
};

onMounted(() => {
    if (typeof window === 'undefined') return;
    const storedMode = window.localStorage.getItem(MODE_KEY);
    adminMode.value = storedMode === 'manage';
});

watch(adminMode, (value) => {
    if (typeof window === 'undefined') return;
    window.localStorage.setItem(MODE_KEY, value ? 'manage' : 'simple');
});
</script>
