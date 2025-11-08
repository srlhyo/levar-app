<template>
    <div class="min-h-screen bg-slate-50 text-slate-900 pt-[max(env(safe-area-inset-top),16px)]">
        <main class="mx-auto max-w-3xl px-4 pb-8">
            <header class="space-y-3 text-left">
                <div class="flex items-start justify-between gap-3 sm:items-center sm:gap-4">
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

                    <div v-if="currentUser" ref="accountMenuRef" class="relative flex-shrink-0">
                        <button
                            type="button"
                            class="inline-flex items-center gap-2 rounded-2xl bg-white/80 px-4 py-2 text-sm font-semibold text-slate-700 shadow-sm ring-1 ring-black/5 transition hover:bg-white focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-500/40"
                            @click.stop="toggleAccountMenu"
                        >
                            <span class="inline-flex h-8 w-8 items-center justify-center rounded-full bg-emerald-100 text-emerald-700 font-semibold">
                                {{ userInitials }}
                            </span>
                            <div class="text-left leading-tight hidden sm:block">
                                <p class="font-semibold">{{ currentUser.name }}</p>
                                <p class="text-xs text-slate-500">{{ currentUser.email }}</p>
                            </div>
                        </button>

                        <transition name="fade">
                            <div
                                v-if="showAccountMenu"
                                class="absolute right-0 z-50 mt-3 w-60 rounded-3xl border border-slate-200 bg-white/95 p-4 text-sm text-slate-700 shadow-xl backdrop-blur"
                            >
                                <p class="text-xs font-semibold uppercase tracking-wide text-slate-400">Conta</p>
                                <p class="mt-1 text-base font-semibold text-slate-900">{{ currentUser.name }}</p>
                                <p class="text-xs text-slate-500">{{ currentUser.email }}</p>

                                <button
                                    type="button"
                                    class="mt-4 inline-flex w-full items-center justify-center gap-2 rounded-full bg-slate-900 px-4 py-2 text-sm font-semibold text-white shadow transition hover:bg-slate-800 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-500"
                                    @click="logout"
                                >
                                    Sair do Levar
                                </button>
                            </div>
                        </transition>
                    </div>
                </div>

                <div class="border-t border-slate-200/80 shadow-[0_1px_0_rgba(0,0,0,0.02)]"></div>
            </header>

            <section class="mt-6 space-y-6 sm:space-y-8">
                <slot />
            </section>
        </main>
        <ScrollTopButton :targets="scrollTargets" />
        <ToastHub />

        <OverlayModal :model-value="showWelcomeModal" @close="goToInstructions">
            <template #header>
                <p class="text-xs font-semibold uppercase tracking-wide text-slate-400">Bem-vindo</p>
                <h2 class="text-3xl font-bold text-slate-900">Uma viagem entre mundos</h2>
            </template>

            <div class="space-y-4 text-center">
                <div class="flex items-center justify-center gap-4">
                    <span class="flag flag-pt" aria-label="Portugal"></span>
                    <span class="flag flag-uk" aria-label="Reino Unido"></span>
                    <span class="flag flag-br" aria-label="Brasil"></span>
                </div>
                <div :class="['welcome-text space-y-3 text-left text-sm text-slate-700 sm:text-base', { raise: welcomeTextRaised }]">
                    <p>
                        Em abril tomei uma das decisões mais difíceis da minha vida: deixar para trás o país que me
                        estendeu uma ponte quando resolvi sair do meu berço e gatinhar em direção a algo que eu acreditava
                        ser maior do que o mundo que me rodeava há 17 anos.
                    </p>
                    <p>
                        A ponte era firme o suficiente para suportar todas as tempestades e águas turbulentas enquanto eu a
                        atravessava; e suave o quanto basta para me amparar em cada queda, enquanto deixava de gatinhar e
                        aprendia a dar os primeiros passos — e depois a andar — até chegar à terra que viria a ser o meu chão
                        por 20 anos.
                    </p>
                    <p>
                        Hoje, a pouco menos de dois meses da minha chegada à terra que será o meu chão daqui em diante,
                        celebro o nascimento da Levar.
                        <button
                            type="button"
                            class="ml-2 text-emerald-600 underline decoration-dotted underline-offset-4 hover:text-emerald-500"
                            @click="openStoryModal"
                        >
                            Clica aqui
                        </button>
                        <span> cpara saber mais.</span>
                    </p>
                </div>
            </div>

            <template #footer>
                <button
                    type="button"
                    class="inline-flex items-center gap-2 rounded-full bg-emerald-500 px-4 py-2 text-sm font-semibold text-white shadow transition hover:bg-emerald-400 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-300"
                    @click="goToInstructions"
                >
                    Seguir para instruções
                </button>
            </template>
        </OverlayModal>

        <OverlayModal :model-value="showStoryModal" @close="closeStoryModal">
            <template #header>
                <div class="flex items-center justify-between gap-3">
                    <div class="min-w-0">
                        <p class="text-xs font-semibold uppercase tracking-wide text-amber-500">Antes que tudo existisse</p>
                        <h2 class="text-2xl font-bold text-slate-900 leading-tight">A história por trás da Levar</h2>
                    </div>
                    <div class="confetti" aria-hidden="true">
                        <span v-for="n in 24" :key="n" class="confetti-piece"></span>
                    </div>
                </div>
            </template>

            <div class="story-scroll space-y-4 text-sm text-slate-700 sm:text-base">
                <p v-for="(paragraph, index) in currentStoryStep.paragraphs" :key="`story-${storyPage}-${index}`">
                    {{ paragraph }}
                </p>
                <ul
                    v-if="currentStoryStep.list"
                    class="list-disc space-y-1 rounded-2xl bg-amber-50/70 p-4 text-slate-600"
                >
                    <li v-for="(item, idx) in currentStoryStep.list" :key="`bullet-${idx}`">
                        {{ item }}
                    </li>
                </ul>
                <p v-if="storyPage === storySteps.length - 1" class="italic text-slate-500 text-sm">
                    João 8:58 — “Antes que Abraão existisse, EU SOU.”
                </p>
            </div>

            <template #footer>
                <div class="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
                    <div class="text-xs font-semibold uppercase tracking-wide text-slate-400">
                        {{ storyPage + 1 }} / {{ storySteps.length }}
                    </div>
                    <div class="flex flex-wrap gap-2">
                        <button
                            v-if="hasPreviousStory"
                            type="button"
                            class="inline-flex items-center gap-2 rounded-full border border-slate-200 px-4 py-2 text-sm font-semibold text-slate-600 shadow-sm transition hover:bg-slate-50 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-300"
                            @click="previousStoryPage"
                        >
                            Anterior
                        </button>
                        <button
                            type="button"
                            class="inline-flex items-center gap-2 rounded-full bg-slate-900 px-4 py-2 text-sm font-semibold text-white shadow transition hover:bg-slate-800 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-500"
                            @click="nextStoryPage"
                        >
                            {{ hasNextStory ? 'Continuar a ler' : 'Fechar' }}
                        </button>
                    </div>
                </div>
            </template>
        </OverlayModal>

        <OverlayModal :model-value="showInstructionsModal" @close="dismissInstructions">
            <template #header>
                <p class="text-xs font-semibold uppercase tracking-wide text-emerald-500">Seu ritual</p>
                <h2 class="text-2xl font-bold text-slate-900">Como usar a Levar</h2>
            </template>

            <div class="space-y-4">
                <div class="rounded-2xl bg-emerald-50/60 p-4 ring-1 ring-emerald-100">
                    <h3 class="text-sm font-semibold text-emerald-800">1. Catalogar</h3>
                    <p class="text-sm text-emerald-700">
                        Fotografe e descreva cada item como se fosse uma memória — peso, volume, notas especiais.
                    </p>
                </div>
                <div class="rounded-2xl bg-sky-50/60 p-4 ring-1 ring-sky-100">
                    <h3 class="text-sm font-semibold text-sky-800">2. Decidir</h3>
                    <p class="text-sm text-sky-700">
                        No swipe deck, defina se o item vai, fica ou espera. Gestos e botões têm o mesmo encanto.
                    </p>
                </div>
                <div class="rounded-2xl bg-amber-50/60 p-4 ring-1 ring-amber-100">
                    <h3 class="text-sm font-semibold text-amber-800">3. Embalar &amp; Resumo</h3>
                    <p class="text-sm text-amber-700">
                        Distribua peso/volume entre as malas e acompanhe os totais. Se algo encher demais, o Levar avisa.
                    </p>
                </div>
            </div>

            <template #footer>
                <button
                    type="button"
                    class="inline-flex items-center gap-2 rounded-full bg-emerald-500 px-4 py-2 text-sm font-semibold text-white shadow transition hover:bg-emerald-400 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-300"
                    @click="dismissInstructions"
                >
                    Começar agora
                </button>
            </template>
        </OverlayModal>
    </div>
</template>

<script setup>
import { computed, onMounted, onBeforeUnmount, provide, ref, useSlots, watch } from 'vue';
import { ArrowLeft } from 'lucide-vue-next';
import { router, usePage } from '@inertiajs/vue3';
import { route } from 'ziggy-js';
import ToastHub from '@/Components/ToastHub.vue';
import OverlayModal from '@/Components/OverlayModal.vue';
import ScrollTopButton from '@/Components/ScrollTopButton.vue';

const page = usePage();
const slots = useSlots();

const currentUser = computed(() => page.props.auth?.user ?? null);
const scrollTargets = ref([]);

const registerScrollTarget = (targetRef) => {
    if (!targetRef) {
        return () => {};
    }
    scrollTargets.value = [...scrollTargets.value, targetRef];
    return () => {
        scrollTargets.value = scrollTargets.value.filter((refItem) => refItem !== targetRef);
    };
};

provide('registerScrollTarget', registerScrollTarget);
const csrfToken = computed(() =>
    page.props.csrf_token ??
    document.head?.querySelector('meta[name="csrf-token"]')?.getAttribute('content') ??
    '',
);
const userInitials = computed(() => {
    if (!currentUser.value?.name) return '🙂';
    return currentUser.value.name
        .split(' ')
        .map((part) => part.charAt(0).toUpperCase())
        .slice(0, 2)
        .join('');
});

const showAccountMenu = ref(false);
const accountMenuRef = ref(null);

const showWelcomeModal = ref(false);
const showStoryModal = ref(false);
const showInstructionsModal = ref(false);
const storyPage = ref(0);
const storySteps = [
    {
        paragraphs: [
            'Para Deus, nada é impossível.',
            'As mudanças apresentam sempre obstáculos e levantam questões que rapidamente se transformam em listas invisíveis — parasitas que vivem na nossa mente, sugando-nos a energia e perturbando-nos ao ponto de enlouquecermos:',
        ],
        list: ['Para onde vamos?', 'O que temos para levar?', 'Quanto podemos levar (peso, volume, quantidade)?', 'O que é mais importante levar?', 'Quanto tempo temos para decidir?'],
    },
    {
        paragraphs: [
            'A Levar nasceu de uma iluminação de Deus, do poder do amor e da vontade inigualável que enchem o meu coração e a minha alma — mesmo em tempos de guerra, dor, lágrimas e suor.',
            'Sem saber por onde ou como começar, orei para que Deus me guiasse e me desse clareza a cada etapa da jornada. A resposta veio em forma de amor — uma ideia simples que me aproximou de alguém que é muito especial para mim, acalmou os obstáculos e transformou o que antes parecia impossível.',
            'Antes que a Levar existisse, EU SOU.',
            'João 8:58 — “Antes que Abraão existisse, EU SOU.”',
        ],
        list: null,
    },
];

const isHome = computed(() => page.component === 'Home');
const hasSubtitle = computed(() => !!slots.subtitle);

const goHome = () => {
    router.visit(route('home'));
};

const toggleAccountMenu = () => {
    showAccountMenu.value = !showAccountMenu.value;
};

const logout = () => {
    router.post(
        route('logout'),
        {
            _token: csrfToken.value,
        },
        {
            preserveScroll: true,
        },
    );
    showAccountMenu.value = false;
};

const welcomeTextRaised = ref(false);

const startWelcomeSequence = () => {
    showWelcomeModal.value = true;
    showStoryModal.value = false;
    showInstructionsModal.value = false;
    welcomeTextRaised.value = false;
};

const currentStoryStep = computed(() => storySteps[storyPage.value]);
const hasPreviousStory = computed(() => storyPage.value > 0);
const hasNextStory = computed(() => storyPage.value < storySteps.length - 1);

const goToInstructions = () => {
    showWelcomeModal.value = false;
    showStoryModal.value = false;
    showInstructionsModal.value = true;
};

const openStoryModal = () => {
    storyPage.value = 0;
    showStoryModal.value = true;
    showWelcomeModal.value = false;
};

const closeStoryModal = () => {
    showStoryModal.value = false;
    showInstructionsModal.value = true;
};

watch(showWelcomeModal, (visible) => {
    if (!visible) {
        return;
    }
    setTimeout(() => {
        welcomeTextRaised.value = true;
    }, 4000);
});

const nextStoryPage = () => {
    if (hasNextStory.value) {
        storyPage.value += 1;
    } else {
        closeStoryModal();
    }
};

const previousStoryPage = () => {
    if (hasPreviousStory.value) {
        storyPage.value -= 1;
    }
};

const dismissInstructions = () => {
    showInstructionsModal.value = false;
    welcomeTextRaised.value = false;
    showWelcomeModal.value = false;
};

watch(
    () => page.props.flash?.show_onboarding,
    (value) => {
        if (value) {
            startWelcomeSequence();
        }
    },
    { immediate: true },
);

const handleClickOutside = (event) => {
    if (!showAccountMenu.value) return;
    if (!accountMenuRef.value) return;
    if (!accountMenuRef.value.contains(event.target)) {
        showAccountMenu.value = false;
    }
};

onMounted(() => {
    document.addEventListener('click', handleClickOutside);
});

onBeforeUnmount(() => {
    document.removeEventListener('click', handleClickOutside);
});
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
    transition: opacity 0.2s ease;
}
.fade-enter-from,
.fade-leave-to {
    opacity: 0;
}

.flag {
    display: inline-flex;
    width: 80px;
    height: 48px;
    border-radius: 12px;
    box-shadow: 0 12px 25px rgba(15, 23, 42, 0.15);
    overflow: hidden;
    animation: float 2.4s ease-in-out infinite, flagFade 6s ease forwards;
}

.flag-pt {
    background: linear-gradient(90deg, #00643b 0 40%, #c80a3c 40% 100%);
    position: relative;
}
.flag-pt::after {
    content: '';
    position: absolute;
    width: 14px;
    height: 14px;
    border-radius: 50%;
    border: 2px solid rgba(255, 255, 255, 0.9);
    top: 50%;
    left: 40%;
    transform: translate(-50%, -50%);
}

.flag-uk {
    animation-delay: 0.2s;
    background: #012169;
    position: relative;
}
.flag-uk::before,
.flag-uk::after {
    content: '';
    position: absolute;
    inset: 0;
}
.flag-uk::before {
    background:
        linear-gradient(90deg, transparent 45%, #c8102e 45%, #c8102e 55%, transparent 55%),
        linear-gradient(transparent 45%, #c8102e 45%, #c8102e 55%, transparent 55%);
    z-index: 2;
}
.flag-uk::after {
    background:
        linear-gradient(135deg, transparent 48%, #fff 48%, #fff 52%, transparent 52%),
        linear-gradient(-135deg, transparent 48%, #fff 48%, #fff 52%, transparent 52%);
    opacity: 0.9;
    z-index: 1;
}

.flag-br {
    animation-delay: 0.4s;
    background: #009c3b;
    position: relative;
}
.flag-br::before {
    content: '';
    position: absolute;
    width: 58px;
    height: 58px;
    background: #ffdf00;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%) rotate(45deg);
    border-radius: 6px;
    box-shadow: inset 0 0 0 2px rgba(255, 255, 255, 0.2);
}
.flag-br::after {
    content: '';
    position: absolute;
    width: 28px;
    height: 28px;
    border-radius: 50%;
    background: #002776;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
}

@keyframes float {
    0%,
    100% {
        transform: translateY(0);
    }
    50% {
        transform: translateY(-6px);
    }
}

@keyframes flagFade {
    0% {
        opacity: 1;
    }
    80% {
        opacity: 1;
    }
    100% {
        opacity: 0;
    }
}

.welcome-text {
    transform-origin: top;
    transition: transform 1.2s cubic-bezier(0.16, 1, 0.3, 1), opacity 1.2s ease;
}
.welcome-text.raise {
    transform: translateY(-24px);
}

.story-scroll {
    max-height: min(60vh, 480px);
    overflow-y: auto;
    padding-right: 0.25rem;
}

.confetti {
    position: relative;
    width: 56px;
    height: 56px;
}

.confetti-piece {
    position: absolute;
    top: 0;
    left: 50%;
    width: 6px;
    height: 14px;
    border-radius: 2px;
    opacity: 0;
    animation: confetti 2.3s linear infinite;
}

.confetti-piece:nth-child(odd) {
    background: linear-gradient(180deg, #f87171, #fb7185);
}

.confetti-piece:nth-child(even) {
    background: linear-gradient(180deg, #34d399, #10b981);
}

.confetti-piece:nth-child(3n) {
    background: linear-gradient(180deg, #fbbf24, #f97316);
}

.confetti-piece:nth-child(4n) {
    background: linear-gradient(180deg, #818cf8, #6366f1);
}

.confetti-piece:nth-child(5n) {
    background: linear-gradient(180deg, #38bdf8, #3b82f6);
}

.confetti-piece:nth-child(1) { animation-delay: 0s; --drift: -18px; }
.confetti-piece:nth-child(2) { animation-delay: 0.15s; --drift: 14px; }
.confetti-piece:nth-child(3) { animation-delay: 0.3s; --drift: -12px; }
.confetti-piece:nth-child(4) { animation-delay: 0.45s; --drift: 20px; }
.confetti-piece:nth-child(5) { animation-delay: 0.6s; --drift: -6px; }
.confetti-piece:nth-child(6) { animation-delay: 0.75s; --drift: 8px; }
.confetti-piece:nth-child(7) { animation-delay: 0.9s; --drift: -22px; }
.confetti-piece:nth-child(8) { animation-delay: 1.05s; --drift: 16px; }
.confetti-piece:nth-child(9) { animation-delay: 1.2s; --drift: -10px; }
.confetti-piece:nth-child(10) { animation-delay: 1.35s; --drift: 12px; }
.confetti-piece:nth-child(11) { animation-delay: 1.5s; --drift: -4px; }
.confetti-piece:nth-child(12) { animation-delay: 1.65s; --drift: 6px; }
.confetti-piece:nth-child(13) { animation-delay: 1.8s; --drift: -14px; }
.confetti-piece:nth-child(14) { animation-delay: 1.95s; --drift: 22px; }
.confetti-piece:nth-child(15) { animation-delay: 2.1s; --drift: -16px; }
.confetti-piece:nth-child(16) { animation-delay: 2.25s; --drift: 18px; }
.confetti-piece:nth-child(17) { animation-delay: 2.4s; --drift: -20px; }
.confetti-piece:nth-child(18) { animation-delay: 2.55s; --drift: 10px; }
.confetti-piece:nth-child(19) { animation-delay: 2.7s; --drift: -8px; }
.confetti-piece:nth-child(20) { animation-delay: 2.85s; --drift: 24px; }
.confetti-piece:nth-child(21) { animation-delay: 3s; --drift: -24px; }
.confetti-piece:nth-child(22) { animation-delay: 3.15s; --drift: 14px; }
.confetti-piece:nth-child(23) { animation-delay: 3.3s; --drift: -6px; }
.confetti-piece:nth-child(24) { animation-delay: 3.45s; --drift: 18px; }

@keyframes confetti {
    0% {
        transform: translate(-50%, -10%) rotate(0deg);
        opacity: 0;
    }
    10% {
        opacity: 1;
    }
    100% {
        transform: translate(calc(-50% + var(--drift, 12px)), 70px) rotate(320deg);
        opacity: 0;
    }
}
</style>
