<template>
    <div class="min-h-screen bg-slate-50 text-slate-900 pt-[max(env(safe-area-inset-top),16px)]">
        <main class="mx-auto max-w-3xl px-4 pb-8">
            <header class="space-y-3 text-left">
                <div class="flex items-start gap-3 sm:items-center sm:gap-4">
                    <button
                        v-if="!isHome"
                        type="button"
                        aria-label="Voltar"
                        class="inline-flex items-center gap-2 rounded-2xl bg-white/80 px-3 py-2 text-slate-700 shadow-sm ring-1 ring-black/5 transition hover:bg-white focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-500/40"
                        @click="goHome"
                    >
                        <ArrowLeft class="h-4 w-4" />
                        <span class="text-sm font-medium">Voltar</span>
                    </button>

                    <div class="space-y-2">
                        <div class="inline-flex items-center rounded-full bg-slate-100 px-3 py-1 text-xs font-medium text-slate-700">
                            Mudança UK → Brasil
                        </div>
                        <h1 class="text-2xl font-bold text-slate-800 sm:text-3xl">
                            <slot name="title" />
                        </h1>
                        <p v-if="hasSubtitle" class="text-base leading-relaxed text-slate-600 sm:text-lg">
                            <slot name="subtitle" />
                        </p>
                    </div>
                </div>

                <div class="border-t border-slate-200/80 shadow-[0_1px_0_rgba(0,0,0,0.02)]"></div>
            </header>

            <section class="mt-6 space-y-6 sm:space-y-8">
                <slot />
            </section>
        </main>
        <ToastHub />

        <OverlayModal v-if="onboardingReady" :model-value="showHistoryModal" @close="dismissHistory">
            <template #header>
                <p class="text-xs font-semibold uppercase tracking-wide text-emerald-600">Nossa jornada</p>
                <h2 class="text-2xl font-bold text-slate-900">Como nasceu o Levar</h2>
            </template>

            <p>
                Aqui vai entrar a história completa da mudança — um relato inspirador sobre como este app ganhou vida,
                os desafios que enfrentamos e as pessoas que ajudaram a moldar esta experiência. Enquanto o texto não
                chega, considere este um convite para criar a sua própria narrativa de mudança, com espaço para anotar
                memórias e expectativas do novo destino.
            </p>
            <p>
                Aproveite para respirar fundo antes de começar: revise os cômodos, converse com quem vai viver a aventura com você
                e imagine como quer se sentir quando tudo estiver desembalado. Esse espaço foi feito para apoiar cada etapa.
            </p>

            <template #footer>
                <button
                    type="button"
                    class="inline-flex items-center gap-2 rounded-full bg-slate-900 px-4 py-2 text-sm font-semibold text-white shadow transition hover:bg-slate-800 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-500"
                    @click="dismissHistory"
                >
                    Começar agora
                </button>
                <button
                    type="button"
                    class="inline-flex items-center gap-2 rounded-full border border-slate-200 px-4 py-2 text-sm font-semibold text-slate-600 transition hover:bg-slate-50 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-400"
                    @click="dismissHistory"
                >
                    Pular por enquanto
                </button>
            </template>
        </OverlayModal>

        <OverlayModal v-if="onboardingReady" :model-value="showTourModal" @close="dismissTour">
            <template #header>
                <p class="text-xs font-semibold uppercase tracking-wide text-sky-600">Guia rápido</p>
                <h2 class="text-2xl font-bold text-slate-900">Como aproveitar o Levar ao máximo</h2>
            </template>

            <div class="space-y-4">
                <div class="rounded-2xl bg-slate-50 p-4 ring-1 ring-slate-200/60">
                    <h3 class="text-sm font-semibold text-slate-800">1. Catalogar</h3>
                    <p class="text-sm text-slate-600">
                        Registre cada item com foto, peso e volume estimado. Pense nisso como montar o “álbum” da mudança:
                        quanto mais detalhado, mais fácil será priorizar depois.
                    </p>
                </div>
                <div class="rounded-2xl bg-slate-50 p-4 ring-1 ring-slate-200/60">
                    <h3 class="text-sm font-semibold text-slate-800">2. Decidir</h3>
                    <p class="text-sm text-slate-600">
                        Use gestos ou botões para marcar se algo vai, fica ou precisa de revisão. O bar de progresso mostra
                        quando a pilha está sob controle.
                    </p>
                </div>
                <div class="rounded-2xl bg-slate-50 p-4 ring-1 ring-slate-200/60">
                    <h3 class="text-sm font-semibold text-slate-800">3. Resumo e Embalar</h3>
                    <p class="text-sm text-slate-600">
                        Acompanhe as listas consolidadas no Resumo e, quando estiver pronto, use Embalar para distribuir o peso
                        e o volume entre as malas. Se algo travar, você vê imediatamente.
                    </p>
                </div>
            </div>

            <template #footer>
                <button
                    type="button"
                    class="inline-flex items-center gap-2 rounded-full bg-emerald-500 px-4 py-2 text-sm font-semibold text-white shadow transition hover:bg-emerald-400 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-300"
                    @click="dismissTour"
                >
                    Vamos lá!
                </button>
                <button
                    type="button"
                    class="inline-flex items-center gap-2 rounded-full border border-slate-200 px-4 py-2 text-sm font-semibold text-slate-600 transition hover:bg-slate-50 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-400"
                    @click="dismissTour"
                >
                    Ver depois
                </button>
            </template>
        </OverlayModal>
    </div>
</template>

<script setup>
import { computed, useSlots } from 'vue';
import { ArrowLeft } from 'lucide-vue-next';
import { router, usePage } from '@inertiajs/vue3';
import { route } from 'ziggy-js';
import ToastHub from '@/Components/ToastHub.vue';
import OverlayModal from '@/Components/OverlayModal.vue';
import { useOnboarding } from '@/composables/useOnboarding';

const page = usePage();
const slots = useSlots();
const onboarding = useOnboarding();

const showHistoryModal = computed(() => onboarding.shouldShowHistory.value);
const showTourModal = computed(() => onboarding.shouldShowTour.value);
const onboardingReady = computed(() => onboarding.ready.value);

const dismissHistory = () => onboarding.dismissHistory();
const dismissTour = () => onboarding.dismissTour();

const isHome = computed(() => page.component === 'Home');
const hasSubtitle = computed(() => !!slots.subtitle);

const goHome = () => {
    router.visit(route('home'));
};
</script>
