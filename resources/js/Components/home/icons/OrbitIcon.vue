<template>
    <div class="orbit-icon" :class="toneClass" aria-hidden="true">
        <span class="orbit-icon__core"></span>
        <span class="orbit-icon__ring orbit-icon__ring--one"></span>
        <span class="orbit-icon__ring orbit-icon__ring--two"></span>
    </div>
</template>

<script setup>
import { computed } from 'vue';

const props = defineProps({
    tone: {
        type: String,
        default: 'emerald',
    },
});

const palette = {
    emerald: 'from-emerald-400 via-teal-400 to-emerald-600',
    indigo: 'from-indigo-400 via-sky-400 to-indigo-600',
    amber: 'from-amber-400 via-orange-400 to-rose-500',
    slate: 'from-slate-200 via-slate-300 to-slate-500',
};

const toneClass = computed(() => palette[props.tone] ?? palette.emerald);
</script>

<style scoped>
.orbit-icon {
    position: relative;
    width: 72px;
    height: 72px;
    border-radius: 1.75rem;
    display: grid;
    place-items: center;
    overflow: hidden;
    background: rgba(255, 255, 255, 0.05);
}

.orbit-icon::before {
    content: '';
    position: absolute;
    inset: 6px;
    border-radius: inherit;
    background-image: linear-gradient(var(--tw-gradient-stops));
    animation: float 6s ease-in-out infinite;
    filter: blur(6px);
    opacity: 0.35;
}

.orbit-icon__core {
    position: relative;
    width: 36px;
    height: 36px;
    border-radius: 999px;
    background-image: linear-gradient(var(--tw-gradient-stops));
    animation: pulse 5s ease-in-out infinite;
    box-shadow: 0 8px 25px rgba(15, 23, 42, 0.35);
}

.orbit-icon__ring {
    position: absolute;
    inset: 10px;
    border-radius: 999px;
    border: 1px solid rgba(255, 255, 255, 0.4);
    animation: orbit 6s linear infinite;
}
.orbit-icon__ring--two {
    inset: 18px;
    animation-duration: 8s;
    opacity: 0.7;
}

@keyframes pulse {
    0%,
    100% {
        transform: scale(0.95);
    }
    50% {
        transform: scale(1.05);
    }
}

@keyframes orbit {
    0% {
        transform: rotateX(30deg) rotateZ(0deg);
    }
    100% {
        transform: rotateX(30deg) rotateZ(360deg);
    }
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

@media (prefers-reduced-motion: reduce) {
    .orbit-icon::before,
    .orbit-icon__core,
    .orbit-icon__ring {
        animation: none;
    }
}
</style>
