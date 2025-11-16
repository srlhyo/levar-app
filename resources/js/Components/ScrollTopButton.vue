<template>
    <transition name="fade">
        <button
            v-if="visible"
            type="button"
            class="scroll-top-btn fixed bottom-6 right-5 z-[9998] inline-flex h-11 w-11 items-center justify-center rounded-full bg-white/15 text-slate-900 shadow-lg shadow-black/5 backdrop-blur-3xl ring-1 ring-white/40 transition hover:bg-white/30 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-white"
            @click="scrollToTop"
            aria-label="Voltar ao topo"
        >
            <span class="scroll-top-arrow">↑</span>
        </button>
    </transition>
</template>

<script setup>
import { onBeforeUnmount, onMounted, ref, watch } from 'vue';

const props = defineProps({
    targets: {
        type: Array,
        default: () => [],
    },
    threshold: {
        type: Number,
        default: 320,
    },
});

const visible = ref(false);
const attachedTargets = new Set();

const resolveTargetElements = () =>
    props.targets
        .map((entry) => {
            if (!entry) return null;
            if (typeof entry.value !== 'undefined') {
                return entry.value;
            }
            if (typeof entry === 'function') {
                return entry();
            }
            return entry;
        })
        .filter((el) => el);

const updateVisibility = () => {
    const winScrolled = typeof window !== 'undefined' ? window.scrollY > props.threshold : false;
    const targetScrolled = resolveTargetElements().some((el) => el?.scrollTop > props.threshold);
    visible.value = winScrolled || targetScrolled;
};

const detachTargetListeners = () => {
    attachedTargets.forEach((el) => {
        el.removeEventListener('scroll', updateVisibility);
    });
    attachedTargets.clear();
};

const attachTargetListeners = () => {
    detachTargetListeners();
    resolveTargetElements().forEach((el) => {
        if (!el || attachedTargets.has(el)) return;
        el.addEventListener('scroll', updateVisibility, { passive: true });
        attachedTargets.add(el);
    });
};

const scrollToTop = () => {
    if (typeof window !== 'undefined') {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }
    resolveTargetElements().forEach((el) => {
        if (el?.scrollTo) {
            el.scrollTo({ top: 0, behavior: 'smooth' });
        }
    });
};

onMounted(() => {
    if (typeof window !== 'undefined') {
        window.addEventListener('scroll', updateVisibility, { passive: true });
    }
    attachTargetListeners();
    updateVisibility();
});

onBeforeUnmount(() => {
    if (typeof window !== 'undefined') {
        window.removeEventListener('scroll', updateVisibility);
    }
    detachTargetListeners();
});

watch(
    () => props.targets.map((entry) => entry?.value ?? entry),
    () => {
        attachTargetListeners();
        updateVisibility();
    },
    { immediate: true },
);
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

.scroll-top-btn {
    animation: floatPulse 2.4s ease-in-out infinite;
    box-shadow: 0 18px 38px rgba(15, 23, 42, 0.18);
}
.scroll-top-btn::after {
    content: '';
    position: absolute;
    inset: 4px;
    border-radius: inherit;
    background: radial-gradient(circle at 30% 30%, rgba(16, 185, 129, 0.35), transparent 55%);
    opacity: 0;
    transition: opacity 0.3s ease;
    pointer-events: none;
}
.scroll-top-btn:hover::after,
.scroll-top-btn:focus-visible::after {
    opacity: 0.8;
}

.scroll-top-arrow {
    display: inline-block;
    font-size: 1.2rem;
    font-weight: 600;
    text-shadow: 0 4px 14px rgba(15, 118, 110, 0.25);
    animation: arrowBounce 2.2s ease-in-out infinite, arrowPulse 3s ease-in-out infinite;
}

@keyframes floatPulse {
    0%,
    100% {
        transform: translateY(0) scale(1);
        box-shadow: 0 18px 38px rgba(15, 23, 42, 0.18);
    }
    50% {
        transform: translateY(-5px) scale(1.03);
        box-shadow: 0 24px 48px rgba(16, 185, 129, 0.25);
    }
}

@keyframes arrowBounce {
    0%,
    100% {
        transform: translateY(0);
    }
    50% {
        transform: translateY(-2px);
    }
}

@keyframes arrowPulse {
    0%,
    100% {
        opacity: 0.85;
    }
    50% {
        opacity: 1;
    }
}
</style>
