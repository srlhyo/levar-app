<template>
    <div class="tile-icon-3d" :class="toneClass">
        <div class="tile-icon-3d__glow"></div>
        <div class="tile-icon-3d__inner">
            <slot />
        </div>
    </div>
</template>

<script setup>
import { computed } from 'vue';

const props = defineProps({
    tone: {
        type: String,
        default: 'indigo',
    },
});

const toneClass = computed(() => `tile-icon-3d--${props.tone}`);
</script>

<style scoped>
.tile-icon-3d {
    position: relative;
    width: var(--tile-icon-size, 3.6rem);
    height: var(--tile-icon-size, 3.6rem);
    border-radius: 1.4rem;
    display: grid;
    place-items: center;
    border: 1px solid rgba(255, 255, 255, 0.45);
    overflow: hidden;
    box-shadow:
        inset 0 2px 8px rgba(255, 255, 255, 0.35),
        0 15px 35px rgba(15, 23, 42, 0.35);
    background-size: 250% 250%;
    animation: tileIconGradient 14s ease infinite;
}
.tile-icon-3d__inner {
    position: relative;
    z-index: 2;
    display: grid;
    place-items: center;
    color: #fff;
}
.tile-icon-3d__inner :deep(svg) {
    width: 1.5rem;
    height: 1.5rem;
    stroke-width: 1.6;
}
.tile-icon-3d__glow {
    content: '';
    position: absolute;
    inset: 0.6rem;
    border-radius: inherit;
    background: radial-gradient(circle at 30% 20%, rgba(255, 255, 255, 0.45), transparent 65%);
    filter: blur(6px);
    animation: tileIconPulse 10s ease-in-out infinite;
    z-index: 1;
}
.tile-icon-3d--indigo {
    background-image: linear-gradient(135deg, #4f46e5, #7c3aed, #14b8a6);
}
.tile-icon-3d--emerald {
    background-image: linear-gradient(135deg, #0ea5e9, #10b981, #34d399);
}
.tile-icon-3d--amber {
    background-image: linear-gradient(135deg, #f97316, #fbbf24, #fb7185);
}
.tile-icon-3d--slate {
    background-image: linear-gradient(135deg, #475569, #64748b, #94a3b8);
}
.tile-icon-3d--sky {
    background-image: linear-gradient(135deg, #0ea5e9, #38bdf8, #818cf8);
}
.tile-icon-3d--rose {
    background-image: linear-gradient(135deg, #f43f5e, #ec4899, #fb7185);
}
.tile-icon-3d--crimson {
    background-image: linear-gradient(135deg, #b91c1c, #dc2626, #ef4444);
}

@keyframes tileIconGradient {
    0% {
        background-position: 0% 50%;
        transform: rotateX(0deg);
    }
    50% {
        background-position: 100% 50%;
        transform: rotateX(4deg);
    }
    100% {
        background-position: 0% 50%;
        transform: rotateX(0deg);
    }
}

@keyframes tileIconPulse {
    0%,
    100% {
        opacity: 0.5;
        transform: translateY(0);
    }
    50% {
        opacity: 0.8;
        transform: translateY(-2px);
    }
}

@media (prefers-reduced-motion: reduce) {
    .tile-icon-3d {
        animation: none;
        transform: none;
    }
    .tile-icon-3d__glow {
        animation: none;
    }
}
</style>
