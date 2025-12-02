<template>
    <div class="min-h-screen bg-slate-50 text-slate-900 pt-[max(env(safe-area-inset-top),16px)]">
        <main class="mx-auto max-w-3xl px-4 pb-8">
            <header>
                <template v-if="isHome || isDecidir || isPick || isResumo || isCatalog">
                    <div
                        :class="[
                            'home-header-card',
                            isDecidir ? 'home-header-card--decidir' : '',
                            isPick ? 'home-header-card--pick' : '',
                            isResumo ? 'home-header-card--resumo' : '',
                            isCatalog ? 'home-header-card--catalog' : '',
                        ]"
                    >
                        <div v-if="isDecidir || isPick || isResumo || isCatalog" class="mb-3 flex items-center justify-between gap-3">
                            <button
                                type="button"
                                aria-label="Voltar para início"
                                class="decidir-back-button"
                                :class="{
                                    'decidir-back-button--pick': isPick && !isDecidir,
                                    'decidir-back-button--resumo': isResumo && !isDecidir && !isPick,
                                    'decidir-back-button--catalog': isCatalog && !isDecidir && !isPick && !isResumo,
                                }"
                                @click="goHome"
                            >
                                <ArrowLeft class="h-4 w-4" />
                                <span>Voltar</span>
                            </button>
                        <div v-if="currentUser" ref="accountMenuRef" class="relative">
                            <button
                                type="button"
                                class="profile-chip"
                                :class="{
                                    'profile-chip--warm': isPick,
                                    'profile-chip--cool': (isResumo && !isPick) || isCatalog,
                                }"
                                @click.stop="toggleAccountMenu"
                            >
                                <span class="profile-chip__icon-wrap">
                                <TileIcon3D :tone="profileChipTone" class="profile-chip__icon">
                                    <span class="profile-chip__initials">{{ userInitials }}</span>
                                </TileIcon3D>
                                </span>
                                    <span class="profile-chip__text hidden text-left leading-tight sm:block">
                                        <span class="block text-sm font-semibold text-slate-800">{{ currentUser.name }}</span>
                                        <span class="text-xs text-slate-400">{{ currentUser.email }}</span>
                                    </span>
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
                                            Sair do EasyTrip
                                        </button>
                                    </div>
                                </transition>
                            </div>
                        </div>
                        <div
                            v-if="isDecidir || isPick || isResumo || isCatalog"
                            class="inline-flex items-center gap-2 rounded-full bg-slate-100/90 px-3 py-1 text-xs font-semibold text-slate-600"
                        >
                            <span aria-hidden="true">🌍</span>
                            <span>Mudança UK → Brasil</span>
                        </div>
                        <div v-else class="flex items-start justify-between gap-3">
                            <div class="inline-flex items-center gap-2 rounded-full bg-slate-100/90 px-3 py-1 text-xs font-semibold text-slate-600">
                                <span aria-hidden="true">🌍</span>
                                <span>Mudança UK → Brasil</span>
                            </div>
                            <div v-if="currentUser" ref="accountMenuRef" class="relative">
                                <button type="button" class="profile-chip" @click.stop="toggleAccountMenu">
                                    <span class="profile-chip__icon-wrap">
                                        <TileIcon3D tone="indigo" class="profile-chip__icon">
                                            <span class="profile-chip__initials">{{ userInitials }}</span>
                                        </TileIcon3D>
                                    </span>
                                    <span class="profile-chip__text hidden text-left leading-tight sm:block">
                                        <span class="block text-sm font-semibold text-slate-800">{{ currentUser.name }}</span>
                                        <span class="text-xs text-slate-400">{{ currentUser.email }}</span>
                                    </span>
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
                                            Sair do EasyTrip
                                        </button>
                                    </div>
                                </transition>
                            </div>
                        </div>
                        <div class="mt-4 space-y-1">
                            <div v-if="isDecidir" class="flex items-start gap-3">
                                <TileIcon3D tone="indigo" class="decidir-header-icon">
                                    <Sparkles class="h-5 w-5" />
                                </TileIcon3D>
                                <div class="space-y-1">
                                    <p class="text-[11px] font-semibold uppercase tracking-[0.4em] text-indigo-400">Etapa 02 • Decidir</p>
                                    <h1 class="text-3xl font-semibold text-slate-900 sm:text-[2rem]">
                                        <slot name="title" />
                                    </h1>
                                    <p v-if="hasSubtitle" class="text-base text-slate-600 sm:text-lg">
                                        <slot name="subtitle" />
                                    </p>
                                </div>
                            </div>
                            <div v-else-if="isPick" class="flex items-start gap-3">
                                <TileIcon3D tone="amber" class="pick-header-icon">
                                    <Package class="h-5 w-5" />
                                </TileIcon3D>
                                <div class="space-y-1">
                                    <p class="text-[11px] font-semibold uppercase tracking-[0.4em] text-amber-400">Etapa 03 • Embalar</p>
                                    <h1 class="text-3xl font-semibold text-slate-900 sm:text-[2rem]">
                                        <slot name="title" />
                                    </h1>
                                    <p v-if="hasSubtitle" class="text-base text-slate-600 sm:text-lg">
                                        <slot name="subtitle" />
                                    </p>
                                </div>
                            </div>
                            <div v-else-if="isResumo" class="flex items-start gap-3">
                                <TileIcon3D tone="slate" class="resumo-header-icon">
                                    <Layers3 class="h-5 w-5" />
                                </TileIcon3D>
                                <div class="space-y-1">
                                    <p class="text-[11px] font-semibold uppercase tracking-[0.4em] text-slate-400">Etapa 04 • Resumo</p>
                                    <h1 class="text-3xl font-semibold text-slate-900 sm:text-[2rem]">
                                        <slot name="title" />
                                    </h1>
                                    <p v-if="hasSubtitle" class="text-base text-slate-600 sm:text-lg">
                                        <slot name="subtitle" />
                                    </p>
                                </div>
                            </div>
                            <div v-else-if="isCatalog" class="flex items-start gap-3">
                                <TileIcon3D tone="emerald" class="catalog-header-icon">
                                    <Camera class="h-5 w-5" />
                                </TileIcon3D>
                                <div class="space-y-1">
                                    <p class="text-[11px] font-semibold uppercase tracking-[0.4em] text-emerald-400">Etapa 01 • Catalogar</p>
                                    <h1 class="text-3xl font-semibold text-slate-900 sm:text-[2rem]">
                                        <slot name="title" />
                                    </h1>
                                    <p v-if="hasSubtitle" class="text-base text-slate-600 sm:text-lg">
                                        <slot name="subtitle" />
                                    </p>
                                </div>
                            </div>
                            <template v-else>
                                <h1 class="text-3xl font-semibold text-slate-900 sm:text-[2rem]">
                                    <slot name="title" />
                                </h1>
                                <p v-if="hasSubtitle" class="text-base text-slate-600 sm:text-lg">
                                    <slot name="subtitle" />
                                </p>
                            </template>
                        </div>
                    </div>
                </template>
                <template v-else>
                    <div class="space-y-3 text-left">
                        <div class="flex items-start justify-between gap-3 sm:items-center sm:gap-4">
                            <button
                                type="button"
                                aria-label="Voltar"
                                class="inline-flex items-center gap-2 rounded-2xl bg-white/80 px-3 py-2 text-slate-700 shadow-sm ring-1 ring-black/5 transition hover:bg-white focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-500/40"
                                @click="goHome"
                            >
                                <ArrowLeft class="h-4 w-4" />
                                <span class="text-sm font-medium">Voltar</span>
                            </button>

                            <div class="space-y-2 text-left">
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
                                    <span class="profile-chip__icon-wrap profile-chip__icon-wrap--compact">
                                        <TileIcon3D :tone="profileChipTone" class="profile-chip__icon profile-chip__icon--compact">
                                            <span class="profile-chip__initials">{{ userInitials }}</span>
                                        </TileIcon3D>
                                    </span>
                                    <div class="profile-chip__text text-left leading-tight hidden sm:block">
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
                                            Sair do EasyTrip
                                        </button>
                                    </div>
                                </transition>
                            </div>
                        </div>

                        <div class="border-t border-slate-200/80 shadow-[0_1px_0_rgba(0,0,0,0.02)]"></div>
                    </div>
                </template>
            </header>

            <section :class="isHome ? 'mt-6 space-y-6 sm:space-y-8' : 'mt-6 space-y-6 sm:space-y-8'">
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

            <div class="space-y-6 transition-all duration-700 ease-out" :class="welcomeTextRaised ? 'pt-0' : 'pt-1'">
                <div
                    class="welcome-flags flex flex-wrap items-center justify-center gap-4 rounded-3xl bg-white/70 p-4 ring-1 ring-white/70"
                    :class="{ 'welcome-flags--hidden': welcomeTextRaised }"
                >
                    <span class="flag flag-pt" aria-label="Portugal"></span>
                    <span class="flag flag-uk" aria-label="Reino Unido"></span>
                    <span class="flag flag-br" aria-label="Brasil"></span>
                </div>

                <div
                    class="welcome-journey relative overflow-hidden rounded-3xl bg-gradient-to-br from-slate-900 via-slate-800 to-slate-900 p-5 text-white shadow-lg"
                    :class="{ 'welcome-journey--raised': welcomeTextRaised }"
                >
                    <div class="absolute inset-0 opacity-30 [mask-image:radial-gradient(circle_at_top,_white,_transparent)]"></div>
                    <div class="relative mb-4 flex flex-col items-start gap-3">
                        <p class="text-base font-semibold text-white sm:text-lg">
                            A viagem começa com coragem, fé e uma ponte entre mundos.
                        </p>
                        <div class="welcome-scroll-hint" aria-hidden="true">
                            <span class="welcome-scroll-hint__text">Role para continuar</span>
                            <span class="welcome-scroll-hint__arrow">↓</span>
                        </div>
                    </div>

                    <div class="space-y-3">
                        <article class="welcome-step">
                        <div class="welcome-step__marker" aria-hidden="true">1</div>
                        <p>
                            Em abril tomei uma das decisões mais difíceis da minha vida: deixar para trás o país que me estendeu uma ponte quando resolvi sair do meu berço e gatinhar em direção a algo maior.
                        </p>
                        </article>
                        <article class="welcome-step">
                        <div class="welcome-step__marker" aria-hidden="true">2</div>
                        <p>
                            A ponte era firme para suportar tempestades e suave para me amparar em cada queda — desde os primeiros passos até o chão que me acolheu por 20 anos.
                        </p>
                        </article>
                        <article class="welcome-step">
                        <div class="welcome-step__marker" aria-hidden="true">3</div>
                        <p>
                            Hoje, a pouco mais de um mês da minha chegada à terra que será o meu próximo chão, celebro o nascimento da EasyTrip.
                            <button
                                type="button"
                                class="welcome-story-link"
                                @click="openStoryModal"
                            >
                                Clica aqui
                            </button>
                            <span> para saber mais.</span>
                        </p>
                        </article>
                    </div>
                </div>
            </div>

            <template #footer>
                <button
                    type="button"
                    class="inline-flex items-center gap-2 rounded-full border border-emerald-200 bg-transparent px-4 py-2 text-sm font-semibold text-emerald-600 shadow-none transition hover:bg-emerald-50 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-100"
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
                        <h2 class="text-2xl font-bold text-slate-900 leading-tight">A história por trás da EasyTrip</h2>
                    </div>
                    <div class="confetti" aria-hidden="true">
                        <span v-for="n in 24" :key="n" class="confetti-piece"></span>
                    </div>
                </div>
            </template>

            <div class="story-scroll space-y-4 text-sm text-slate-700 sm:text-base">
                <div class="story-hero">
                    <p class="story-hero__label">Linha do tempo</p>
                    <p class="story-hero__text">
                        Acompanhe a jornada abaixo.
                    </p>
                </div>

                <div class="story-timeline space-y-4">
                    <article
                        v-for="(paragraph, index) in currentStoryStep.paragraphs"
                        :key="`story-${storyPage}-${index}`"
                        class="story-card"
                        :class="{ 'story-card--last': index === currentStoryStep.paragraphs.length - 1 }"
                    >
                        <div class="story-card__marker" aria-hidden="true">
                            <span>{{ index + 1 }}</span>
                        </div>
                        <p>
                            {{ paragraph }}
                        </p>
                    </article>
                </div>
                <ul
                    v-if="currentStoryStep.list"
                    class="story-list"
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
                <p class="text-xs font-semibold uppercase tracking-wide text-emerald-500">Instruções básicas</p>
                <h2 class="text-2xl font-bold text-slate-900">Como usar a EasyTrip</h2>
            </template>

            <ol class="instruction-steps space-y-3">
                <li
                    v-for="(step, index) in instructionSteps"
                    :key="step.title"
                    class="instruction-step"
                >
                    <span
                        class="instruction-step__icon"
                        :class="`instruction-step__icon--${step.tone}`"
                        aria-hidden="true"
                    >
                        {{ step.icon }}
                    </span>
                    <div>
                        <h3 class="text-sm font-semibold" :class="step.headingClass">
                            {{ step.title }}
                        </h3>
                        <p class="text-sm" :class="step.bodyClass">
                            {{ step.description }}
                        </p>
                    </div>
                </li>
            </ol>

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
import { ArrowLeft, Camera, Layers3, Package, Sparkles } from 'lucide-vue-next';
import { router, usePage } from '@inertiajs/vue3';
import { route } from 'ziggy-js';
import ToastHub from '@/Components/ToastHub.vue';
import OverlayModal from '@/Components/OverlayModal.vue';
import ScrollTopButton from '@/Components/ScrollTopButton.vue';
import TileIcon3D from '@/Components/home/TileIcon3D.vue';

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
            'A EasyTrip nasceu de uma iluminação de Deus, do poder do amor e da vontade inigualável que enchem o meu coração e a minha alma — mesmo em tempos de guerra, dor, lágrimas e suor.',
            'Sem saber por onde ou como começar, orei para que Deus me guiasse e me desse clareza a cada etapa da jornada. A resposta veio em forma de amor — uma ideia simples que me aproximou de alguém que me é muito especial (ela sabe quem é), tornou menores os obstáculos e transformou o que antes parecia impossível.',
            'Antes que a EasyTrip existisse, EU SOU.',
        ],
        list: null,
    },
];

const instructionSteps = [
    {
        title: '1. Catalogar',
        description: 'Fotografe e descreva cada item como se fosse uma memória — peso, volume, notas especiais.',
        icon: '📸',
        tone: 'emerald',
        headingClass: 'text-emerald-800',
        bodyClass: 'text-emerald-700',
    },
    {
        title: '2. Decidir',
        description: 'No swipe deck, defina se o item vai, fica ou espera. Gestos e botões têm o mesmo encanto.',
        icon: '🌀',
        tone: 'sky',
        headingClass: 'text-sky-800',
        bodyClass: 'text-sky-700',
    },
    {
        title: '3. Embalar & Resumo',
        description: 'Distribua peso/volume entre as malas e acompanhe os totais. Se algo encher demais, o EasyTrip avisa.',
        icon: '🧳',
        tone: 'amber',
        headingClass: 'text-amber-800',
        bodyClass: 'text-amber-700',
    },
];

const isHome = computed(() => page.component === 'Home');
const isDecidir = computed(() => page.component === 'Decidir/Index');
const isPick = computed(() => page.component === 'Pick/Index');
const isResumo = computed(() => page.component === 'Resumo/Index');
const isCatalog = computed(() => page.component === 'Catalogar/Index');
const profileChipTone = computed(() => {
    if (isPick.value) return 'amber';
    if (isResumo.value) return 'slate';
    if (isCatalog.value) return 'emerald';
    return 'indigo';
});
const hasSubtitle = computed(() => !!slots.subtitle);
const onboardingModalsEnabled = computed(() => Boolean(page.props.ui?.onboarding_modals_enabled ?? true));

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
        if (value && onboardingModalsEnabled.value) {
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
.home-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 1.25rem;
    border-radius: 2rem;
    padding: 1.5rem;
    background: rgba(255, 255, 255, 0.92);
    border: 1px solid rgba(148, 163, 184, 0.3);
    box-shadow: 0 35px 70px rgba(15, 23, 42, 0.08);
    backdrop-filter: blur(12px);
}
.profile-chip {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    position: relative;
    isolation: isolate;
    overflow: hidden;
    background: transparent;
    padding: 0.28rem 0.7rem;
    border-radius: 999px;
    border: 1px solid rgba(148, 163, 184, 0.2);
    box-shadow: 0 8px 20px rgba(15, 23, 42, 0.09);
    transition: transform 0.18s ease;
}
.profile-chip::before,
.profile-chip::after {
    content: '';
    position: absolute;
    inset: 0;
    border-radius: inherit;
    z-index: -2;
    transition: opacity 0.3s ease;
}
.profile-chip::before {
    background-image: radial-gradient(circle at 20% 15%, rgba(255, 255, 255, 0.5), transparent 48%);
    opacity: 0.7;
}
.profile-chip::after {
    background-image: linear-gradient(130deg, rgba(209, 213, 219, 0.95), rgba(191, 219, 254, 0.9), rgba(229, 231, 235, 0.95));
    background-size: 180% 180%;
    animation: profileChipGradient 32s ease infinite;
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.75),
        inset 0 -1px 0 rgba(15, 23, 42, 0.18);
    opacity: 0.88;
}

.profile-chip:active {
    transform: scale(0.97);
}
.profile-chip__text {
    color: #0f172a;
}
.profile-chip--warm {
    border-color: rgba(249, 115, 22, 0.3);
    box-shadow: 0 15px 35px rgba(249, 115, 22, 0.15);
}
.profile-chip--warm .profile-chip__icon-wrap {
    background:
        linear-gradient(145deg, rgba(255, 237, 213, 0.8), rgba(251, 191, 36, 0.6)),
        radial-gradient(circle at 35% 25%, rgba(255, 255, 255, 0.55), transparent 60%);
}
.profile-chip--cool {
    border-color: rgba(148, 163, 184, 0.35);
    box-shadow: 0 15px 35px rgba(148, 163, 184, 0.18);
}
.profile-chip--cool .profile-chip__icon-wrap {
    background:
        linear-gradient(145deg, rgba(241, 245, 249, 0.85), rgba(148, 163, 184, 0.6)),
        radial-gradient(circle at 35% 25%, rgba(255, 255, 255, 0.55), transparent 60%);
}

.profile-chip__icon-wrap {
    display: inline-flex;
    padding: 0.16rem;
    border-radius: 999px;
    background:
        linear-gradient(150deg, rgba(255, 255, 255, 0.4), rgba(248, 250, 252, 0.6)),
        radial-gradient(circle at 35% 25%, rgba(255, 255, 255, 0.55), transparent 60%);
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.85),
        0 6px 16px rgba(15, 23, 42, 0.12);
}
.profile-chip__icon-wrap--compact {
    padding: 0.12rem;
}
.profile-chip__icon {
    --tile-icon-size: 2rem;
}
.profile-chip__icon--compact {
    --tile-icon-size: 1.85rem;
}
.profile-chip__initials {
    font-size: 1rem;
    font-weight: 700;
    letter-spacing: 0.05em;
    color: white;
}
.profile-chip:hover::after {
    opacity: 1;
}
.profile-chip:active::after {
    opacity: 0.85;
}

@keyframes profileChipGradient {
    0% {
        background-position: 0% 50%;
    }
    50% {
        background-position: 100% 50%;
    }
    100% {
        background-position: 0% 50%;
    }
}
.home-header-card {
    border-radius: 1.75rem;
    padding: 1.75rem;
    background: rgba(255, 255, 255, 0.9);
    border: 1px solid rgba(148, 163, 184, 0.25);
    box-shadow: 0 20px 50px rgba(15, 23, 42, 0.08);
    backdrop-filter: blur(10px);
}
.home-header-card--decidir {
    position: relative;
    overflow: hidden;
    background: radial-gradient(circle at top right, rgba(99, 102, 241, 0.12), transparent 60%), rgba(255, 255, 255, 0.95);
}
.home-header-card--decidir::before,
.home-header-card--decidir::after {
    content: '';
    position: absolute;
    inset: 0;
    border-radius: inherit;
    pointer-events: none;
}
.home-header-card--decidir::before {
    background: radial-gradient(circle at 20% -10%, rgba(236, 233, 255, 0.9), transparent 55%);
    opacity: 0.8;
}
.home-header-card--decidir::after {
    background: linear-gradient(135deg, rgba(79, 70, 229, 0.12), rgba(14, 165, 233, 0.12));
    animation: decidirAurora 28s ease infinite;
}
.home-header-card--decidir > * {
    position: relative;
}
.decidir-header-icon {
    --tile-icon-size: 3.1rem;
}
.home-header-card--pick {
    position: relative;
    overflow: hidden;
    background: radial-gradient(circle at top left, rgba(251, 191, 36, 0.15), transparent 60%), rgba(255, 255, 255, 0.95);
}
.home-header-card--pick::before,
.home-header-card--pick::after {
    content: '';
    position: absolute;
    inset: 0;
    border-radius: inherit;
    pointer-events: none;
}
.home-header-card--pick::before {
    background: radial-gradient(circle at 80% -20%, rgba(254, 226, 226, 0.85), transparent 55%);
    opacity: 0.9;
}
.home-header-card--pick::after {
    background: linear-gradient(135deg, rgba(251, 146, 60, 0.14), rgba(249, 115, 22, 0.15), rgba(236, 72, 153, 0.16));
    animation: pickAurora 32s ease infinite;
}
.home-header-card--pick > * {
    position: relative;
}
.home-header-card--resumo {
    position: relative;
    overflow: hidden;
    background: radial-gradient(circle at top left, rgba(191, 219, 254, 0.2), transparent 55%), rgba(255, 255, 255, 0.95);
}
.home-header-card--resumo::before,
.home-header-card--resumo::after {
    content: '';
    position: absolute;
    inset: 0;
    border-radius: inherit;
    pointer-events: none;
}
.home-header-card--resumo::before {
    background: radial-gradient(circle at 90% -20%, rgba(224, 231, 255, 0.9), transparent 55%);
    opacity: 0.85;
}
.home-header-card--resumo::after {
    background: linear-gradient(135deg, rgba(14, 165, 233, 0.16), rgba(79, 70, 229, 0.14));
    animation: resumoAurora 28s ease infinite;
}
.home-header-card--resumo > * {
    position: relative;
}
.resumo-header-icon {
    --tile-icon-size: 3.1rem;
    animation: floatIcon 11s ease-in-out infinite;
}
.home-header-card--catalog {
    position: relative;
    overflow: hidden;
    background: radial-gradient(circle at top left, rgba(16, 185, 129, 0.12), transparent 55%), rgba(255, 255, 255, 0.96);
}
.home-header-card--catalog::before,
.home-header-card--catalog::after {
    content: '';
    position: absolute;
    inset: 0;
    border-radius: inherit;
    pointer-events: none;
}
.home-header-card--catalog::before {
    background: radial-gradient(circle at 85% -15%, rgba(167, 243, 208, 0.9), transparent 55%);
    opacity: 0.85;
}
.home-header-card--catalog::after {
    background: linear-gradient(135deg, rgba(16, 185, 129, 0.14), rgba(45, 212, 191, 0.16), rgba(6, 182, 212, 0.14));
    animation: catalogAurora 30s ease infinite;
}
.home-header-card--catalog > * {
    position: relative;
}
.catalog-header-icon {
    --tile-icon-size: 3.1rem;
    animation: floatIcon 9s ease-in-out infinite;
}
.pick-header-icon {
    --tile-icon-size: 3.1rem;
    animation: floatIcon 10s ease-in-out infinite;
}
.decidir-back-button {
    display: inline-flex;
    align-items: center;
    gap: 0.45rem;
    border-radius: 999px;
    padding: 0.4rem 0.85rem;
    font-size: 0.85rem;
    font-weight: 600;
    color: #334155;
    background: rgba(255, 255, 255, 0.92);
    border: 1px solid rgba(148, 163, 184, 0.35);
    box-shadow: 0 10px 20px rgba(15, 23, 42, 0.08);
    transition: background 0.2s ease, transform 0.2s ease;
}
.decidir-back-button:active {
    transform: scale(0.97);
}
.decidir-back-button--pick {
    color: #9a3412;
    border-color: rgba(249, 115, 22, 0.25);
    background: rgba(255, 247, 237, 0.9);
    box-shadow: 0 12px 25px rgba(249, 115, 22, 0.18);
}
.decidir-back-button--resumo {
    color: #0f172a;
    border-color: rgba(59, 130, 246, 0.3);
    background: rgba(226, 232, 240, 0.9);
    box-shadow: 0 12px 25px rgba(59, 130, 246, 0.16);
}
.decidir-back-button--catalog {
    color: #065f46;
    border-color: rgba(16, 185, 129, 0.35);
    background: rgba(222, 247, 236, 0.95);
    box-shadow: 0 12px 25px rgba(16, 185, 129, 0.18);
}
@keyframes catalogAurora {
    0% {
        opacity: 0.55;
        transform: translate3d(0, 0, 0);
    }
    50% {
        opacity: 0.9;
        transform: translate3d(-12px, 8px, 0);
    }
    100% {
        opacity: 0.55;
        transform: translate3d(0, 0, 0);
    }
}
@keyframes pickAurora {
    0% {
        opacity: 0.55;
        transform: translate3d(0, 0, 0);
    }
    50% {
        opacity: 0.85;
        transform: translate3d(10px, -12px, 0);
    }
    100% {
        opacity: 0.55;
        transform: translate3d(0, 0, 0);
    }
}
@keyframes floatIcon {
    0%,
    100% {
        transform: translateY(0);
    }
    50% {
        transform: translateY(-4px);
    }
}
@keyframes decidirAurora {
    0% {
        opacity: 0.55;
        transform: translate3d(0, 0, 0);
    }
    50% {
        opacity: 0.85;
        transform: translate3d(-10px, -8px, 0);
    }
    100% {
        opacity: 0.55;
        transform: translate3d(0, 0, 0);
    }
}
@keyframes resumoAurora {
    0% {
        opacity: 0.55;
        transform: translate3d(0, 0, 0);
    }
    50% {
        opacity: 0.85;
        transform: translate3d(12px, -10px, 0);
    }
    100% {
        opacity: 0.55;
        transform: translate3d(0, 0, 0);
    }
}
.fade-enter-active,
.fade-leave-active {
    transition: opacity 0.2s ease;
}
.fade-enter-from,
.fade-leave-to {
    opacity: 0;
}

.welcome-flags {
    transition:
        opacity 0.8s ease,
        transform 0.8s ease,
        height 0.6s ease,
        margin 0.6s ease,
        padding 0.6s ease;
}
.welcome-flags span {
    flex-shrink: 0;
}
.welcome-flags--hidden {
    opacity: 0;
    transform: translateY(-16px);
    height: 0;
    margin: 0;
    padding: 0;
    pointer-events: none;
}

.welcome-journey {
    border: 1px solid rgba(255, 255, 255, 0.08);
    box-shadow: 0 25px 45px rgba(15, 23, 42, 0.35);
    transition: transform 0.8s cubic-bezier(0.2, 0.8, 0.2, 1);
}
.welcome-journey--raised {
    transform: translateY(-14px);
}

.welcome-scroll-hint {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    font-size: 0.85rem;
    letter-spacing: 0.05em;
    text-transform: uppercase;
    color: rgba(255, 255, 255, 0.75);
}
.welcome-scroll-hint__arrow {
    display: inline-flex;
    width: 1.5rem;
    height: 1.5rem;
    align-items: center;
    justify-content: center;
    border-radius: 999px;
    border: 1px solid rgba(255, 255, 255, 0.4);
    animation: arrowBounce 1.2s ease-in-out infinite;
}

@keyframes arrowBounce {
    0%,
    100% {
        transform: translateY(0);
    }
    50% {
        transform: translateY(4px);
    }
}

.welcome-step {
    display: flex;
    gap: 0.75rem;
    border-radius: 1.5rem;
    padding: 1rem;
    background-color: rgba(255, 255, 255, 0.1);
    backdrop-filter: blur(6px);
    color: rgba(255, 255, 255, 0.92);
    font-size: 0.95rem;
}

.welcome-step__marker {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 2.25rem;
    height: 2.25rem;
    border-radius: 999px;
    background: rgba(16, 185, 129, 0.18);
    border: 1px solid rgba(16, 185, 129, 0.4);
    font-weight: 600;
    font-size: 0.9rem;
}

.story-card {
    position: relative;
    display: flex;
    gap: 0.75rem;
    border-radius: 1.25rem;
    background: rgba(248, 250, 252, 0.9);
    padding: 1rem;
    border: 1px solid rgba(15, 23, 42, 0.05);
}

.story-hero {
    border-radius: 1.5rem;
    padding: 1.25rem;
    background: linear-gradient(135deg, rgba(254, 243, 199, 0.8), rgba(251, 191, 36, 0.5));
    border: 1px solid rgba(180, 83, 9, 0.35);
    box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.4);
}
.story-hero__label {
    font-size: 0.75rem;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    font-weight: 700;
    color: #b45309;
    margin-bottom: 0.25rem;
}
.story-hero__text {
    font-size: 0.95rem;
    color: #7c2d12;
    line-height: 1.5;
}

.story-timeline {
    position: relative;
    padding-left: 0.5rem;
}
.story-timeline::before {
    content: '';
    position: absolute;
    left: 1.4rem;
    top: 0.5rem;
    bottom: 0.5rem;
    width: 2px;
    background: linear-gradient(180deg, rgba(15, 23, 42, 0.15), rgba(15, 23, 42, 0));
}
.story-card {
    padding: 1rem 1rem 1rem 3rem;
}
.story-card::before {
    content: '';
    position: absolute;
    left: 1.48rem;
    top: 2rem;
    bottom: -0.75rem;
    width: 2px;
    background: rgba(251, 191, 36, 0.8);
}
.story-card--last::before {
    display: none;
}
.story-card__marker {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 2.25rem;
    height: 2.25rem;
    border-radius: 999px;
    background: linear-gradient(135deg, rgba(251, 191, 36, 0.85), rgba(249, 115, 22, 0.85));
    color: #fff7ed;
    font-weight: 700;
}

.story-list {
    list-style: none;
    padding: 1rem;
    border-radius: 1.25rem;
    background: rgba(254, 243, 199, 0.6);
    border: 1px dashed rgba(180, 83, 9, 0.4);
    color: #92400e;
}
.story-list li + li {
    margin-top: 0.35rem;
}

.instruction-step {
    display: flex;
    gap: 0.75rem;
    border-radius: 1.25rem;
    padding: 1rem;
    background: white;
    border: 1px solid rgba(15, 23, 42, 0.08);
    box-shadow: 0 10px 25px rgba(15, 23, 42, 0.08);
    align-items: flex-start;
}

.instruction-step__icon {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 2.5rem;
    height: 2.5rem;
    border-radius: 1rem;
    font-size: 1.2rem;
    box-shadow: inset 0 0 0 2px rgba(255, 255, 255, 0.6);
}

.instruction-step__icon--emerald {
    background: linear-gradient(135deg, #d1fae5, #6ee7b7);
    color: #065f46;
}
.instruction-step__icon--sky {
    background: linear-gradient(135deg, #e0f2fe, #7dd3fc);
    color: #0c4a6e;
}
.instruction-step__icon--amber {
    background: linear-gradient(135deg, #fef3c7, #fcd34d);
    color: #92400e;
}

.welcome-story-link {
    position: relative;
    margin-left: 0.5rem;
    display: inline-flex;
    align-items: center;
    gap: 0.35rem;
    padding: 0.35rem 0.85rem;
    border-radius: 999px;
    font-weight: 600;
    color: #ecfdf5;
    background: linear-gradient(130deg, rgba(34, 197, 94, 0.9) 0%, rgba(5, 150, 105, 0.92) 60%, rgba(16, 185, 129, 0.98) 100%);
    border: 1px solid rgba(5, 150, 105, 0.55);
    background-size: 200% 200%;
    text-decoration: none;
    transition: transform 0.25s ease, background 0.25s ease;
    animation: pulseLink 1.8s ease-in-out infinite, gradientShift 3s ease-in-out infinite;
    box-shadow: 0 12px 30px rgba(6, 78, 59, 0.25);
}
.welcome-story-link::after {
    content: '→';
    font-size: 0.95em;
    transition: transform 0.25s ease;
}
.welcome-story-link:hover {
    background-position: 100% 0;
    transform: translateY(-1px);
}
.welcome-story-link:hover::after {
    transform: translateX(2px);
}

@keyframes pulseLink {
    0%,
    100% {
        box-shadow: 0 0 0 0 rgba(16, 185, 129, 0.3);
    }
    70% {
        box-shadow: 0 0 0 8px rgba(16, 185, 129, 0);
    }
}

@keyframes gradientShift {
    0% {
        background-position: 0 0;
    }
    50% {
        background-position: 100% 0;
    }
    100% {
        background-position: 0 0;
    }
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
