<template>
    <button
        type="button"
        class="feature-tile text-left focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 focus-visible:ring-white/80"
        :class="[gradientClass, { 'feature-tile--highlight': highlight }]"
        :style="{ '--delay': `${delay}ms` }"
        @click="$emit('select')"
    >
        <div class="flex items-center gap-5">
            <div class="feature-tile__icon" v-if="iconComponent">
                <TileIcon3D :tone="props.tone">
                    <component :is="iconComponent" class="h-5 w-5" />
                </TileIcon3D>
            </div>
            <div class="flex-1">
                <p class="text-[11px] font-semibold uppercase tracking-[0.35em] text-white/80">{{ eyebrow }}</p>
                <h3 class="text-lg font-semibold text-white sm:text-xl">{{ title }}</h3>
                <p class="text-sm text-white/90 sm:text-base">{{ subtitle }}</p>
            </div>
            <ChevronRight class="h-5 w-5 text-white/80" />
        </div>
    </button>
</template>

<script setup>
import { computed } from 'vue';
import { ChevronRight } from 'lucide-vue-next';
import TileIcon3D from '@/Components/home/TileIcon3D.vue';

const props = defineProps({
    title: {
        type: String,
        required: true,
    },
    subtitle: {
        type: String,
        required: true,
    },
    icon: {
        type: null,
        default: null,
    },
    tone: {
        type: String,
        default: 'indigo',
    },
    eyebrow: {
        type: String,
        default: 'Etapa',
    },
    delay: {
        type: Number,
        default: 0,
    },
    highlight: {
        type: Boolean,
        default: false,
    },
});

defineEmits(['select']);

const iconComponent = computed(() => props.icon);

const gradientClasses = {
    indigo: 'feature-tile--indigo',
    emerald: 'feature-tile--emerald',
    amber: 'feature-tile--amber',
    slate: 'feature-tile--slate',
};

const gradientClass = computed(() => gradientClasses[props.tone] ?? gradientClasses.indigo);
</script>

<style scoped>
.feature-tile {
    position: relative;
    opacity: 0;
    transform: translateY(12px);
    border-radius: 1.75rem;
    padding: 1.5rem;
    color: white;
    border: 1px solid rgba(255, 255, 255, 0.15);
    box-shadow: 0 25px 60px rgba(15, 23, 42, 0.25);
    backdrop-filter: blur(12px);
    overflow: hidden;
    background-size: 250% 250%;
    animation: tile-stagger 0.7s ease forwards var(--delay, 0s);
}
.feature-tile::before {
    content: '';
    position: absolute;
    inset: 0;
    background-image: inherit;
    background-size: inherit;
    animation: gradientFlow 18s ease infinite;
    z-index: -2;
}
.feature-tile::after {
    content: '';
    position: absolute;
    inset: 0;
    background: linear-gradient(180deg, rgba(255, 255, 255, 0.06), rgba(15, 23, 42, 0.15));
    opacity: 0.35;
    z-index: -1;
}
.feature-tile--highlight::after {
    background:
        linear-gradient(180deg, rgba(255, 255, 255, 0.08), rgba(15, 23, 42, 0.18)),
        radial-gradient(circle at 35% 25%, rgba(255, 255, 255, 0.35), transparent 55%);
    opacity: 0.5;
}
.feature-tile--highlight::before {
    animation-duration: 24s;
}
.feature-tile--indigo {
    background-image: linear-gradient(140deg, #6366f1, #0ea5e9, #9333ea);
}
.feature-tile--emerald {
    background-image: linear-gradient(140deg, #10b981, #34d399, #14b8a6);
}
.feature-tile--amber {
    background-image: linear-gradient(140deg, #f97316, #fbbf24, #fb7185);
}
.feature-tile--slate {
    background-image: linear-gradient(140deg, #475569, #64748b, #94a3b8);
}

@keyframes tile-stagger {
    from {
        opacity: 0;
        transform: translateY(12px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

@keyframes gradientFlow {
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

@keyframes iconPulse {
    0%,
    100% {
        transform: translateY(0);
        box-shadow: 0 10px 25px rgba(15, 23, 42, 0.25);
    }
    50% {
        transform: translateY(-4px);
        box-shadow: 0 14px 30px rgba(15, 23, 42, 0.3);
    }
}

@keyframes pulseGlow {
    0%,
    100% {
        opacity: 0.15;
    }
    50% {
        opacity: 0.35;
    }
}

@media (prefers-reduced-motion: reduce) {
    .feature-tile {
        animation: none !important;
        opacity: 1;
        transform: none;
    }
    .feature-tile::before {
        animation: none;
    }
    .feature-tile__icon :deep(.icon-pill) {
        animation: none;
    }
}
</style>
